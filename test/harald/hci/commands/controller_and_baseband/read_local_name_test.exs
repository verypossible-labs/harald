defmodule Harald.HCI.Commands.ControllerAndBaseband.ReadLocalNameTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.{Commands, Commands.Command, Commands.ControllerAndBaseband}
  alias Harald.HCI.Commands.ControllerAndBaseband.ReadLocalName

  test "decode/1" do
    expected_bin = <<1, 20, 12, 0>>

    expected_command = %Command{
      command_op_code: %{
        ocf: 0x14,
        ocf_module: ReadLocalName,
        ogf: 0x3,
        ogf_module: ControllerAndBaseband
      },
      parameters: %{}
    }

    assert {:ok, expected_command} == Commands.decode(expected_bin)
  end

  test "encode/1" do
    expected_bin = <<1, 20, 12, 0>>
    expected_size = byte_size(expected_bin)
    params = %{}
    assert {:ok, actual_bin} = Commands.encode(ControllerAndBaseband, ReadLocalName, params)
    assert expected_size == byte_size(actual_bin)
    assert expected_bin == actual_bin
  end

  test "decode_return_parameters/1" do
    status = 1
    local_name = "bob"
    padded_local_name = String.pad_trailing(local_name, 248, <<0>>)
    return_parameters = <<status, padded_local_name::binary>>
    expected_return_parameters = %{status: status, local_name: padded_local_name}

    assert {:ok, expected_return_parameters} ==
             ReadLocalName.decode_return_parameters(return_parameters)
  end

  test "encode_return_parameters/1" do
    status = 1
    local_name_size = 248
    local_name = "bob"
    padded_local_name = String.pad_trailing(local_name, local_name_size, <<0>>)
    encoded_return_parameters = <<status, padded_local_name::binary-size(local_name_size)>>
    decoded_return_parameters = %{local_name: padded_local_name, status: status}

    assert {:ok, encoded_return_parameters} ==
             ReadLocalName.encode_return_parameters(decoded_return_parameters)
  end
end
