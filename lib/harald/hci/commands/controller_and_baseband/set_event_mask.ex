defmodule Harald.HCI.Commands.ControllerAndBaseband.SetEventMask do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.1.
  """

  alias Harald.{HCI, HCI.Commands.Command}

  @type t() :: %{
          event_mask: %{
            inquiry_complete_event: HCI.flag(),
            inquiry_result_event: HCI.flag(),
            connection_complete_event: HCI.flag(),
            connection_request_event: HCI.flag(),
            disconnection_complete_event: HCI.flag(),
            authentication_complete_event: HCI.flag(),
            remote_name_request_complete_event: HCI.flag(),
            encryption_change_event: HCI.flag(),
            change_connection_link_key_complete_event: HCI.flag(),
            mast_link_key_complete_event: HCI.flag(),
            read_remote_supported_features_complete_event: HCI.flag(),
            read_remote_version_information_complete_event: HCI.flag(),
            qos_setup_complete_event: HCI.flag(),
            hardware_error_event: HCI.flag(),
            flush_occurred_event: HCI.flag(),
            role_change_event: HCI.flag(),
            mode_change_event: HCI.flag(),
            return_link_keys_event: HCI.flag(),
            pin_code_request_event: HCI.flag(),
            link_key_request_event: HCI.flag(),
            link_key_notification_event: HCI.flag(),
            loopback_command_event: HCI.flag(),
            data_buffer_overflow_event: HCI.flag(),
            max_slots_change_event: HCI.flag(),
            read_clock_offset_complete_event: HCI.flag(),
            connection_packet_type_changed_event: HCI.flag(),
            qos_violation_event: HCI.flag(),
            page_scan_mode_change_event: HCI.flag(),
            page_scan_repition_mode_change_event: HCI.flag(),
            flow_specification_complete_event: HCI.flag(),
            inquiry_result_with_rssi_event: HCI.flag(),
            read_remote_extended_features_complete_event: HCI.flag(),
            synchronous_connection_complete_event: HCI.flag(),
            synchronous_connection_changed_event: HCI.flag(),
            sniff_subrating_event: HCI.flag(),
            extended_inquiry_result_event: HCI.flag(),
            encryption_key_refresh_complete_event: HCI.flag(),
            io_capability_request_event: HCI.flag(),
            io_capability_response_event: HCI.flag(),
            user_confirmation_request_event: HCI.flag(),
            user_passkey_request_event: HCI.flag(),
            remote_oob_data_request_event: HCI.flag(),
            simple_pairing_complete_event: HCI.flag(),
            link_supervision_timeout_changed_event: HCI.flag(),
            enhanced_flush_complete_event: HCI.flag(),
            user_passkey_notification_event: HCI.flag(),
            keypress_notification_event: HCI.flag(),
            remote_host_supported_features_notification_event: HCI.flag(),
            le_meta_event: HCI.flag(),
            reserved_map: HCI.reserved_map()
          }
        }

  @behaviour Command

  @fields [
    :inquiry_complete_event,
    :inquiry_result_event,
    :connection_complete_event,
    :connection_request_event,
    :disconnection_complete_event,
    :authentication_complete_event,
    :remote_name_request_complete_event,
    :encryption_change_event,
    :change_connection_link_key_complete_event,
    :mast_link_key_complete_event,
    :read_remote_supported_features_complete_event,
    :read_remote_version_information_complete_event,
    :qos_setup_complete_event,
    :hardware_error_event,
    :flush_occurred_event,
    :role_change_event,
    :mode_change_event,
    :return_link_keys_event,
    :pin_code_request_event,
    :link_key_request_event,
    :link_key_notification_event,
    :loopback_command_event,
    :data_buffer_overflow_event,
    :max_slots_change_event,
    :read_clock_offset_complete_event,
    :connection_packet_type_changed_event,
    :qos_violation_event,
    :page_scan_mode_change_event,
    :page_scan_repition_mode_change_event,
    :flow_specification_complete_event,
    :inquiry_result_with_rssi_event,
    :read_remote_extended_features_complete_event,
    :synchronous_connection_complete_event,
    :synchronous_connection_changed_event,
    :sniff_subrating_event,
    :extended_inquiry_result_event,
    :encryption_key_refresh_complete_event,
    :io_capability_request_event,
    :io_capability_response_event,
    :user_confirmation_request_event,
    :user_passkey_request_event,
    :remote_oob_data_request_event,
    :simple_pairing_complete_event,
    :link_supervision_timeout_changed_event,
    :enhanced_flush_complete_event,
    :user_passkey_notification_event,
    :keypress_notification_event,
    :remote_host_supported_features_notification_event,
    :le_meta_event,
    :reserved_map
  ]

  @impl Command
  def decode(<<
        # 0 - 12
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
        # 13 - 14
        reserved_13_to_14::size(2),
        # 15 - 17
        hardware_error_event::size(1),
        flush_occurred_event::size(1),
        role_change_event::size(1),
        # 18
        reserved_18::size(1),
        # 19 - 34
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
        # 35 - 42
        reserved_35_to_42::size(8),
        # 43 - 53
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
        # 54
        reserved_54::size(1),
        # 55 - 56
        link_supervision_timeout_changed_event::size(1),
        enhanced_flush_complete_event::size(1),
        # 57
        reserved_57::size(1),
        # 58 - 61
        user_passkey_notification_event::size(1),
        keypress_notification_event::size(1),
        remote_host_supported_features_notification_event::size(1),
        le_meta_event::size(1),
        # 62 - 63
        reserved_62_to_63::size(2)
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
      flush_occurred_event: flush_occurred_event,
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
      reserved_map: %{
        (13..14) => reserved_13_to_14,
        (18..18) => reserved_18,
        (35..42) => reserved_35_to_42,
        (54..54) => reserved_54,
        (57..57) => reserved_57,
        (62..63) => reserved_62_to_63
      }
    }

    decoded_event_mask =
      Enum.into(encoded_event_mask, %{}, fn
        {:reserved_map, reserved} -> {:reserved_map, reserved}
        {key, 1} -> {key, true}
        {key, 0} -> {key, false}
      end)

    parameters = %{event_mask: decoded_event_mask}

    {:ok, parameters}
  end

  @impl Command
  def decode_return_parameters(<<status>>), do: {:ok, %{status: status}}

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
            flush_occurred_event: _,
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
            reserved_map: %{
              (13..14) => reserved_13_to_14,
              (18..18) => reserved_18,
              (35..42) => reserved_35_to_42,
              (54..54) => reserved_54,
              (57..57) => reserved_57,
              (62..63) => reserved_62_to_63
            }
          } = decoded_event_mask
      }) do
    encoded_event_mask =
      Enum.into(decoded_event_mask, %{}, fn
        {:reserved_map, reserved} -> {:reserved_map, reserved}
        {key, true} -> {key, 1}
        {key, false} -> {key, 0}
      end)

    encoded_set_event_mask = <<
      # 0 - 12
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
      # 13 - 14
      reserved_13_to_14::size(2),
      # 15 - 17
      encoded_event_mask.hardware_error_event::size(1),
      encoded_event_mask.flush_occurred_event::size(1),
      encoded_event_mask.role_change_event::size(1),
      # 18
      reserved_18::size(1),
      # 19 - 34
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
      # 35 - 42
      reserved_35_to_42::size(8),
      # 43 - 53
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
      # 54
      reserved_54::size(1),
      # 55 - 56
      encoded_event_mask.link_supervision_timeout_changed_event::size(1),
      encoded_event_mask.enhanced_flush_complete_event::size(1),
      # 57
      reserved_57::size(1),
      # 58 - 61
      encoded_event_mask.user_passkey_notification_event::size(1),
      encoded_event_mask.keypress_notification_event::size(1),
      encoded_event_mask.remote_host_supported_features_notification_event::size(1),
      encoded_event_mask.le_meta_event::size(1),
      # 62 - 63
      reserved_62_to_63::size(2)
    >>

    {:ok, encoded_set_event_mask}
  end

  @impl Command
  def encode_return_parameters(%{status: status}), do: {:ok, <<status>>}

  @doc """
  Return a map ready for encoding.

  Keys under `:event_mask` will be defaulted if not supplied.

  ## Options

  `encoded` - `boolean()`. `false`. Whether the return value is encoded or not.
  `:default` - `boolean()`. `false`. The default value for unspecified fields under the
    `:event_mask` field.
  """
  def new(%{event_mask: event_mask}, opts \\ []) do
    default = Keyword.get(opts, :default, false)

    with {:ok, mask} <- resolve_mask(event_mask, default) do
      maybe_encode(%{event_mask: mask}, Keyword.get(opts, :encoded, false))
    end
  end

  @impl Command
  def ocf(), do: 0x01

  defp maybe_encode(decoded_set_event_mask, true) do
    encode(decoded_set_event_mask)
  end

  defp maybe_encode(decoded_set_event_mask, false), do: {:ok, decoded_set_event_mask}

  defp resolve_mask(fields, default) do
    truthy_reserved = %{
      (13..14) => 3,
      (18..18) => 1,
      (35..42) => 255,
      (54..54) => 1,
      (57..57) => 1,
      (62..63) => 3
    }

    falsey_reserved = %{
      (13..14) => 0,
      (18..18) => 0,
      (35..42) => 0,
      (54..54) => 0,
      (57..57) => 0,
      (62..63) => 0
    }

    reserved_default = if default, do: truthy_reserved, else: falsey_reserved

    Enum.reduce_while(@fields, %{}, fn
      :reserved_map, acc ->
        case Map.fetch(fields, :reserved_map) do
          {:ok, value} when is_integer(value) -> {:cont, Map.put(acc, :reserved_map, value)}
          {:ok, _value} -> {:halt, {:error, :reserved_map}}
          :error -> {:cont, Map.put(acc, :reserved_map, reserved_default)}
        end

      field, acc ->
        {:cont, Map.put(acc, field, Map.get(fields, field, default))}
    end)
    |> case do
      {:error, _} = e -> e
      mask -> {:ok, mask}
    end
  end
end
