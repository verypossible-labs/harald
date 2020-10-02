defmodule Harald.Transport.UART do
  @moduledoc """
  > The objective of this HCI UART Transport Layer is to make it possible to use the Bluetooth HCI
  > over a serial interface between two UARTs on the same PCB. The HCI UART Transport Layer
  > assumes that the UART communication is free from line errors.

  Reference: Version 5.0, Vol 4, Part A, 1
  """

  use GenServer
  alias Circuits.UART
  alias Harald.Transport.Adapter
  alias Harald.Transport.UART.Framing

  @behaviour Adapter

  @impl GenServer
  def init(args) do
    {:ok, pid} = UART.start_link()
    uart_opts = Keyword.merge([active: true, framing: {Framing, []}], args[:uart_opts])
    :ok = UART.open(pid, args[:device], uart_opts)
    {:ok, %{uart_pid: pid, parent_pid: args[:parent_pid]}}
  end

  @doc """
  Start the UART transport.
  """
  @impl Adapter
  def setup(parent_pid, args) do
    {:ok, pid} = GenServer.start_link(__MODULE__, Keyword.put(args, :parent_pid, parent_pid))
    {:ok, %{adapter_pid: pid}}
  end

  @impl Adapter
  def call(bin, %{adapter_pid: adapter_pid} = state) do
    :ok = GenServer.call(adapter_pid, {:call, bin})
    {:ok, state}
  end

  @impl GenServer
  def handle_call({:call, bin}, _from, %{uart_pid: uart_pid} = state) do
    {:reply, UART.write(uart_pid, bin), state}
  end

  @impl GenServer
  def handle_info({:circuits_uart, _dev, msg}, %{parent_pid: parent_pid} = state) do
    send(parent_pid, {:transport_adapter, msg})
    {:noreply, state}
  end
end
