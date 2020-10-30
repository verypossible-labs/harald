defmodule Harald.Host.ATT.ReadRspTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.ReadRsp

  test "encode/1" do
    attribute_value = <<4, 8, 15, 16, 23, 42>>
    parameters = %{attribute_value: attribute_value}
    expected_bin = <<attribute_value::binary>>
    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = ReadRsp.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    attribute_value = <<4, 8, 15, 16, 23, 42>>
    bin = <<attribute_value::binary>>
    expected_parameters = %{attribute_value: attribute_value}

    assert {:ok, expected_parameters} == ReadRsp.decode(bin)
  end

  test "opcode/0" do
    assert 0x0B == ReadRsp.opcode()
  end
end
