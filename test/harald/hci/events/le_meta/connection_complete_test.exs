defmodule Harald.HCI.Events.LEMeta.ConnectionCompleteTest do
  use Harald.HaraldCase
  alias Harald.HCI.Events.LEMeta.ConnectionComplete

  test "decode/1" do
    status = 0
    connection_handle = 1
    connection_handle_rfu = 0

    decoded_connection_handle = %{
      rfu: connection_handle_rfu,
      handle: connection_handle
    }

    role = 0x01
    peer_address_type = 0x01
    peer_address = 1
    connection_interval = 0x0C80
    connection_latency = 0x01F3
    supervision_timeout = 0xC80
    master_clock_accuracy = 0x01

    bin = <<
      status,
      connection_handle::little-size(12),
      connection_handle_rfu::size(4),
      role,
      peer_address_type,
      peer_address::little-size(48),
      connection_interval::little-size(16),
      connection_latency::little-size(16),
      supervision_timeout::little-size(16),
      master_clock_accuracy
    >>

    expected_parameters = %{
      status: status,
      connection_handle: decoded_connection_handle,
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
    connection_handle = 1
    connection_handle_rfu = 0

    decoded_connection_handle = %{
      rfu: connection_handle_rfu,
      handle: connection_handle
    }

    role = 0x01
    peer_address_type = 0x01
    peer_address = 1
    connection_interval = 0x0C80
    connection_latency = 0x01F3
    supervision_timeout = 0xC80
    master_clock_accuracy = 0x01

    expected_bin = <<
      status,
      connection_handle::little-size(12),
      connection_handle_rfu::size(4),
      role,
      peer_address_type,
      peer_address::little-size(48),
      connection_interval::little-size(16),
      connection_latency::little-size(16),
      supervision_timeout::little-size(16),
      master_clock_accuracy
    >>

    parameters = %{
      status: status,
      connection_handle: decoded_connection_handle,
      role: role,
      peer_address_type: peer_address_type,
      peer_address: peer_address,
      connection_interval: connection_interval,
      connection_latency: connection_latency,
      supervision_timeout: supervision_timeout,
      master_clock_accuracy: master_clock_accuracy
    }

    assert {:ok, actual_bin} = ConnectionComplete.encode(parameters)
    assert_binaries(expected_bin == actual_bin)
  end

  test "sub_event_code/0" do
    assert 0x01 == ConnectionComplete.sub_event_code()
  end
end
