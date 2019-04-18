defmodule Harald.Transport do
  @moduledoc """
  A server to manage lower level transports and parse bluetooth events.
  """

  use GenServer
  alias Harald.{HCI, LE}

  @type adapter_state :: map
  @type event :: struct() | binary()
  @type namespace :: atom
  @type handler_msg :: {:bluetooth_event, event()}

  defmodule State do
    @moduledoc false
    @enforce_keys [:adapter, :adapter_state, :handlers, :namespace]
    defstruct @enforce_keys
  end

  @doc """
  Start the transport.

  ## Options

  `:handlers` - additional processes to send Bluetooth events to
  `:namespace` - a prefix to what the transport will register its name as

  Note: `opts` is passed through to the `init/1` call.
  """
  @spec start_link(keyword) :: GenServer.server()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: name(opts[:namespace]))
  end

  @impl GenServer
  def init(opts) do
    {adapter, adapter_opts} = opts[:adapter]
    {:ok, adapter_state} = apply(adapter, :setup, [self(), adapter_opts])

    handlers = [LE | Keyword.get(opts, :handlers, [])]

    handler_pids =
      for h <- handlers do
        {:ok, pid} = apply(h, :setup, [Keyword.take(opts, [:namespace])])
        pid
      end

    {:ok,
     %State{
       adapter: adapter,
       adapter_state: adapter_state,
       handlers: handler_pids,
       namespace: Keyword.fetch!(opts, :namespace)
     }}
  end

  @doc """
  Makes a synchronous call to the configured transport adapter.
  """
  @spec call(namespace, binary()) :: any()
  def call(namespace, bin) when is_atom(namespace) and is_binary(bin) do
    namespace
    |> name()
    |> GenServer.call({:call, bin})
  end

  @impl GenServer
  def handle_continue(nil, state), do: {:noreply, state}

  def handle_continue({chip_mod, chip_args}, state) do
    {:ok, hci_commands} = chip_mod.setup(state.namespace, chip_args)

    adapter_state =
      Enum.reduce(hci_commands, state.adapter_state, fn bin, adapter_state ->
        {:ok, adapter_state} = state.adapter.call(bin, adapter_state)
        Process.sleep(50)
        adapter_state
      end)

    {:noreply, %State{state | adapter_state: adapter_state}}
  end

  @doc """
  Adds `pid` to the `namespace` transport's handlers.

  `pid` will receive messages like `t:handler_msg/0`.
  """
  def add_handler(namespace, pid) do
    namespace
    |> name()
    |> GenServer.call({:add_handler, pid})
  end

  @impl GenServer
  def handle_info({:transport_adapter, msg}, %{handlers: handlers} = state) do
    {_, data} = HCI.deserialize(msg)
    send_to_handlers(data, handlers)
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(
        {:call, bin},
        _from,
        %State{adapter: adapter, adapter_state: adapter_state} = state
      ) do
    {:ok, adapter_state} = adapter.call(bin, adapter_state)
    {:reply, :ok, %State{state | adapter_state: adapter_state}}
  end

  @impl GenServer
  def handle_call({:add_handler, pid}, _from, state) do
    {:reply, :ok, %State{state | handlers: [pid | state.handlers]}}
  end

  defp name(namespace), do: String.to_atom("#{namespace}.#{__MODULE__}")

  defp send_to_handlers(data, handlers) do
    for h <- handlers do
      send(h, {:bluetooth_event, data})
    end
  end
end
