defmodule Harald.Transport do
  @moduledoc """
  A server to manage lower level transports and parse bluetooth events.
  """

  use GenServer
  alias Harald.{HCI, LE}

  @type adapter_state :: map()
  @type handlers :: [module()]
  @type namespace :: atom()

  @typedoc """
  A callback specification for the `:handle_start` option of `start_link/1`.
  """
  @type handle_start :: {module(), atom(), list()} | (() -> handle_start_ret()) | nil

  @typedoc """
  The return value of a `handle_start()`.
  """
  @type handle_start_ret :: {:ok, [HCI.command()]}

  @typedoc """
  The shape of the message a process will receive if it is a `Harald.Transport` handler.
  """
  @type handler_msg :: {:bluetooth_event, HCI.event()}

  defmodule State do
    @moduledoc false
    @enforce_keys [:adapter, :adapter_state, :handlers, :namespace]
    defstruct @enforce_keys
  end

  @doc """
  Start the transport.

  ## Args

  ### Required

    - `:namespace` - `namespace()`. Used to reference an instance of `Harald`.

  ### Optional

    - `:handle_start` - `t::handle_start()`. A callback immediately after the transport starts,
      the callback shall return a `handle_start_ret()`. The returned HCI commands are executed
      immediately. Default `nil`.
    - `:handlers` - `handlers()`. Modules in addition to `LE` that will handle Bluetooth events.
      Default `[]`.
  """
  @spec start_link(keyword()) :: GenServer.server()
  def start_link(args) do
    unless Keyword.has_key?(args, :namespace) do
      raise "namespace is required"
    end

    name =
      args
      |> Keyword.fetch!(:namespace)
      |> name()

    GenServer.start_link(__MODULE__, args, name: name)
  end

  @impl GenServer
  def init(args) do
    {adapter, adapter_opts} = args[:adapter]
    {:ok, adapter_state} = apply(adapter, :setup, [self(), adapter_opts])
    handlers = [LE | Keyword.get(args, :handlers, [])]
    namespace = Keyword.fetch!(args, :namespace)
    handler_pids = setup_handlers(handlers, namespace)

    state = %State{
      adapter: adapter,
      adapter_state: adapter_state,
      handlers: handler_pids,
      namespace: namespace
    }

    handle_start = Keyword.get(args, :handle_start, nil)
    {:ok, state, {:continue, handle_start}}
  end

  @doc """
  Send a binary to the Bluetooth controller.
  """
  @spec send_binary(namespace, HCI.command()) :: any()
  def send_binary(namespace, bin) when is_atom(namespace) and is_binary(bin) do
    namespace
    |> name()
    |> GenServer.call({:send_binary, bin})
  end

  @impl GenServer
  def handle_continue(nil, state), do: {:noreply, state}

  def handle_continue(handle_start, state) do
    {:ok, hci_commands} = execute_handle_start(handle_start)
    adapter_state = send_binaries(hci_commands, state.adapter, state.adapter_state)
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
    _ =
      msg
      |> HCI.deserialize()
      |> notify_handlers(handlers)

    {:noreply, state}
  end

  @impl GenServer
  def handle_call(
        {:send_binary, bin},
        _from,
        %State{adapter: adapter, adapter_state: adapter_state} = state
      ) do
    {:ok, adapter_state} = adapter.send_binary(bin, adapter_state)
    {:reply, :ok, %State{state | adapter_state: adapter_state}}
  end

  @impl GenServer
  def handle_call({:add_handler, pid}, _from, state) do
    {:reply, :ok, %State{state | handlers: [pid | state.handlers]}}
  end

  defp setup_handlers(handlers, namespace) do
    for h <- handlers do
      {:ok, pid} = apply(h, :setup, [[namespace: namespace]])
      pid
    end
  end

  defp send_binaries(binaries, adapter, adapter_state) do
    Enum.reduce(binaries, adapter_state, fn bin, adapter_state ->
      {:ok, adapter_state} = adapter.send_binary(bin, adapter_state)
      adapter_state
    end)
  end

  defp execute_handle_start(handle_start) do
    case handle_start do
      {module, function, args} -> apply(module, function, args)
      function when is_function(function) -> function.()
    end
  end

  defp name(namespace), do: String.to_atom("#{namespace}.#{__MODULE__}")

  defp notify_handlers({:ok, events}, handlers) when is_list(events) do
    for e <- events do
      for h <- handlers do
        send(h, {:bluetooth_event, e})
      end
    end
  end

  defp notify_handlers({:ok, event}, handlers), do: notify_handlers({:ok, [event]}, handlers)

  defp notify_handlers({:error, _} = error, handlers) do
    notify_handlers({:ok, [error]}, handlers)
  end
end
