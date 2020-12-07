defmodule Harald.Host.ATT.PrepareWriteReqTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.PrepareWriteReq

  test "encode/1" do
    attribute_handle = 185
    value_offset = 5
    part_attribute_value = <<72, 101, 108, 108, 111>>

    parameters = %{
      attribute_handle: attribute_handle,
      value_offset: value_offset,
      part_attribute_value: part_attribute_value
    }

    expected_bin =
      <<attribute_handle::little-size(16), value_offset::little-size(16),
        part_attribute_value::binary>>

    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = PrepareWriteReq.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    attribute_handle = 185
    value_offset = 5
    part_attribute_value = <<72, 101, 108, 108, 111>>

    bin =
      <<attribute_handle::little-size(16), value_offset::little-size(16),
        part_attribute_value::binary>>

    expected_parameters = %{
      attribute_handle: attribute_handle,
      value_offset: value_offset,
      part_attribute_value: part_attribute_value
    }

    assert {:ok, expected_parameters} == PrepareWriteReq.decode(bin)
  end

  test "opcode/0" do
    assert 0x16 == PrepareWriteReq.opcode()
  end
end
