defmodule Harald.Host.ATT.ExchangeMTUReqTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.ExchangeMTUReq

  test "encode/1" do
    client_rx_mtu = 185
    parameters = %{client_rx_mtu: client_rx_mtu}
    expected_bin = <<client_rx_mtu::little-size(16)>>
    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = ExchangeMTUReq.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    client_rx_mtu = 185
    bin = <<client_rx_mtu::little-size(16)>>
    expected_parameters = %{client_rx_mtu: client_rx_mtu}

    assert {:ok, expected_parameters} == ExchangeMTUReq.decode(bin)
  end

  test "opcode/0" do
    assert 0x02 == ExchangeMTUReq.opcode()
  end
end
