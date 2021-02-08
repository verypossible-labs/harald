defmodule Harald.Host.ATT.ReadByGroupTypeRspTest do
  use ExUnit.Case, async: true
  alias Harald.Host.ATT.ReadByGroupTypeRsp

  describe "encode/1" do
    test "single" do
      length = 6

      attribute_handle = 40
      end_group_handle = 50
      attribute_value = 0x3040

      attribute_data_list = [
        %{
          attribute_handle: attribute_handle,
          end_group_handle: end_group_handle,
          attribute_value: attribute_value
        }
      ]

      parameters = %{length: length, attribute_data_list: attribute_data_list}

      expected_bin =
        <<length::size(8), attribute_handle::little-size(16), end_group_handle::little-size(16),
          attribute_value::little-size(16)>>

      expected_size = byte_size(expected_bin)

      assert {:ok, actual_bin} = ReadByGroupTypeRsp.encode(parameters)
      assert expected_bin == actual_bin
      assert expected_size == byte_size(actual_bin)
    end

    test "double" do
      length = 6

      attribute_handle = 10
      end_group_handle = 20
      attribute_value = 0x3040

      attribute_handle2 = 50
      end_group_handle2 = 60
      attribute_value2 = 0x7080

      attribute_data_list = [
        %{
          attribute_handle: attribute_handle,
          end_group_handle: end_group_handle,
          attribute_value: attribute_value
        },
        %{
          attribute_handle: attribute_handle2,
          end_group_handle: end_group_handle2,
          attribute_value: attribute_value2
        }
      ]

      parameters = %{length: length, attribute_data_list: attribute_data_list}

      expected_bin =
        <<length::size(8), attribute_handle::little-size(16), end_group_handle::little-size(16),
          attribute_value::little-size(16), attribute_handle2::little-size(16),
          end_group_handle2::little-size(16), attribute_value2::little-size(16)>>

      expected_size = byte_size(expected_bin)

      assert {:ok, actual_bin} = ReadByGroupTypeRsp.encode(parameters)
      assert expected_bin == actual_bin
      assert expected_size == byte_size(actual_bin)
    end
  end

  describe "decode/1" do
    test "single" do
      length = 6

      attribute_handle = 40
      end_group_handle = 50
      attribute_value = 0x3040

      attribute_data_list = [
        %{
          attribute_handle: attribute_handle,
          end_group_handle: end_group_handle,
          attribute_value: attribute_value
        }
      ]

      expected_parameters = %{length: length, attribute_data_list: attribute_data_list}

      bin =
        <<length::size(8), attribute_handle::little-size(16), end_group_handle::little-size(16),
          attribute_value::little-size(16)>>

      assert {:ok, expected_parameters} == ReadByGroupTypeRsp.decode(bin)
    end

    test "double" do
      length = 6

      attribute_handle = 10
      end_group_handle = 20
      attribute_value = 0x3040

      attribute_handle2 = 50
      end_group_handle2 = 60
      attribute_value2 = 0x7080

      attribute_data_list = [
        %{
          attribute_handle: attribute_handle,
          end_group_handle: end_group_handle,
          attribute_value: attribute_value
        },
        %{
          attribute_handle: attribute_handle2,
          end_group_handle: end_group_handle2,
          attribute_value: attribute_value2
        }
      ]

      expected_parameters = %{length: length, attribute_data_list: attribute_data_list}

      bin =
        <<length::size(8), attribute_handle::little-size(16), end_group_handle::little-size(16),
          attribute_value::little-size(16), attribute_handle2::little-size(16),
          end_group_handle2::little-size(16), attribute_value2::little-size(16)>>

      assert {:ok, expected_parameters} == ReadByGroupTypeRsp.decode(bin)
    end
  end

  test "opcode/0" do
    assert 0x11 == ReadByGroupTypeRsp.opcode()
  end
end
