defmodule Harald.Host.ATT.WriteRspTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.WriteRsp

  test "encode/1" do
    parameters = %{}
    expected_bin = <<>>
    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = WriteRsp.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    bin = <<>>
    expected_parameters = %{}

    assert {:ok, expected_parameters} == WriteRsp.decode(bin)
  end

  test "opcode/0" do
    assert 0x13 == WriteRsp.opcode()
  end
end
