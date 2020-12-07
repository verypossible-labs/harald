defmodule Harald.Host.ATT.ExecuteWriteReqTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.ExecuteWriteReq

  test "encode/1" do
    parameters = %{flags: :write_all}

    expected_bin = <<0x01>>
    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = ExecuteWriteReq.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    bin = <<0x01>>

    expected_parameters = %{flags: :write_all}

    assert {:ok, expected_parameters} == ExecuteWriteReq.decode(bin)
  end

  test "opcode/0" do
    assert 0x18 == ExecuteWriteReq.opcode()
  end
end
