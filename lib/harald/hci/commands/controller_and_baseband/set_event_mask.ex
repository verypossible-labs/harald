defmodule Harald.HCI.Commands.ControllerAndBaseband.SetEventMask do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.1.
  """

  alias Harald.HCI.Commands.Command

  @behaviour Command

  @impl Command
  def encode(%{
        event_mask:
          %{
            inquiry_complete_event: _,
            inquiry_result_event: _,
            connection_complete_event: _,
            connection_request_event: _,
            disconnection_complete_event: _,
            authentication_complete_event: _,
            remote_name_request_complete_event: _,
            encryption_change_event: _,
            change_connection_link_key_complete_event: _,
            mast_link_key_complete_event: _,
            read_remote_supported_features_complete_event: _,
            read_remote_version_information_complete_event: _,
            qos_setup_complete_event: _,
            hardware_error_event: _,
            flush_occurred_evnet: _,
            role_change_event: _,
            mode_change_event: _,
            return_link_keys_event: _,
            pin_code_request_event: _,
            link_key_request_event: _,
            link_key_notification_event: _,
            loopback_command_event: _,
            data_buffer_overflow_event: _,
            max_slots_change_event: _,
            read_clock_offset_complete_event: _,
            connection_packet_type_changed_event: _,
            qos_violation_event: _,
            page_scan_mode_change_event: _,
            page_scan_repition_mode_change_event: _,
            flow_specification_complete_event: _,
            inquiry_result_with_rssi_event: _,
            read_remote_extended_features_complete_event: _,
            synchronous_connection_complete_event: _,
            synchronous_connection_changed_event: _,
            sniff_subrating_event: _,
            extended_inquiry_result_event: _,
            encryption_key_refresh_complete_event: _,
            io_capability_request_event: _,
            io_capability_response_event: _,
            user_confirmation_request_event: _,
            user_passkey_request_event: _,
            remote_oob_data_request_event: _,
            simple_pairing_complete_event: _,
            link_supervision_timeout_changed_event: _,
            enhanced_flush_complete_event: _,
            user_passkey_notification_event: _,
            keypress_notification_event: _,
            remote_host_supported_features_notification_event: _,
            le_meta_event: _,
            reserved: <<_::bits-size(4)>>
          } = decoded_event_mask
      }) do
    encoded_event_mask =
      Enum.into(decoded_event_mask, %{}, fn
        {:reserved, reserved} -> {:reserved, reserved}
        {key, true} -> {key, 1}
        {key, false} -> {key, 0}
      end)

    falsey = 0

    {:ok,
     <<
       encoded_event_mask.inquiry_complete_event::size(1),
       encoded_event_mask.inquiry_result_event::size(1),
       encoded_event_mask.connection_complete_event::size(1),
       encoded_event_mask.connection_request_event::size(1),
       encoded_event_mask.disconnection_complete_event::size(1),
       encoded_event_mask.authentication_complete_event::size(1),
       encoded_event_mask.remote_name_request_complete_event::size(1),
       encoded_event_mask.encryption_change_event::size(1),
       encoded_event_mask.change_connection_link_key_complete_event::size(1),
       encoded_event_mask.mast_link_key_complete_event::size(1),
       encoded_event_mask.read_remote_supported_features_complete_event::size(1),
       encoded_event_mask.read_remote_version_information_complete_event::size(1),
       encoded_event_mask.qos_setup_complete_event::size(1),
       falsey::size(1),
       falsey::size(1),
       encoded_event_mask.hardware_error_event::size(1),
       encoded_event_mask.flush_occurred_evnet::size(1),
       encoded_event_mask.role_change_event::size(1),
       falsey::size(1),
       encoded_event_mask.mode_change_event::size(1),
       encoded_event_mask.return_link_keys_event::size(1),
       encoded_event_mask.pin_code_request_event::size(1),
       encoded_event_mask.link_key_request_event::size(1),
       encoded_event_mask.link_key_notification_event::size(1),
       encoded_event_mask.loopback_command_event::size(1),
       encoded_event_mask.data_buffer_overflow_event::size(1),
       encoded_event_mask.max_slots_change_event::size(1),
       encoded_event_mask.read_clock_offset_complete_event::size(1),
       encoded_event_mask.connection_packet_type_changed_event::size(1),
       encoded_event_mask.qos_violation_event::size(1),
       encoded_event_mask.page_scan_mode_change_event::size(1),
       encoded_event_mask.page_scan_repition_mode_change_event::size(1),
       encoded_event_mask.flow_specification_complete_event::size(1),
       encoded_event_mask.inquiry_result_with_rssi_event::size(1),
       encoded_event_mask.read_remote_extended_features_complete_event::size(1),
       falsey::size(1),
       falsey::size(1),
       falsey::size(1),
       falsey::size(1),
       falsey::size(1),
       falsey::size(1),
       falsey::size(1),
       falsey::size(1),
       encoded_event_mask.synchronous_connection_complete_event::size(1),
       encoded_event_mask.synchronous_connection_changed_event::size(1),
       encoded_event_mask.sniff_subrating_event::size(1),
       encoded_event_mask.extended_inquiry_result_event::size(1),
       encoded_event_mask.encryption_key_refresh_complete_event::size(1),
       encoded_event_mask.io_capability_request_event::size(1),
       encoded_event_mask.io_capability_response_event::size(1),
       encoded_event_mask.user_confirmation_request_event::size(1),
       encoded_event_mask.user_passkey_request_event::size(1),
       encoded_event_mask.remote_oob_data_request_event::size(1),
       encoded_event_mask.simple_pairing_complete_event::size(1),
       encoded_event_mask.link_supervision_timeout_changed_event::size(1),
       encoded_event_mask.enhanced_flush_complete_event::size(1),
       encoded_event_mask.user_passkey_notification_event::size(1),
       encoded_event_mask.keypress_notification_event::size(1),
       encoded_event_mask.remote_host_supported_features_notification_event::size(1),
       encoded_event_mask.le_meta_event::size(1),
       encoded_event_mask.reserved::bits
     >>}
  end

  @impl Command
  def decode(<<
        inquiry_complete_event::size(1),
        inquiry_result_event::size(1),
        connection_complete_event::size(1),
        connection_request_event::size(1),
        disconnection_complete_event::size(1),
        authentication_complete_event::size(1),
        remote_name_request_complete_event::size(1),
        encryption_change_event::size(1),
        change_connection_link_key_complete_event::size(1),
        mast_link_key_complete_event::size(1),
        read_remote_supported_features_complete_event::size(1),
        read_remote_version_information_complete_event::size(1),
        qos_setup_complete_event::size(1),
        _::size(1),
        _::size(1),
        hardware_error_event::size(1),
        flush_occurred_evnet::size(1),
        role_change_event::size(1),
        _::size(1),
        mode_change_event::size(1),
        return_link_keys_event::size(1),
        pin_code_request_event::size(1),
        link_key_request_event::size(1),
        link_key_notification_event::size(1),
        loopback_command_event::size(1),
        data_buffer_overflow_event::size(1),
        max_slots_change_event::size(1),
        read_clock_offset_complete_event::size(1),
        connection_packet_type_changed_event::size(1),
        qos_violation_event::size(1),
        page_scan_mode_change_event::size(1),
        page_scan_repition_mode_change_event::size(1),
        flow_specification_complete_event::size(1),
        inquiry_result_with_rssi_event::size(1),
        read_remote_extended_features_complete_event::size(1),
        _::size(1),
        _::size(1),
        _::size(1),
        _::size(1),
        _::size(1),
        _::size(1),
        _::size(1),
        _::size(1),
        synchronous_connection_complete_event::size(1),
        synchronous_connection_changed_event::size(1),
        sniff_subrating_event::size(1),
        extended_inquiry_result_event::size(1),
        encryption_key_refresh_complete_event::size(1),
        io_capability_request_event::size(1),
        io_capability_response_event::size(1),
        user_confirmation_request_event::size(1),
        user_passkey_request_event::size(1),
        remote_oob_data_request_event::size(1),
        simple_pairing_complete_event::size(1),
        link_supervision_timeout_changed_event::size(1),
        enhanced_flush_complete_event::size(1),
        user_passkey_notification_event::size(1),
        keypress_notification_event::size(1),
        remote_host_supported_features_notification_event::size(1),
        le_meta_event::size(1),
        reserved::bits-size(4)
      >>) do
    encoded_event_mask = %{
      inquiry_complete_event: inquiry_complete_event,
      inquiry_result_event: inquiry_result_event,
      connection_complete_event: connection_complete_event,
      connection_request_event: connection_request_event,
      disconnection_complete_event: disconnection_complete_event,
      authentication_complete_event: authentication_complete_event,
      remote_name_request_complete_event: remote_name_request_complete_event,
      encryption_change_event: encryption_change_event,
      change_connection_link_key_complete_event: change_connection_link_key_complete_event,
      mast_link_key_complete_event: mast_link_key_complete_event,
      read_remote_supported_features_complete_event:
        read_remote_supported_features_complete_event,
      read_remote_version_information_complete_event:
        read_remote_version_information_complete_event,
      qos_setup_complete_event: qos_setup_complete_event,
      hardware_error_event: hardware_error_event,
      flush_occurred_evnet: flush_occurred_evnet,
      role_change_event: role_change_event,
      mode_change_event: mode_change_event,
      return_link_keys_event: return_link_keys_event,
      pin_code_request_event: pin_code_request_event,
      link_key_request_event: link_key_request_event,
      link_key_notification_event: link_key_notification_event,
      loopback_command_event: loopback_command_event,
      data_buffer_overflow_event: data_buffer_overflow_event,
      max_slots_change_event: max_slots_change_event,
      read_clock_offset_complete_event: read_clock_offset_complete_event,
      connection_packet_type_changed_event: connection_packet_type_changed_event,
      qos_violation_event: qos_violation_event,
      page_scan_mode_change_event: page_scan_mode_change_event,
      page_scan_repition_mode_change_event: page_scan_repition_mode_change_event,
      flow_specification_complete_event: flow_specification_complete_event,
      inquiry_result_with_rssi_event: inquiry_result_with_rssi_event,
      read_remote_extended_features_complete_event: read_remote_extended_features_complete_event,
      synchronous_connection_complete_event: synchronous_connection_complete_event,
      synchronous_connection_changed_event: synchronous_connection_changed_event,
      sniff_subrating_event: sniff_subrating_event,
      extended_inquiry_result_event: extended_inquiry_result_event,
      encryption_key_refresh_complete_event: encryption_key_refresh_complete_event,
      io_capability_request_event: io_capability_request_event,
      io_capability_response_event: io_capability_response_event,
      user_confirmation_request_event: user_confirmation_request_event,
      user_passkey_request_event: user_passkey_request_event,
      remote_oob_data_request_event: remote_oob_data_request_event,
      simple_pairing_complete_event: simple_pairing_complete_event,
      link_supervision_timeout_changed_event: link_supervision_timeout_changed_event,
      enhanced_flush_complete_event: enhanced_flush_complete_event,
      user_passkey_notification_event: user_passkey_notification_event,
      keypress_notification_event: keypress_notification_event,
      remote_host_supported_features_notification_event:
        remote_host_supported_features_notification_event,
      le_meta_event: le_meta_event,
      reserved: reserved
    }

    decoded_event_mask =
      Enum.into(encoded_event_mask, %{}, fn
        {:reserved, reserved} -> {:reserved, reserved}
        {key, 1} -> {key, true}
        {key, 0} -> {key, false}
      end)

    parameters = %{event_mask: decoded_event_mask}

    {:ok, parameters}
  end

  @impl Command
  def decode_return_parameters(<<status>>), do: {:ok, %{status: status}}

  @impl Command
  def encode_return_parameters(%{status: status}), do: {:ok, <<status>>}

  @impl Command
  def ocf(), do: 0x01
end
