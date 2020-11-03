defmodule Harald.Host.ATT.WriteReqTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.WriteReq

  test "encode/1" do
    attribute_handle = 185
    attribute_value = <<72, 101, 108, 108, 111>>
    parameters = %{attribute_handle: attribute_handle, attribute_value: attribute_value}
    expected_bin = <<attribute_handle::little-size(16), attribute_value::binary>>
    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = WriteReq.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    attribute_handle = 185
    attribute_value = <<72, 101, 108, 108, 111>>
    bin = <<attribute_handle::little-size(16), attribute_value::binary>>
    expected_parameters = %{attribute_handle: attribute_handle, attribute_value: attribute_value}

    assert {:ok, expected_parameters} == WriteReq.decode(bin)
  end

  test "opcode/0" do
    assert 0x12 == WriteReq.opcode()
  end
end
