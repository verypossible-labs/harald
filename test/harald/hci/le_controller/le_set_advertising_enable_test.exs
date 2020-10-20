defmodule Harald.HCI.Commands.ControllerAndBaseband.LESetAdvertisingEnableTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Commands.{Command, LEController}
  alias Harald.HCI.{Commands, Commands.LEController.LESetAdvertisingEnable}

  test "decode/1" do
    {advertising_enable_encoded, advertising_enable_decoded} = {1, true}
    parameters = <<advertising_enable_encoded>>
    parameters_length = byte_size(parameters)
    expected_bin = <<1, 0x0A, 32, parameters_length, parameters::binary>>

    expected_command = %Command{
      command_op_code: %{
        ocf: 0x0A,
        ocf_module: LESetAdvertisingEnable,
        ogf: 0x08,
        ogf_module: LEController
      },
      parameters: %{
        advertising_enable: advertising_enable_decoded
      }
    }

    assert {:ok, expected_command} == Commands.decode(expected_bin)
  end

  test "encode/1" do
    {advertising_enable_encoded, advertising_enable_decoded} = {1, true}
    parameters = <<advertising_enable_encoded>>
    parameters_length = byte_size(parameters)
    expected_bin = <<1, 0x0A, 32, parameters_length, parameters::binary>>
    expected_size = byte_size(expected_bin)

    parameters = %{advertising_enable: advertising_enable_decoded}

    assert {:ok, actual_bin} = Commands.encode(LEController, LESetAdvertisingEnable, parameters)

    assert expected_size == byte_size(actual_bin)
    assert expected_bin == actual_bin
  end
end
