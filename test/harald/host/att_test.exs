defmodule Harald.Host.ATTTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT

  test "decode/1" do
    decoded_mtu = 185
    decoded_exchange_mtu_rsp = 2

    encoded_att = <<
      decoded_exchange_mtu_rsp,
      decoded_mtu::little-size(16)
    >>

    decoded_att_opcode = :att_exchange_mtu_rsp
    decoded_att_parameters = %{client_rx_mtu: 185}
    {:ok, decoded_att} = ATT.new(decoded_att_opcode, decoded_att_parameters)
    assert {:ok, decoded_att} == ATT.decode(encoded_att)
  end

  test "encode/1" do
    decoded_mtu = 185
    decoded_exchange_mtu_rsp = 2

    encoded_att = <<
      decoded_exchange_mtu_rsp,
      decoded_mtu::little-size(16)
    >>

    decoded_att_opcode = :att_exchange_mtu_rsp
    decoded_att_parameters = %{client_rx_mtu: 185}
    {:ok, decoded_att} = ATT.new(decoded_att_opcode, decoded_att_parameters)

    assert {:ok, encoded_att} == ATT.encode(decoded_att)
  end
end
