defmodule Harald.HCI.ACLDataTest do
  use Harald.HaraldCase
  alias Harald.HCI.ACLData
  alias Harald.Host.{ATT, L2CAP}
  alias Harald.Host.ATT.ExchangeMTUReq

  test "decode/1" do
    handle = 1

    decoded_packet_boundary_flag = %{
      description:
        "First automatically flushable packet of a higher layer message (start of an automatically-flushable L2CAP PDU).",
      value: 0b10
    }

    decoded_broadcast_flag = %{
      description: "Point-to-point (ACL-U, AMP-U, or LE-U)",
      value: 0b00
    }

    decoded_client_rx_mtu = 100
    {:ok, decoded_att_data} = ATT.new(ExchangeMTUReq, %{client_rx_mtu: decoded_client_rx_mtu})
    {:ok, decoded_l2cap_data} = L2CAP.new(ATT, decoded_att_data)

    {:ok, decoded_acl_data} =
      ACLData.new(
        handle,
        decoded_packet_boundary_flag,
        decoded_broadcast_flag,
        decoded_l2cap_data
      )

    {:ok, encoded_acl_data} = ACLData.encode(decoded_acl_data)
    assert {:ok, decoded_acl_data} == ACLData.decode(encoded_acl_data)
  end

  test "encode/1" do
    handle = 1
    packet_boundary_flag = 0b10

    decoded_packet_boundary_flag = %{
      description:
        "First automatically flushable packet of a higher layer message (start of an automatically-flushable L2CAP PDU).",
      value: packet_boundary_flag
    }

    broadcast_flag = 0b00

    decoded_broadcast_flag = %{
      description: "Point-to-point (ACL-U, AMP-U, or LE-U)",
      value: broadcast_flag
    }

    decoded_client_rx_mtu = 100
    {:ok, decoded_att_data} = ATT.new(ExchangeMTUReq, %{client_rx_mtu: decoded_client_rx_mtu})
    {:ok, decoded_l2cap_data} = L2CAP.new(ATT, decoded_att_data)
    {:ok, encoded_l2cap_data} = L2CAP.encode(decoded_l2cap_data)

    {:ok, %{data_total_length: decoded_data_total_length} = decoded_acl_data} =
      ACLData.new(
        handle,
        decoded_packet_boundary_flag,
        decoded_broadcast_flag,
        decoded_l2cap_data
      )

    encoded_indicator = 2

    encoded_data = encoded_l2cap_data
    encoded_data_total_length = <<decoded_data_total_length::little-size(16)>>

    <<encoded_handle::little-size(16)>> = <<
      broadcast_flag::size(2),
      packet_boundary_flag::size(2),
      handle::size(12)
    >>

    expected_encoded_acl_data = <<
      encoded_indicator,
      encoded_handle::size(16),
      encoded_data_total_length::binary,
      encoded_data::binary
    >>

    assert {:ok, actual_encoded_acl_data} = ACLData.encode(decoded_acl_data)
    assert_binaries(expected_encoded_acl_data == actual_encoded_acl_data)
  end
end
