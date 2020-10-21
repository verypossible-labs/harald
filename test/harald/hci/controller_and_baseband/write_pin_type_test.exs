defmodule Harald.HCI.Commands.ControllerAndBaseband.WritePinTypeTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.{Commands, Commands.Command, Commands.ControllerAndBaseband}
  alias Harald.HCI.Commands.ControllerAndBaseband.WritePinType

  test "decode/1" do
    pin_type = 0
    expected_bin = <<1, 10, 12, 1, pin_type>>

    expected_command = %Command{
      command_op_code: %{
        ocf: 0xA,
        ocf_module: WritePinType,
        ogf: 0x3,
        ogf_module: ControllerAndBaseband
      },
      parameters: %{pin_type: :variable}
    }

    assert {:ok, expected_command} == Commands.decode(expected_bin)
  end

  test "encode/1" do
    pin_type = 0
    expected_bin = <<1, 10, 12, 1, pin_type>>
    expected_size = byte_size(expected_bin)
    params = %{pin_type: :variable}

    assert {:ok, actual_bin} = Commands.encode(ControllerAndBaseband, WritePinType, params)

    assert expected_size == byte_size(actual_bin)
    assert expected_bin == actual_bin
  end

  test "decode_return_parameters/1" do
    status = 1
    return_parameters = <<status>>
    expected_return_parameters = %{status: status}

    assert {:ok, expected_return_parameters} ==
             WritePinType.decode_return_parameters(return_parameters)
  end
end
