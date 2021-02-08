defmodule Harald.Host.ATT.ReadReqTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.ReadReq

  test "encode/1" do
    attribute_handle = 185
    parameters = %{attribute_handle: attribute_handle}
    expected_bin = <<attribute_handle::little-size(16)>>
    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = ReadReq.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    attribute_handle = 185
    bin = <<attribute_handle::little-size(16)>>
    expected_parameters = %{attribute_handle: attribute_handle}

    assert {:ok, expected_parameters} == ReadReq.decode(bin)
  end

  test "opcode/0" do
    assert 0x0A == ReadReq.opcode()
  end
end
