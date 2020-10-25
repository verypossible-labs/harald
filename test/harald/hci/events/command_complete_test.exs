defmodule Harald.HCI.Events.CommandCompleteTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Events
  alias Harald.HCI.Events.CommandComplete
  alias Harald.HCI.Commands.{ControllerAndBaseband, ControllerAndBaseband.ReadLocalName}

  doctest Events, import: true

  test "decode/1" do
    num_hci_command_packets = 10
    local_name = String.pad_trailing("bob", 248, <<0>>)
    status = 0
    encoded_return_parameters = <<status, local_name::binary>>
    decoded_return_parameters = %{local_name: local_name, status: status}
    command_op_code = <<20, 12>>
    bin = <<num_hci_command_packets>> <> command_op_code <> encoded_return_parameters

    expected = %{
      command_op_code: %{
        ocf: 0x14,
        ocf_module: ReadLocalName,
        ogf: 0x03,
        ogf_module: ControllerAndBaseband
      },
      num_hci_command_packets: num_hci_command_packets,
      return_parameters: decoded_return_parameters
    }

    assert {:ok, actual} = CommandComplete.decode(bin)
    assert expected == actual
  end

  test "encode/1" do
    num_hci_command_packets = 10
    local_name = String.pad_trailing("bob", 248, <<0>>)
    status = 0
    encoded_return_parameters = <<status, local_name::binary>>
    decoded_return_parameters = %{local_name: local_name, status: status}
    command_op_code = <<20, 12>>
    expected = <<num_hci_command_packets>> <> command_op_code <> encoded_return_parameters

    parameters = %{
      command_op_code: %{
        ocf: 0x14,
        ocf_module: ReadLocalName,
        ogf: 0x03,
        ogf_module: ControllerAndBaseband
      },
      num_hci_command_packets: num_hci_command_packets,
      return_parameters: decoded_return_parameters
    }

    assert {:ok, actual} = CommandComplete.encode(parameters)
    assert expected == actual
  end

  test "event_code/0" do
    assert 0x0E == CommandComplete.event_code()
  end
end
