defmodule Harald.HCI.Events.LEMetaTest do
  use Harald.HaraldCase
  alias Harald.HCI.Events.{LEMeta, LEMeta.ConnectionComplete}

  test "decode/1" do
    sub_event_code = ConnectionComplete.sub_event_code()
    sub_event_module = ConnectionComplete
    status = 0
    connection_handle = 1
    connection_handle_rfu = 2

    decoded_connection_handle = %{
      rfu: connection_handle_rfu,
      connection_handle: connection_handle
    }

    role = 0x01
    peer_address_type = 0x01
    peer_address = <<1, 2, 3, 4, 5, 6>>
    connection_interval = 0x0C80
    connection_latency = 0x01F3
    supervision_timeout = 0xC80
    master_clock_accuracy = 0x01

    encoded_sub_event_parameters = <<
      status,
      connection_handle::little-size(12),
      connection_handle_rfu::size(4),
      role,
      peer_address_type,
      peer_address::binary-little-size(6),
      connection_interval::little-size(16),
      connection_latency::little-size(16),
      supervision_timeout::little-size(16),
      master_clock_accuracy
    >>

    decoded_subevent_parameters = %{
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

    encoded_le_meta = <<sub_event_code, encoded_sub_event_parameters::binary>>

    decoded_le_meta = %{
      sub_event: %{code: sub_event_code, module: sub_event_module},
      sub_event_parameters: decoded_subevent_parameters
    }

    assert {:ok, actual_decoded_le_meta} = LEMeta.decode(encoded_le_meta)
    assert decoded_le_meta == actual_decoded_le_meta
  end

  test "encode/1" do
    sub_event_code = ConnectionComplete.sub_event_code()
    sub_event_module = ConnectionComplete
    status = 0
    connection_handle = 1
    connection_handle_rfu = 2

    decoded_connection_handle = %{
      rfu: connection_handle_rfu,
      connection_handle: connection_handle
    }

    role = 0x01
    peer_address_type = 0x01
    peer_address = <<1, 2, 3, 4, 5, 6>>
    connection_interval = 0x0C80
    connection_latency = 0x01F3
    supervision_timeout = 0xC80
    master_clock_accuracy = 0x01

    encoded_sub_event_parameters = <<
      status,
      connection_handle::little-size(12),
      connection_handle_rfu::size(4),
      role,
      peer_address_type,
      peer_address::binary-little-size(6),
      connection_interval::little-size(16),
      connection_latency::little-size(16),
      supervision_timeout::little-size(16),
      master_clock_accuracy
    >>

    decoded_subevent_parameters = %{
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

    expected_encoded_le_meta = <<sub_event_code, encoded_sub_event_parameters::binary>>

    decoded_le_meta = %{
      sub_event: %{code: sub_event_code, module: sub_event_module},
      sub_event_parameters: decoded_subevent_parameters
    }

    assert {:ok, actual_encoded_le_meta} = LEMeta.encode(decoded_le_meta)
    assert_binaries(expected_encoded_le_meta == actual_encoded_le_meta)
  end

  test "event_code/0" do
    assert 0x3E == LEMeta.event_code()
  end
end
