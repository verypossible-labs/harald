defmodule Harald.Host.ATTTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT
  alias Harald.Host.ATT.ExchangeMTUReq

  test "decode/1" do
    decoded_mtu = 185
    decoded_exchange_mtu_req = 2

    encoded_att = <<
      decoded_exchange_mtu_req,
      decoded_mtu::little-size(16)
    >>

    opcode_module = ExchangeMTUReq
    decoded_att_parameters = %{client_rx_mtu: 185}
    {:ok, decoded_att} = ATT.new(opcode_module, decoded_att_parameters)

    assert {:ok, decoded_att} == ATT.decode(encoded_att)
  end

  test "encode/1" do
    decoded_mtu = 185
    decoded_exchange_mtu_req = 2

    encoded_att = <<
      decoded_exchange_mtu_req,
      decoded_mtu::little-size(16)
    >>

    opcode_module = ExchangeMTUReq
    decoded_att_parameters = %{client_rx_mtu: 185}
    {:ok, decoded_att} = ATT.new(opcode_module, decoded_att_parameters)

    assert {:ok, encoded_att} == ATT.encode(decoded_att)
  end

  test "id/1" do
    assert 0x04 == ATT.id()
  end
end
