defmodule Harald.HCI.Commands.ControllerAndBaseband.SetEventMaskTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Commands.ControllerAndBaseband.SetEventMask

  setup :event_mask1

  test "decode/1", context do
    assert {:ok, context.event_mask1.decoded} == SetEventMask.decode(context.event_mask1.encoded)
  end

  test "decode_return_parameters/1" do
    status = 1
    return_parameters = <<status>>
    expected_return_parameters = %{status: status}

    assert {:ok, expected_return_parameters} ==
             SetEventMask.decode_return_parameters(return_parameters)
  end

  test "encode/1", context do
    assert {:ok, context.event_mask1.encoded} == SetEventMask.encode(context.event_mask1.decoded)
  end

  test "encode_return_parameters/1" do
    status = 1
    encoded_return_parameters = <<status>>
    decoded_return_parameters = %{status: status}

    assert {:ok, encoded_return_parameters} ==
             SetEventMask.encode_return_parameters(decoded_return_parameters)
  end

  describe "new/2" do
    test "default", context do
      assert {:ok, context.event_mask1.decoded} ==
               SetEventMask.new(%{event_mask: %{}}, default: true)
    end
  end

  test "ocf/0" do
    assert 0x01 == SetEventMask.ocf()
  end

  defp event_mask1(context) do
    reserved_13_to_14 = 3
    reserved_18 = 1
    reserved_35_to_42 = 255
    reserved_54 = 1
    reserved_57 = 1
    reserved_62_to_63 = 3

    event_mask_values = %{
      inquiry_complete_event: 1,
      inquiry_result_event: 1,
      connection_complete_event: 1,
      connection_request_event: 1,
      disconnection_complete_event: 1,
      authentication_complete_event: 1,
      remote_name_request_complete_event: 1,
      encryption_change_event: 1,
      change_connection_link_key_complete_event: 1,
      mast_link_key_complete_event: 1,
      read_remote_supported_features_complete_event: 1,
      read_remote_version_information_complete_event: 1,
      qos_setup_complete_event: 1,
      hardware_error_event: 1,
      flush_occurred_event: 1,
      role_change_event: 1,
      mode_change_event: 1,
      return_link_keys_event: 1,
      pin_code_request_event: 1,
      link_key_request_event: 1,
      link_key_notification_event: 1,
      loopback_command_event: 1,
      data_buffer_overflow_event: 1,
      max_slots_change_event: 1,
      read_clock_offset_complete_event: 1,
      connection_packet_type_changed_event: 1,
      qos_violation_event: 1,
      page_scan_mode_change_event: 1,
      page_scan_repition_mode_change_event: 1,
      flow_specification_complete_event: 1,
      inquiry_result_with_rssi_event: 1,
      read_remote_extended_features_complete_event: 1,
      synchronous_connection_complete_event: 1,
      synchronous_connection_changed_event: 1,
      sniff_subrating_event: 1,
      extended_inquiry_result_event: 1,
      encryption_key_refresh_complete_event: 1,
      io_capability_request_event: 1,
      io_capability_response_event: 1,
      user_confirmation_request_event: 1,
      user_passkey_request_event: 1,
      remote_oob_data_request_event: 1,
      simple_pairing_complete_event: 1,
      link_supervision_timeout_changed_event: 1,
      enhanced_flush_complete_event: 1,
      user_passkey_notification_event: 1,
      keypress_notification_event: 1,
      remote_host_supported_features_notification_event: 1,
      le_meta_event: 1,
      reserved_map: %{
        (13..14) => reserved_13_to_14,
        (18..18) => reserved_18,
        (35..42) => reserved_35_to_42,
        (54..54) => reserved_54,
        (57..57) => reserved_57,
        (62..63) => reserved_62_to_63
      }
    }

    encoded = <<
      # 0 - 12
      event_mask_values.inquiry_complete_event::size(1),
      event_mask_values.inquiry_result_event::size(1),
      event_mask_values.connection_complete_event::size(1),
      event_mask_values.connection_request_event::size(1),
      event_mask_values.disconnection_complete_event::size(1),
      event_mask_values.authentication_complete_event::size(1),
      event_mask_values.remote_name_request_complete_event::size(1),
      event_mask_values.encryption_change_event::size(1),
      event_mask_values.change_connection_link_key_complete_event::size(1),
      event_mask_values.mast_link_key_complete_event::size(1),
      event_mask_values.read_remote_supported_features_complete_event::size(1),
      event_mask_values.read_remote_version_information_complete_event::size(1),
      event_mask_values.qos_setup_complete_event::size(1),
      # 13 - 14
      reserved_13_to_14::size(2),
      # 15 - 17
      event_mask_values.hardware_error_event::size(1),
      event_mask_values.flush_occurred_event::size(1),
      event_mask_values.role_change_event::size(1),
      # 18
      reserved_18::size(1),
      # 19 - 34
      event_mask_values.mode_change_event::size(1),
      event_mask_values.return_link_keys_event::size(1),
      event_mask_values.pin_code_request_event::size(1),
      event_mask_values.link_key_request_event::size(1),
      event_mask_values.link_key_notification_event::size(1),
      event_mask_values.loopback_command_event::size(1),
      event_mask_values.data_buffer_overflow_event::size(1),
      event_mask_values.max_slots_change_event::size(1),
      event_mask_values.read_clock_offset_complete_event::size(1),
      event_mask_values.connection_packet_type_changed_event::size(1),
      event_mask_values.qos_violation_event::size(1),
      event_mask_values.page_scan_mode_change_event::size(1),
      event_mask_values.page_scan_repition_mode_change_event::size(1),
      event_mask_values.flow_specification_complete_event::size(1),
      event_mask_values.inquiry_result_with_rssi_event::size(1),
      event_mask_values.read_remote_extended_features_complete_event::size(1),
      # 35 - 42
      reserved_35_to_42::size(8),
      # 43 - 53
      event_mask_values.synchronous_connection_complete_event::size(1),
      event_mask_values.synchronous_connection_changed_event::size(1),
      event_mask_values.sniff_subrating_event::size(1),
      event_mask_values.extended_inquiry_result_event::size(1),
      event_mask_values.encryption_key_refresh_complete_event::size(1),
      event_mask_values.io_capability_request_event::size(1),
      event_mask_values.io_capability_response_event::size(1),
      event_mask_values.user_confirmation_request_event::size(1),
      event_mask_values.user_passkey_request_event::size(1),
      event_mask_values.remote_oob_data_request_event::size(1),
      event_mask_values.simple_pairing_complete_event::size(1),
      # 54
      reserved_54::size(1),
      # 55 - 56
      event_mask_values.link_supervision_timeout_changed_event::size(1),
      event_mask_values.enhanced_flush_complete_event::size(1),
      # 57
      reserved_57::size(1),
      # 58 - 61
      event_mask_values.user_passkey_notification_event::size(1),
      event_mask_values.keypress_notification_event::size(1),
      event_mask_values.remote_host_supported_features_notification_event::size(1),
      event_mask_values.le_meta_event::size(1),
      # 62 - 63
      reserved_62_to_63::size(2)
    >>

    event_mask_decoded_values =
      Enum.into(event_mask_values, %{}, fn
        {:reserved_map, reserved} -> {:reserved_map, reserved}
        {key, 1} -> {key, true}
        {key, 0} -> {key, false}
      end)

    decoded = %{event_mask: event_mask_decoded_values}
    Map.put(context, :event_mask1, %{encoded: encoded, decoded: decoded})
  end
end
