defmodule Harald.Host.ATT.ReadBlobRspTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.ReadBlobRsp

  test "encode/1" do
    part_attribute_value = <<4, 8, 15, 16, 23, 42>>
    parameters = %{part_attribute_value: part_attribute_value}
    expected_bin = <<part_attribute_value::binary>>
    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = ReadBlobRsp.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    part_attribute_value = <<4, 8, 15, 16, 23, 42>>
    bin = <<part_attribute_value::binary>>
    expected_parameters = %{part_attribute_value: part_attribute_value}

    assert {:ok, expected_parameters} == ReadBlobRsp.decode(bin)
  end

  test "opcode/0" do
    assert 0x0D == ReadBlobRsp.opcode()
  end
end
