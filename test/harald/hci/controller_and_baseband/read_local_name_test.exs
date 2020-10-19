defmodule Harald.HCI.Commands.ControllerAndBaseband.ReadLocalNameTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.{Commands, Commands.Command, Commands.ControllerAndBaseband}
  alias Harald.HCI.Commands.ControllerAndBaseband.ReadLocalName

  test "decode/1" do
    expected_bin = <<1, 20, 12, 0>>

    expected_command = %Command{
      command_op_code: %{
        ocf: 20,
        ocf_module: ReadLocalName,
        ogf: 3,
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
end
