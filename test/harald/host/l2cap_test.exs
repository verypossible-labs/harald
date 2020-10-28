defmodule Harald.Host.L2CAPTest do
  use ExUnit.Case, async: true
  alias Harald.Host.{ATT, L2CAP}
  alias Harald.Host.ATT.ExchangeMTUReq

  test "decode/1" do
    decoded_mtu = 185
    decoded_exchange_mtu_rsp = 2

    encoded_att_data = <<
      decoded_exchange_mtu_rsp,
      decoded_mtu::little-size(16)
    >>

    decoded_att_length = byte_size(encoded_att_data)
    decoded_channel_id = 4

    encoded_l2cap = <<
      decoded_att_length::little-size(16),
      decoded_channel_id::little-size(16),
      encoded_att_data::binary
    >>

    opcode_module = ExchangeMTUReq
    decoded_att_parameters = %{client_rx_mtu: 185}
    {:ok, decoded_att} = ATT.new(opcode_module, decoded_att_parameters)
    {:ok, decoded_l2cap} = L2CAP.new(ATT, decoded_att)

    assert {:ok, decoded_l2cap} == L2CAP.decode(encoded_l2cap)
  end

  test "encode/1" do
    decoded_mtu = 185
    decoded_exchange_mtu_rsp = 2

    encoded_att_data = <<
      decoded_exchange_mtu_rsp,
      decoded_mtu::little-size(16)
    >>

    decoded_att_length = byte_size(encoded_att_data)
    decoded_channel_id = 4

    encoded_l2cap = <<
      decoded_att_length::little-size(16),
      decoded_channel_id::little-size(16),
      encoded_att_data::binary
    >>

    decoded_att_opcode = ExchangeMTUReq
    decoded_att_parameters = %{client_rx_mtu: 185}
    {:ok, decoded_att} = ATT.new(decoded_att_opcode, decoded_att_parameters)
    {:ok, decoded_l2cap} = L2CAP.new(ATT, decoded_att)

    assert {:ok, encoded_l2cap} == L2CAP.encode(decoded_l2cap)
  end
end
