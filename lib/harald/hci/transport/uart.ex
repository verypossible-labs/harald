defmodule Harald.HCI.Transport.UART do
  @moduledoc """
  Reference: version 5.0, vol 4, part A, 1.
  """

  use GenServer
  use Hook
  alias Harald.HCI.{Packet, Transport}
  alias Harald.HCI.Transport.{Adapter, UART.Framing}

  @behaviour Adapter

  @impl GenServer
  def init(args) do
    {:ok, pid} = hook(Circuits.UART).start_link()
    adapter_opts = [active: true, framing: {Framing, []}, speed: 115_200, flow_control: :hardware]
    :ok = hook(Circuits.UART).open(pid, args[:device], adapter_opts)
    {:ok, %{uart_pid: pid, transport_pid: args[:transport_pid]}}
  end

  @impl Adapter
  def setup(opts) do
    with {true, :device} <- {Keyword.has_key?(opts, :device), :device} do
      {:ok, pid} = GenServer.start_link(__MODULE__, opts)
      {:ok, %{adapter_pid: pid}}
    else
      {false, :device} -> {:error, {:args, %{device: ["required"]}}}
    end
  end

  @impl GenServer
  def handle_call({:write, bin}, _from, %{uart_pid: uart_pid} = state) do
    with :ok <- hook(Circuits.UART).write(uart_pid, bin) do
      {:reply, :ok, state}
    else
      :error -> {:reply, {:error, :circuits_uart_write}}
    end
  end

  @impl GenServer
  def handle_info(
        {:circuits_uart, _dev, indicator_and_packet},
        %{transport_pid: transport_pid} = state
      ) do
    event_indicator = Packet.indicator(:event)
    acl_data_indicator = Packet.indicator(:acl_data)
    synchronous_data_indicator = Packet.indicator(:synchronous_data)

    tagged_payload =
      case indicator_and_packet do
        <<^acl_data_indicator, packet::binary()>> ->
          Harald.decode_acl_data(packet)

        <<^synchronous_data_indicator, packet::binary()>> ->
          Harald.decode_synchronous_data(packet)

        <<^event_indicator, packet::binary()>> ->
          Harald.decode_event(packet)
      end

    :ok = Transport.publish(transport_pid, tagged_payload)
    {:noreply, state}
  end

  @impl Adapter
  def write(bin, state) do
    :ok = GenServer.call(state.adapter_pid, {:write, bin})
    {:ok, state}
  end
end
