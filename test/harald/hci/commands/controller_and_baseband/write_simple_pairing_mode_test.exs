defmodule Harald.HCI.Commands.ControllerAndBaseband.WriteSimplePairingModeTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.{Commands, Commands.Command, Commands.ControllerAndBaseband}
  alias Harald.HCI.Commands.ControllerAndBaseband.WriteSimplePairingMode

  test "decode/1" do
    simple_pairing_mode = 1
    expected_bin = <<1, 86, 12, 1, simple_pairing_mode>>

    expected_command = %Command{
      command_op_code: %{
        ocf: 0x56,
        ocf_module: WriteSimplePairingMode,
        ogf: 0x3,
        ogf_module: ControllerAndBaseband
      },
      parameters: %{simple_pairing_mode: true}
    }

    assert {:ok, expected_command} == Commands.decode(expected_bin)
  end

  test "encode/1" do
    simple_pairing_mode = 1
    expected_bin = <<1, 86, 12, 1, simple_pairing_mode>>
    expected_size = byte_size(expected_bin)
    params = %{simple_pairing_mode: true}

    assert {:ok, actual_bin} =
             Commands.encode(ControllerAndBaseband, WriteSimplePairingMode, params)

    assert expected_size == byte_size(actual_bin)
    assert expected_bin == actual_bin
  end

  test "decode_return_parameters/1" do
    status = 1
    return_parameters = <<status>>
    expected_return_parameters = %{status: status}

    assert {:ok, expected_return_parameters} ==
             WriteSimplePairingMode.decode_return_parameters(return_parameters)
  end

  test "encode_return_parameters/1" do
    status = 1
    encoded_return_parameters = <<status>>
    decoded_return_parameters = %{status: status}

    assert {:ok, encoded_return_parameters} ==
             WriteSimplePairingMode.encode_return_parameters(decoded_return_parameters)
  end
end
