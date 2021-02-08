defmodule Harald.HCI.Transport do
  @moduledoc """
  A server to manage lower level transports and parse bluetooth events.
  """

  use GenServer

  @type adapter() :: module()
  @type adapter_opts() :: keyword(any())
  @type id() :: atom()

  @typedoc """
  ## Options

  `:adapter_opts` - `adapter_opts()`. `[]`. The options provided to the adapter on start.
  `:adapter` - `adapter()`. Required. The transport implementation module.
  `:id` - `atom()`. Required. Uniquely identifies this transport instance to Harald.
  `:subscriber_pids` - `MapSet.t()`. `#MapSet<[]>`. The pids that received data and events will be
    sent to.
  """
  @type start_link_opts() :: [
          {:adapter, adapter()},
          {:adapter_opts, adapter_opts()},
          {:id, id()},
          {:subscriber_pids, MapSet.t()}
        ]

  @impl GenServer
  def handle_call({:write, bin}, _from, state) do
    {:ok, adapter_state} = state.adapter.write(bin, state.adapter_state)
    {:reply, :ok, Map.put(state, :adapter_state, adapter_state)}
  end

  def handle_call({:subscribe, pid}, _from, state) do
    {:reply, :ok, Map.put(state, :subscriber_pids, MapSet.put(state.subscriber_pids, pid))}
  end

  def handle_call({:publish, data_or_event}, _from, state) do
    for pid <- state.subscriber_pids do
      send(pid, {Harald, data_or_event})
    end

    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_continue(:setup, state) do
    {:ok, adapter_state} =
      state.adapter_opts
      |> Keyword.put(:transport_pid, self())
      |> state.adapter.setup()

    {:noreply, Map.put(state, :adapter_state, adapter_state)}
  end

  @impl GenServer
  def init(args) do
    state = %{
      adapter: args.adapter,
      adapter_opts: args.adapter_opts,
      adapter_state: %{},
      id: args.id,
      name: args.name,
      subscriber_pids: args.subscriber_pids
    }

    {:ok, state, {:continue, :setup}}
  end

  @doc "Returns the registered name derived from `id`."
  def name(id), do: String.to_atom("Harald.Transport.Name.#{id}")

  def publish(transport_pid, data_or_event) do
    GenServer.call(transport_pid, {:publish, data_or_event})
  end

  @doc """
  Start the transport.
  """
  @spec start_link(start_link_opts()) :: GenServer.on_start()
  def start_link(opts) do
    opts_map = Map.new(opts)

    with {true, :adapter} <- {Map.has_key?(opts_map, :adapter), :adapter},
         {true, :id} <- {Map.has_key?(opts_map, :id), :id} do
      name = name(opts_map.id)

      args =
        opts_map
        |> Map.put(:name, name)
        |> Map.put_new(:adapter_opts, [])
        |> Map.update(:subscriber_pids, MapSet.new(), &Enum.into(&1, MapSet.new()))

      GenServer.start_link(__MODULE__, args, name: name)
    else
      {false, :adapter} -> {:error, {:args, %{adapter: ["required"]}}}
      {false, :id} -> {:error, {:args, %{id: ["required"]}}}
    end
  end

  def subscribe(id, pid \\ self()) do
    id
    |> name()
    |> GenServer.call({:subscribe, pid})
  end

  def write(id, bin) when is_binary(bin) do
    id
    |> name()
    |> GenServer.call({:write, bin})
  end
end
