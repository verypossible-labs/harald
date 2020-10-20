defmodule Harald.HCI.Commands.ControllerAndBaseband.LESetAdvertisingDataTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Commands.{Command, LEController}
  alias Harald.HCI.{Commands, Commands.LEController.LESetAdvertisingData}

  test "decode/1" do
    advertising_data = <<1, 3, 3, 7>>
    advertising_data_length = byte_size(advertising_data)
    length = advertising_data_length + 1
    expected_bin = <<1, 8, 32, length, advertising_data_length, advertising_data::binary>>

    expected_command = %Command{
      command_op_code: %{
        ocf: 0x08,
        ocf_module: LESetAdvertisingData,
        ogf: 0x08,
        ogf_module: LEController
      },
      parameters: %{
        advertising_data_length: advertising_data_length,
        advertising_data: advertising_data
      }
    }

    assert {:ok, expected_command} == Commands.decode(expected_bin)
  end

  test "encode/1" do
    advertising_data = <<1, 3, 3, 7>>
    advertising_data_length = byte_size(advertising_data)
    length = advertising_data_length + 1
    expected_bin = <<1, 8, 32, length, advertising_data_length, advertising_data::binary>>
    expected_size = byte_size(expected_bin)

    params = %{
      advertising_data_length: advertising_data_length,
      advertising_data: advertising_data
    }

    assert {:ok, actual_bin} = Commands.encode(LEController, LESetAdvertisingData, params)

    assert expected_size == byte_size(actual_bin)
    assert expected_bin == actual_bin
  end
end
