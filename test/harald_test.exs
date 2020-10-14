defmodule HaraldTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Transport
  alias Harald.HCI.Commands.{ControllerAndBaseband, ControllerAndBaseband.ReadLocalName}

  describe "start_link/1" do
    test "ok" do
      assert {:ok, pid} =
               Harald.start_link(
                 adapter: Transport.UART,
                 adapter_opts: [device: "/dev/ttyS3"],
                 id: :bt
               )

      assert is_pid(pid)
    end
  end

  describe "write/2" do
    test "ok" do
      id = :bt
      circuits_uart_pid = :pid
      device = "/dev/ttyS3"
      Hook.callback(Circuits.UART, :start_link, fn -> {:ok, circuits_uart_pid} end)

      Hook.callback(Circuits.UART, :open, fn ^circuits_uart_pid, ^device, _adapter_opts -> :ok end)

      {:ok, _pid} =
        Harald.start_link(
          adapter: Harald.HCI.Transport.UART,
          adapter_opts: [device: device],
          id: id
        )

      {:ok, bin} = Harald.encode_command(ControllerAndBaseband, ReadLocalName)
      Hook.callback(Circuits.UART, :write, fn ^circuits_uart_pid, ^bin -> :ok end)
      assert :ok = Harald.write(id, bin)
      Hook.assert()
    end
  end

  describe "subscribe/1" do
    test "ok" do
      id = :bt
      circuits_uart_pid = :pid
      device = "/dev/ttyS3"
      Hook.callback(Circuits.UART, :start_link, fn -> {:ok, circuits_uart_pid} end)

      Hook.callback(Circuits.UART, :open, fn ^circuits_uart_pid, ^device, _adapter_opts -> :ok end)

      {:ok, pid} =
        Harald.start_link(
          adapter: Harald.HCI.Transport.UART,
          adapter_opts: [device: device],
          id: id
        )

      assert MapSet.new() == :sys.get_state(pid).subscriber_pids
      :ok = Harald.subscribe(id)
      expected = MapSet.new([self()])
      assert expected == :sys.get_state(pid).subscriber_pids

      # pids don't accumulate
      :ok = Harald.subscribe(id)
      assert expected == :sys.get_state(pid).subscriber_pids

      Hook.assert()
    end
  end
end
