defmodule Harald.HCI.Events.LEMeta.ConnectionCompleteTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Events.LEMeta.ConnectionComplete
  alias Harald.HCI.Commands.LEController.SetAdvertisingEnable

  test "decode/1" do
    status = 0
    connection_handle = <<1, 2>>
    role = 0x01
    peer_address_type = 0x01
    peer_address = <<1, 2, 3, 4, 5, 6>>
    connection_interval = 0x0C80
    connection_latency = 0x01F3
    supervision_timeout = 0xC80
    master_clock_accuracy = 0x01

    bin =
      <<status, connection_handle::binary-little-size(2), role, peer_address_type,
        peer_address::binary-little-size(6), connection_interval::little-size(16),
        connection_latency::little-size(16), supervision_timeout::little-size(16),
        master_clock_accuracy>>

    expected_parameters = %{
      status: status,
      connection_handle: connection_handle,
      role: role,
      peer_address_type: peer_address_type,
      peer_address: peer_address,
      connection_interval: connection_interval,
      connection_latency: connection_latency,
      supervision_timeout: supervision_timeout,
      master_clock_accuracy: master_clock_accuracy
    }

    assert {:ok, expected_parameters} == ConnectionComplete.decode(bin)
  end

  test "encode/1" do
    status = 0
    connection_handle = <<1, 2>>
    role = 0x01
    peer_address_type = 0x01
    peer_address = <<1, 2, 3, 4, 5, 6>>
    connection_interval = 0x0C80
    connection_latency = 0x01F3
    supervision_timeout = 0xC80
    master_clock_accuracy = 0x01

    expected_bin = <<
      status,
      connection_handle::binary-little-size(2),
      role,
      peer_address_type,
      peer_address::binary-little-size(6),
      connection_interval::little-size(16),
      connection_latency::little-size(16),
      supervision_timeout::little-size(16),
      master_clock_accuracy
    >>

    parameters = %{
      status: status,
      connection_handle: connection_handle,
      role: role,
      peer_address_type: peer_address_type,
      peer_address: peer_address,
      connection_interval: connection_interval,
      connection_latency: connection_latency,
      supervision_timeout: supervision_timeout,
      master_clock_accuracy: master_clock_accuracy
    }

    assert {:ok, actual_bin} = ConnectionComplete.encode(parameters)
    assert expected_bin == actual_bin
  end

  test "decode_return_parameters/1" do
    status = 1
    return_parameters = <<status>>
    expected_return_parameters = %{status: status}

    assert {:ok, expected_return_parameters} ==
             SetAdvertisingEnable.decode_return_parameters(return_parameters)
  end
end
