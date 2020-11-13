defmodule HaraldTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.{ACLData, Transport}
  alias Harald.HCI.Commands.{ControllerAndBaseband, ControllerAndBaseband.ReadLocalName}
  alias Harald.Host.{ATT, L2CAP}
  alias Harald.Host.ATT.ExchangeMTUReq

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

      Hook.callback(Circuits.UART, :start_link, fn [name: Harald.HCI.Transport.UART.Circuits.UART] ->
        {:ok, circuits_uart_pid}
      end)

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

      Hook.callback(Circuits.UART, :start_link, fn [name: Harald.HCI.Transport.UART.Circuits.UART] ->
        {:ok, circuits_uart_pid}
      end)

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

  test "decode_acl_data/1" do
    handle = 1
    encoded_broadcast_flag = 0b00
    encoded_packet_boundary_flag = 0b01

    decoded_packet_boundary_flag = %{
      description: "Continuing fragment of a higher layer message",
      value: encoded_packet_boundary_flag
    }

    decoded_broadcast_flag = %{
      description: "Point-to-point (ACL-U, AMP-U, or LE-U)",
      value: encoded_broadcast_flag
    }

    decoded_mtu = 185
    decoded_exchange_mtu_rsp = 2

    encoded_att_data = <<
      decoded_exchange_mtu_rsp,
      decoded_mtu::little-size(16)
    >>

    decoded_att_length = byte_size(encoded_att_data)
    decoded_channel_id = 4

    encoded_l2cap_data = <<
      decoded_att_length::little-size(16),
      decoded_channel_id::little-size(16),
      encoded_att_data::binary
    >>

    opcode_module = ExchangeMTUReq
    decoded_att_parameters = %{client_rx_mtu: 185}
    {:ok, decoded_att} = ATT.new(opcode_module, decoded_att_parameters)
    {:ok, decoded_l2cap_data} = L2CAP.new(ATT, decoded_att)
    data_total_length = byte_size(encoded_l2cap_data)

    decoded_acl_data = %ACLData{
      handle: handle,
      packet_boundary_flag: decoded_packet_boundary_flag,
      broadcast_flag: decoded_broadcast_flag,
      data_total_length: data_total_length,
      data: decoded_l2cap_data
    }

    encoded_acl_data = <<
      2,
      handle::little-size(12),
      encoded_packet_boundary_flag::size(2),
      encoded_broadcast_flag::size(2),
      data_total_length::little-size(16),
      encoded_l2cap_data::binary
    >>

    assert {:ok, decoded_acl_data} == Harald.decode_acl_data(encoded_acl_data)
  end

  test "encode_acl_data/1" do
    hci_packet_type = 2
    handle = 1
    encoded_broadcast_flag = 0b00
    encoded_packet_boundary_flag = 0b01

    decoded_packet_boundary_flag = %{
      description: "Continuing fragment of a higher layer message",
      value: encoded_packet_boundary_flag
    }

    decoded_broadcast_flag = %{
      description: "Point-to-point (ACL-U, AMP-U, or LE-U)",
      value: encoded_broadcast_flag
    }

    decoded_mtu = 185
    decoded_exchange_mtu_rsp = 2

    encoded_att_data = <<
      decoded_exchange_mtu_rsp,
      decoded_mtu::little-size(16)
    >>

    decoded_att_length = byte_size(encoded_att_data)
    decoded_channel_id = 4

    encoded_l2cap_data = <<
      decoded_att_length::little-size(16),
      decoded_channel_id::little-size(16),
      encoded_att_data::binary
    >>

    opcode_module = ExchangeMTUReq
    decoded_att_parameters = %{client_rx_mtu: 185}
    {:ok, decoded_att} = ATT.new(opcode_module, decoded_att_parameters)
    {:ok, decoded_l2cap_data} = L2CAP.new(ATT, decoded_att)
    data_total_length = byte_size(encoded_l2cap_data)

    decoded_acl_data = %ACLData{
      handle: handle,
      packet_boundary_flag: decoded_packet_boundary_flag,
      broadcast_flag: decoded_broadcast_flag,
      data_total_length: data_total_length,
      data: decoded_l2cap_data
    }

    encoded_acl_data = <<
      hci_packet_type::size(8),
      handle::little-size(12),
      encoded_packet_boundary_flag::size(2),
      encoded_broadcast_flag::size(2),
      data_total_length::little-size(16),
      encoded_l2cap_data::binary
    >>

    assert {:ok, encoded_acl_data} == Harald.encode_acl_data(decoded_acl_data)
  end
end
