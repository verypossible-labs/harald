defmodule Harald.Host.ATT.ReadBlobReqTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.ReadBlobReq

  test "encode/1" do
    attribute_handle = 185
    value_offset = 20
    parameters = %{attribute_handle: attribute_handle, value_offset: value_offset}
    expected_bin = <<attribute_handle::little-size(16), value_offset::little-size(16)>>
    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = ReadBlobReq.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    attribute_handle = 185
    value_offset = 20
    bin = <<attribute_handle::little-size(16), value_offset::little-size(16)>>
    expected_parameters = %{attribute_handle: attribute_handle, value_offset: value_offset}

    assert {:ok, expected_parameters} == ReadBlobReq.decode(bin)
  end

  test "opcode/0" do
    assert 0x0C == ReadBlobReq.opcode()
  end
end
