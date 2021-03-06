defmodule Harald.HCI.Commands.ControllerAndBaseband.SetAdvertisingEnableTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Commands.{Command, LEController}
  alias Harald.HCI.{Commands, Commands.LEController.SetAdvertisingEnable}

  test "decode/1" do
    {advertising_enable_encoded, advertising_enable_decoded} = {1, true}
    parameters = <<advertising_enable_encoded>>
    parameters_length = byte_size(parameters)
    expected_bin = <<1, 0x0A, 32, parameters_length, parameters::binary>>

    expected_command = %Command{
      command_op_code: %{
        ocf: 0x0A,
        ocf_module: SetAdvertisingEnable,
        ogf: 0x08,
        ogf_module: LEController
      },
      parameters: %{
        advertising_enable: advertising_enable_decoded
      }
    }

    assert {:ok, expected_command} == Commands.decode(expected_bin)
  end

  test "decode_return_parameters/1" do
    encoded_status = 1
    decoded_status = "Unknown HCI Command"
    return_parameters = <<encoded_status>>
    expected_return_parameters = %{status: decoded_status}

    assert {:ok, expected_return_parameters} ==
             SetAdvertisingEnable.decode_return_parameters(return_parameters)
  end

  test "encode/1" do
    {advertising_enable_encoded, advertising_enable_decoded} = {1, true}
    parameters = <<advertising_enable_encoded>>
    parameters_length = byte_size(parameters)
    expected_bin = <<1, 0x0A, 32, parameters_length, parameters::binary>>
    expected_size = byte_size(expected_bin)

    parameters = %{advertising_enable: advertising_enable_decoded}

    assert {:ok, actual_bin} = Commands.encode(LEController, SetAdvertisingEnable, parameters)

    assert expected_size == byte_size(actual_bin)
    assert expected_bin == actual_bin
  end

  test "encode_return_parameters/1" do
    decoded_status = "Unknown HCI Command"
    encoded_status = 1
    return_parameters = %{status: decoded_status}
    expected_return_parameters = <<encoded_status>>

    assert {:ok, expected_return_parameters} ==
             SetAdvertisingEnable.encode_return_parameters(return_parameters)
  end

  test "ocf/0" do
    assert 0x0A == SetAdvertisingEnable.ocf()
  end
end
