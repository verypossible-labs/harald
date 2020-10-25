defmodule Harald.HCI.Commands.ControllerAndBaseband.SetEventMaskTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Commands.{Command, ControllerAndBaseband}
  alias Harald.HCI.{Commands, Commands.ControllerAndBaseband.SetEventMask}

  test "decode/1" do
    decoded_event_mask = %{
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
      flush_occurred_evnet: 1,
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
      le_meta_event: 1
    }

    event_mask = <<
      decoded_event_mask.inquiry_complete_event::size(1),
      decoded_event_mask.inquiry_result_event::size(1),
      decoded_event_mask.connection_complete_event::size(1),
      decoded_event_mask.connection_request_event::size(1),
      decoded_event_mask.disconnection_complete_event::size(1),
      decoded_event_mask.authentication_complete_event::size(1),
      decoded_event_mask.remote_name_request_complete_event::size(1),
      decoded_event_mask.encryption_change_event::size(1),
      decoded_event_mask.change_connection_link_key_complete_event::size(1),
      decoded_event_mask.mast_link_key_complete_event::size(1),
      decoded_event_mask.read_remote_supported_features_complete_event::size(1),
      decoded_event_mask.read_remote_version_information_complete_event::size(1),
      decoded_event_mask.qos_setup_complete_event::size(1),
      0::size(1),
      0::size(1),
      decoded_event_mask.hardware_error_event::size(1),
      decoded_event_mask.flush_occurred_evnet::size(1),
      decoded_event_mask.role_change_event::size(1),
      0::size(1),
      decoded_event_mask.mode_change_event::size(1),
      decoded_event_mask.return_link_keys_event::size(1),
      decoded_event_mask.pin_code_request_event::size(1),
      decoded_event_mask.link_key_request_event::size(1),
      decoded_event_mask.link_key_notification_event::size(1),
      decoded_event_mask.loopback_command_event::size(1),
      decoded_event_mask.data_buffer_overflow_event::size(1),
      decoded_event_mask.max_slots_change_event::size(1),
      decoded_event_mask.read_clock_offset_complete_event::size(1),
      decoded_event_mask.connection_packet_type_changed_event::size(1),
      decoded_event_mask.qos_violation_event::size(1),
      decoded_event_mask.page_scan_mode_change_event::size(1),
      decoded_event_mask.page_scan_repition_mode_change_event::size(1),
      decoded_event_mask.flow_specification_complete_event::size(1),
      decoded_event_mask.inquiry_result_with_rssi_event::size(1),
      decoded_event_mask.read_remote_extended_features_complete_event::size(1),
      0::size(1),
      0::size(1),
      0::size(1),
      0::size(1),
      0::size(1),
      0::size(1),
      0::size(1),
      0::size(1),
      decoded_event_mask.synchronous_connection_complete_event::size(1),
      decoded_event_mask.synchronous_connection_changed_event::size(1),
      decoded_event_mask.sniff_subrating_event::size(1),
      decoded_event_mask.extended_inquiry_result_event::size(1),
      decoded_event_mask.encryption_key_refresh_complete_event::size(1),
      decoded_event_mask.io_capability_request_event::size(1),
      decoded_event_mask.io_capability_response_event::size(1),
      decoded_event_mask.user_confirmation_request_event::size(1),
      decoded_event_mask.user_passkey_request_event::size(1),
      decoded_event_mask.remote_oob_data_request_event::size(1),
      decoded_event_mask.simple_pairing_complete_event::size(1),
      decoded_event_mask.link_supervision_timeout_changed_event::size(1),
      decoded_event_mask.enhanced_flush_complete_event::size(1),
      decoded_event_mask.user_passkey_notification_event::size(1),
      decoded_event_mask.keypress_notification_event::size(1),
      decoded_event_mask.remote_host_supported_features_notification_event::size(1),
      decoded_event_mask.le_meta_event::size(1)
    >>

    reserved = 1

    decoded_event_mask = %{
      inquiry_complete_event: true,
      inquiry_result_event: true,
      connection_complete_event: true,
      connection_request_event: true,
      disconnection_complete_event: true,
      authentication_complete_event: true,
      remote_name_request_complete_event: true,
      encryption_change_event: true,
      change_connection_link_key_complete_event: true,
      mast_link_key_complete_event: true,
      read_remote_supported_features_complete_event: true,
      read_remote_version_information_complete_event: true,
      qos_setup_complete_event: true,
      hardware_error_event: true,
      flush_occurred_evnet: true,
      role_change_event: true,
      mode_change_event: true,
      return_link_keys_event: true,
      pin_code_request_event: true,
      link_key_request_event: true,
      link_key_notification_event: true,
      loopback_command_event: true,
      data_buffer_overflow_event: true,
      max_slots_change_event: true,
      read_clock_offset_complete_event: true,
      connection_packet_type_changed_event: true,
      qos_violation_event: true,
      page_scan_mode_change_event: true,
      page_scan_repition_mode_change_event: true,
      flow_specification_complete_event: true,
      inquiry_result_with_rssi_event: true,
      read_remote_extended_features_complete_event: true,
      synchronous_connection_complete_event: true,
      synchronous_connection_changed_event: true,
      sniff_subrating_event: true,
      extended_inquiry_result_event: true,
      encryption_key_refresh_complete_event: true,
      io_capability_request_event: true,
      io_capability_response_event: true,
      user_confirmation_request_event: true,
      user_passkey_request_event: true,
      remote_oob_data_request_event: true,
      simple_pairing_complete_event: true,
      link_supervision_timeout_changed_event: true,
      enhanced_flush_complete_event: true,
      user_passkey_notification_event: true,
      keypress_notification_event: true,
      remote_host_supported_features_notification_event: true,
      le_meta_event: true,
      reserved: <<reserved::size(4)>>
    }

    parameters = <<event_mask::bits, 1::size(4)>>
    parameters_length = byte_size(parameters)
    expected_bin = <<1, 1, 12, parameters_length, parameters::bits>>

    expected_command = %Command{
      command_op_code: %{
        ocf: 0x01,
        ocf_module: SetEventMask,
        ogf: 0x03,
        ogf_module: ControllerAndBaseband
      },
      parameters: %{
        event_mask: decoded_event_mask
      }
    }

    assert {:ok, expected_command} == Commands.decode(expected_bin)
  end

  test "decode_return_parameters/1" do
    status = 1
    return_parameters = <<status>>
    expected_return_parameters = %{status: status}

    assert {:ok, expected_return_parameters} ==
             SetEventMask.decode_return_parameters(return_parameters)
  end

  test "encode/1" do
    decoded_event_mask = %{
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
      flush_occurred_evnet: 1,
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
      reserved: <<1::size(4)>>
    }

    falsey = 0

    event_mask = <<
      decoded_event_mask.inquiry_complete_event::size(1),
      decoded_event_mask.inquiry_result_event::size(1),
      decoded_event_mask.connection_complete_event::size(1),
      decoded_event_mask.connection_request_event::size(1),
      decoded_event_mask.disconnection_complete_event::size(1),
      decoded_event_mask.authentication_complete_event::size(1),
      decoded_event_mask.remote_name_request_complete_event::size(1),
      decoded_event_mask.encryption_change_event::size(1),
      decoded_event_mask.change_connection_link_key_complete_event::size(1),
      decoded_event_mask.mast_link_key_complete_event::size(1),
      decoded_event_mask.read_remote_supported_features_complete_event::size(1),
      decoded_event_mask.read_remote_version_information_complete_event::size(1),
      decoded_event_mask.qos_setup_complete_event::size(1),
      falsey::size(1),
      falsey::size(1),
      decoded_event_mask.hardware_error_event::size(1),
      decoded_event_mask.flush_occurred_evnet::size(1),
      decoded_event_mask.role_change_event::size(1),
      falsey::size(1),
      decoded_event_mask.mode_change_event::size(1),
      decoded_event_mask.return_link_keys_event::size(1),
      decoded_event_mask.pin_code_request_event::size(1),
      decoded_event_mask.link_key_request_event::size(1),
      decoded_event_mask.link_key_notification_event::size(1),
      decoded_event_mask.loopback_command_event::size(1),
      decoded_event_mask.data_buffer_overflow_event::size(1),
      decoded_event_mask.max_slots_change_event::size(1),
      decoded_event_mask.read_clock_offset_complete_event::size(1),
      decoded_event_mask.connection_packet_type_changed_event::size(1),
      decoded_event_mask.qos_violation_event::size(1),
      decoded_event_mask.page_scan_mode_change_event::size(1),
      decoded_event_mask.page_scan_repition_mode_change_event::size(1),
      decoded_event_mask.flow_specification_complete_event::size(1),
      decoded_event_mask.inquiry_result_with_rssi_event::size(1),
      decoded_event_mask.read_remote_extended_features_complete_event::size(1),
      falsey::size(1),
      falsey::size(1),
      falsey::size(1),
      falsey::size(1),
      falsey::size(1),
      falsey::size(1),
      falsey::size(1),
      falsey::size(1),
      decoded_event_mask.synchronous_connection_complete_event::size(1),
      decoded_event_mask.synchronous_connection_changed_event::size(1),
      decoded_event_mask.sniff_subrating_event::size(1),
      decoded_event_mask.extended_inquiry_result_event::size(1),
      decoded_event_mask.encryption_key_refresh_complete_event::size(1),
      decoded_event_mask.io_capability_request_event::size(1),
      decoded_event_mask.io_capability_response_event::size(1),
      decoded_event_mask.user_confirmation_request_event::size(1),
      decoded_event_mask.user_passkey_request_event::size(1),
      decoded_event_mask.remote_oob_data_request_event::size(1),
      decoded_event_mask.simple_pairing_complete_event::size(1),
      decoded_event_mask.link_supervision_timeout_changed_event::size(1),
      decoded_event_mask.enhanced_flush_complete_event::size(1),
      decoded_event_mask.user_passkey_notification_event::size(1),
      decoded_event_mask.keypress_notification_event::size(1),
      decoded_event_mask.remote_host_supported_features_notification_event::size(1),
      decoded_event_mask.le_meta_event::size(1)
    >>

    reserved = 1

    decoded_event_mask = %{
      inquiry_complete_event: true,
      inquiry_result_event: true,
      connection_complete_event: true,
      connection_request_event: true,
      disconnection_complete_event: true,
      authentication_complete_event: true,
      remote_name_request_complete_event: true,
      encryption_change_event: true,
      change_connection_link_key_complete_event: true,
      mast_link_key_complete_event: true,
      read_remote_supported_features_complete_event: true,
      read_remote_version_information_complete_event: true,
      qos_setup_complete_event: true,
      hardware_error_event: true,
      flush_occurred_evnet: true,
      role_change_event: true,
      mode_change_event: true,
      return_link_keys_event: true,
      pin_code_request_event: true,
      link_key_request_event: true,
      link_key_notification_event: true,
      loopback_command_event: true,
      data_buffer_overflow_event: true,
      max_slots_change_event: true,
      read_clock_offset_complete_event: true,
      connection_packet_type_changed_event: true,
      qos_violation_event: true,
      page_scan_mode_change_event: true,
      page_scan_repition_mode_change_event: true,
      flow_specification_complete_event: true,
      inquiry_result_with_rssi_event: true,
      read_remote_extended_features_complete_event: true,
      synchronous_connection_complete_event: true,
      synchronous_connection_changed_event: true,
      sniff_subrating_event: true,
      extended_inquiry_result_event: true,
      encryption_key_refresh_complete_event: true,
      io_capability_request_event: true,
      io_capability_response_event: true,
      user_confirmation_request_event: true,
      user_passkey_request_event: true,
      remote_oob_data_request_event: true,
      simple_pairing_complete_event: true,
      link_supervision_timeout_changed_event: true,
      enhanced_flush_complete_event: true,
      user_passkey_notification_event: true,
      keypress_notification_event: true,
      remote_host_supported_features_notification_event: true,
      le_meta_event: true,
      reserved: <<reserved::size(4)>>
    }

    parameters = <<event_mask::bits, 1::size(4)>>
    parameters_length = byte_size(parameters)
    expected_bin = <<1, 1, 12, parameters_length, parameters::binary>>
    expected_size = byte_size(expected_bin)
    parameters = %{event_mask: decoded_event_mask}

    assert {:ok, actual_bin} = Commands.encode(ControllerAndBaseband, SetEventMask, parameters)
    assert expected_size == byte_size(actual_bin)
    assert expected_bin == actual_bin
  end

  test "encode_return_parameters/1" do
    status = 1
    encoded_return_parameters = <<status>>
    decoded_return_parameters = %{status: status}

    assert {:ok, encoded_return_parameters} ==
             SetEventMask.encode_return_parameters(decoded_return_parameters)
  end

  test "ocf/0" do
    assert 0x01 == SetEventMask.ocf()
  end
end
