defmodule Harald.HCI.EventsTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Events
  alias Harald.HCI.{Events.CommandComplete, Events.Event}

  doctest Events, import: true

  describe "decode" do
    num_hci_command_packets = 10
    length = 4
    return_parameters = <<254, 0>>
    command_op_code = <<1, 55>>
    event_code_command_complete = 14

    bin =
      <<event_code_command_complete, length, num_hci_command_packets>> <>
        command_op_code <> return_parameters

    actual = Events.decode(bin)

    expected =
      {:ok,
       %Event{
         event_code: CommandComplete,
         parameters: %{
           command_op_code: %{
             ocf: 769,
             ocf_module: :not_implemented,
             ogf: 13,
             ogf_module: :not_implemented
           },
           num_hci_command_packets: num_hci_command_packets,
           return_parameters: return_parameters
         }
       }}

    assert expected == actual
  end
end
