defmodule Harald.Transport do
  @moduledoc """
  A server to manage lower level transports and parse bluetooth events.
  """

  use GenServer
  alias Harald.{HCI, LE}

  @type adapter_state :: map
  @type command :: binary
  @type namespace :: atom

  defmodule State do
    @moduledoc false
    @enforce_keys [:adapter, :adapter_state, :handlers]
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

    {:ok, %State{adapter: adapter, adapter_state: adapter_state, handlers: handler_pids}}
  end

  @doc """
  Send an HCI command to the Bluetooth HCI.
  """
  @spec send_command(namespace, command) :: any
  def send_command(namespace, command) when is_atom(namespace) and is_binary(command) do
    namespace
    |> name()
    |> GenServer.call({:send_command, command})
  end

  @impl GenServer
  def handle_info({:transport_adapter, msg}, %{handlers: handlers} = state) do
    {_, data} = HCI.deserialize(msg)
    send_to_handlers(data, handlers)
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(
        {:send_command, command},
        _from,
        %State{adapter: adapter, adapter_state: adapter_state} = state
      ) do
    {:ok, adapter_state} = adapter.send_command(command, adapter_state)
    {:reply, :ok, %State{state | adapter_state: adapter_state}}
  end

  defp name(namespace), do: String.to_atom("#{namespace}.#{__MODULE__}")

  defp send_to_handlers(data, handlers) do
    for h <- handlers do
      send(h, {:bluetooth_event, data})
    end
  end
end
