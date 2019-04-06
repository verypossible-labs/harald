defmodule Harald.Transport.UART do
  @moduledoc """
  The UART bluetooth transport.
  """

  use GenServer
  alias Circuits.UART
  alias Harald.Transport.Adapter
  alias Harald.Transport.UART.Framing

  @behaviour Adapter

  ## Adapter Behaviour

  @doc """
  Start the UART transport.
  """
  @impl Adapter
  def setup(parent_pid, args) do
    {:ok, pid} = GenServer.start_link(__MODULE__, Keyword.put(args, :parent_pid, parent_pid))
    {:ok, %{adapter_pid: pid}}
  end

  @impl Adapter
  def send_command(command, %{adapter_pid: adapter_pid} = state) do
    :ok = GenServer.call(adapter_pid, {:send_command, command})
    {:ok, state}
  end

  ## Server Callbacks

  @impl GenServer
  def init(args) do
    {:ok, pid} = UART.start_link()
    uart_opts = Keyword.merge([active: true, framing: {Framing, []}], args[:uart_opts])
    :ok = UART.open(pid, args[:device], uart_opts)
    {:ok, %{uart_pid: pid, parent_pid: args[:parent_pid]}}
  end

  @impl GenServer
  def handle_call({:send_command, message}, _from, %{uart_pid: uart_pid} = state) do
    {:reply, UART.write(uart_pid, <<1>> <> message), state}
  end

  @impl GenServer
  def handle_info({:circuits_uart, _dev, msg}, %{parent_pid: parent_pid} = state) do
    send(parent_pid, {:transport_adapter, msg})
    {:noreply, state}
  end
end
