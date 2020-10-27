defmodule Harald.HCI.ACLDataTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.ACLData
  alias Harald.Host.{ATT, L2CAP}

  test "decode/1" do
    handle = <<1, 2::size(4)>>
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

    decoded_att_opcode = :att_exchange_mtu_rsp
    decoded_att_parameters = %{client_rx_mtu: 185}
    {:ok, decoded_att} = ATT.new(decoded_att_opcode, decoded_att_parameters)
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
      handle::bits-size(12),
      encoded_packet_boundary_flag::size(2),
      encoded_broadcast_flag::size(2),
      data_total_length::little-size(16),
      encoded_l2cap_data::binary
    >>

    assert {:ok, decoded_acl_data} == ACLData.decode(encoded_acl_data)
  end

  test "encode/1" do
    handle = <<1, 2::size(4)>>
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

    decoded_att_opcode = :att_exchange_mtu_rsp
    decoded_att_parameters = %{client_rx_mtu: 185}
    {:ok, decoded_att} = ATT.new(decoded_att_opcode, decoded_att_parameters)
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
      handle::bits-size(12),
      encoded_packet_boundary_flag::size(2),
      encoded_broadcast_flag::size(2),
      data_total_length::little-size(16),
      encoded_l2cap_data::binary
    >>

    assert {:ok, encoded_acl_data} == ACLData.encode(decoded_acl_data)
  end
end
