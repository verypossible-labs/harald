defmodule Harald.HCI.Commands.ControllerAndBaseband.WriteLocalNameTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.{Commands, Commands.Command, Commands.ControllerAndBaseband}
  alias Harald.HCI.Commands.ControllerAndBaseband.WriteLocalName

  test "decode/1" do
    name = "bob"
    expected_name = String.pad_trailing(name, 248, <<0>>)
    expected_bin = <<1, 19, 12, 248, expected_name::binary>>
    local_name = String.pad_trailing(name, 248, <<0>>)

    expected_command = %Command{
      command_op_code: %{
        ocf: 0x13,
        ocf_module: WriteLocalName,
        ogf: 0x3,
        ogf_module: ControllerAndBaseband
      },
      parameters: %{read_local_name: local_name}
    }

    assert {:ok, expected_command} == Commands.decode(expected_bin)
  end

  test "encode/1" do
    name = "bob"
    expected_name = String.pad_trailing(name, 248, <<0>>)
    expected_bin = <<1, 19, 12, 248, expected_name::binary>>
    expected_size = byte_size(expected_bin)
    params = %{local_name: "bob"}
    assert {:ok, actual_bin} = Commands.encode(ControllerAndBaseband, WriteLocalName, params)
    assert expected_size == byte_size(actual_bin)
    assert expected_bin == actual_bin
  end

  test "decode_return_parameters/1" do
    status = 1
    return_parameters = <<status>>
    expected_return_parameters = %{status: status}

    assert {:ok, expected_return_parameters} ==
             WriteLocalName.decode_return_parameters(return_parameters)
  end
end
