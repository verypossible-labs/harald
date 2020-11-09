defmodule Harald.Host.ATT.ReadByGroupTypeReqTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.ReadByGroupTypeReq

  test "encode/1" do
    starting_handle = 1
    ending_handle = 0xFFFF
    attribute_group_type = 0x2800

    parameters = %{
      starting_handle: starting_handle,
      ending_handle: ending_handle,
      attribute_group_type: attribute_group_type
    }

    expected_bin =
      <<starting_handle::little-size(16), ending_handle::little-size(16),
        attribute_group_type::little-size(16)>>

    expected_size = byte_size(expected_bin)

    assert {:ok, actual_bin} = ReadByGroupTypeReq.encode(parameters)
    assert expected_bin == actual_bin
    assert expected_size == byte_size(actual_bin)
  end

  test "decode/1" do
    starting_handle = 1
    ending_handle = 0xFFFF
    attribute_group_type = 0x2800

    bin =
      <<starting_handle::little-size(16), ending_handle::little-size(16),
        attribute_group_type::little-size(16)>>

    expected_parameters = %{
      starting_handle: starting_handle,
      ending_handle: ending_handle,
      attribute_group_type: attribute_group_type
    }

    assert {:ok, expected_parameters} == ReadByGroupTypeReq.decode(bin)
  end

  test "opcode/0" do
    assert 0x10 == ReadByGroupTypeReq.opcode()
  end
end
