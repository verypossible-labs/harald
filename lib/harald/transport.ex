defmodule Harald.Transport do
  @moduledoc """
  A server to manage lower level transports and parse bluetooth events.
  """

  use GenServer
  alias Harald.HCI.Event

  @type adapter_state :: map
  @type command :: binary
  @type namespace :: atom

  defmodule State do
    @moduledoc false
    @enforce_keys [:adapter, :adapter_state, :handlers]
    defstruct @enforce_keys
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

  def name(namespace), do: String.to_atom("#{namespace}.#{__MODULE__}")

  @doc """
  Start the transport.
  """
  @spec start_link(keyword) :: GenServer.server()
  def start_link(passed_args) do
    args = Keyword.put_new(passed_args, :handlers, default_handlers())

    GenServer.start_link(__MODULE__, args, name: name(args[:namespace]))
  end

  @doc """
  The default handlers that Transport will start.
  """
  @spec default_handlers() :: [Harald.LE, ...]
  def default_handlers, do: [Harald.LE]

  @impl GenServer
  def init(args) do
    {adapter, adapter_args} = args[:adapter]
    {:ok, adapter_state} = apply(adapter, :setup, [self(), adapter_args])

    handlers =
      for h <- args[:handlers] do
        {:ok, pid} = apply(h, :setup, [Keyword.take(args, [:namespace])])
        pid
      end

    {:ok, %State{adapter: adapter, adapter_state: adapter_state, handlers: handlers}}
  end

  @impl GenServer
  def handle_info({:transport_adapter, msg}, %{handlers: handlers} = state) do
    _ = msg |> Event.parse() |> send_to_handlers(handlers)
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

  defp send_to_handlers(events, handlers) when is_list(events) do
    for e <- events do
      for h <- handlers do
        send(h, {:bluetooth_event, e})
      end
    end
  end

  defp send_to_handlers(event, handlers), do: send_to_handlers([event], handlers)
end
