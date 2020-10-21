defmodule Harald.HCI.Commands.LEController.LESetEventMask do
  alias Harald.HCI.Commands.Command

  @behaviour Command

  @impl Command
  def encode(%{
        le_event_mask:
          %{
            le_connection_complete_event: _,
            le_advertising_report_event: _,
            le_connection_update_complete_event: _,
            le_read_remote_features_complete_event: _,
            le_long_term_key_request_event: _,
            le_remote_connection_parameter_request_event: _,
            le_data_length_change_event: _,
            le_read_local_p256_public_key_complete_event: _,
            le_generate_dhkey_complete_event: _,
            le_enhanced_connection_complete_event: _,
            le_directed_advertising_report_event: _,
            le_phy_update_complete_event: _,
            le_extended_advertising_report_event: _,
            le_periodic_advertising_sync_established_event: _,
            le_periodic_advertising_report_event: _,
            le_periodic_advertising_sync_lost_event: _,
            le_scan_timeout_event: _,
            le_advertising_set_terminated_event: _,
            le_scan_request_received_event: _,
            le_channel_selection_algorithm_event: _,
            le_connectionless_iq_report_event: _,
            le_connection_iq_report_event: _,
            le_cte_request_failed_event: _,
            le_periodic_advertising_sync_transfer_received_event: _,
            le_cis_established_event: _,
            le_cis_request_event: _,
            le_create_big_complete_event: _,
            le_terminate_big_complete_event: _,
            le_big_sync_established_event: _,
            le_big_sync_lost_event: _,
            le_request_peer_sca_complete_event: _,
            le_path_loss_threshold_event: _,
            le_transmit_power_reporting_event: _,
            le_biginfo_advertising_report_event: _,
            reserved: _
          } = decoded_le_event_mask
      }) do
    encoded_le_event_mask =
      Enum.into(decoded_le_event_mask, %{}, fn
        {:reserved, reserved} -> {:reserved, reserved}
        {key, true} -> {key, 1}
        {key, false} -> {key, 0}
      end)

    {:ok,
     <<
       encoded_le_event_mask.le_connection_complete_event::size(1),
       encoded_le_event_mask.le_advertising_report_event::size(1),
       encoded_le_event_mask.le_connection_update_complete_event::size(1),
       encoded_le_event_mask.le_read_remote_features_complete_event::size(1),
       encoded_le_event_mask.le_long_term_key_request_event::size(1),
       encoded_le_event_mask.le_remote_connection_parameter_request_event::size(1),
       encoded_le_event_mask.le_data_length_change_event::size(1),
       encoded_le_event_mask.le_read_local_p256_public_key_complete_event::size(1),
       encoded_le_event_mask.le_generate_dhkey_complete_event::size(1),
       encoded_le_event_mask.le_enhanced_connection_complete_event::size(1),
       encoded_le_event_mask.le_directed_advertising_report_event::size(1),
       encoded_le_event_mask.le_phy_update_complete_event::size(1),
       encoded_le_event_mask.le_extended_advertising_report_event::size(1),
       encoded_le_event_mask.le_periodic_advertising_sync_established_event::size(1),
       encoded_le_event_mask.le_periodic_advertising_report_event::size(1),
       encoded_le_event_mask.le_periodic_advertising_sync_lost_event::size(1),
       encoded_le_event_mask.le_scan_timeout_event::size(1),
       encoded_le_event_mask.le_advertising_set_terminated_event::size(1),
       encoded_le_event_mask.le_scan_request_received_event::size(1),
       encoded_le_event_mask.le_channel_selection_algorithm_event::size(1),
       encoded_le_event_mask.le_connectionless_iq_report_event::size(1),
       encoded_le_event_mask.le_connection_iq_report_event::size(1),
       encoded_le_event_mask.le_cte_request_failed_event::size(1),
       encoded_le_event_mask.le_periodic_advertising_sync_transfer_received_event::size(1),
       encoded_le_event_mask.le_cis_established_event::size(1),
       encoded_le_event_mask.le_cis_request_event::size(1),
       encoded_le_event_mask.le_create_big_complete_event::size(1),
       encoded_le_event_mask.le_terminate_big_complete_event::size(1),
       encoded_le_event_mask.le_big_sync_established_event::size(1),
       encoded_le_event_mask.le_big_sync_lost_event::size(1),
       encoded_le_event_mask.le_request_peer_sca_complete_event::size(1),
       encoded_le_event_mask.le_path_loss_threshold_event::size(1),
       encoded_le_event_mask.le_transmit_power_reporting_event::size(1),
       encoded_le_event_mask.le_biginfo_advertising_report_event::size(1),
       encoded_le_event_mask.reserved::bits-size(30)
     >>}
  end

  @impl Command
  def decode(<<
        le_connection_complete_event::size(1),
        le_advertising_report_event::size(1),
        le_connection_update_complete_event::size(1),
        le_read_remote_features_complete_event::size(1),
        le_long_term_key_request_event::size(1),
        le_remote_connection_parameter_request_event::size(1),
        le_data_length_change_event::size(1),
        le_read_local_p256_public_key_complete_event::size(1),
        le_generate_dhkey_complete_event::size(1),
        le_enhanced_connection_complete_event::size(1),
        le_directed_advertising_report_event::size(1),
        le_phy_update_complete_event::size(1),
        le_extended_advertising_report_event::size(1),
        le_periodic_advertising_sync_established_event::size(1),
        le_periodic_advertising_report_event::size(1),
        le_periodic_advertising_sync_lost_event::size(1),
        le_scan_timeout_event::size(1),
        le_advertising_set_terminated_event::size(1),
        le_scan_request_received_event::size(1),
        le_channel_selection_algorithm_event::size(1),
        le_connectionless_iq_report_event::size(1),
        le_connection_iq_report_event::size(1),
        le_cte_request_failed_event::size(1),
        le_periodic_advertising_sync_transfer_received_event::size(1),
        le_cis_established_event::size(1),
        le_cis_request_event::size(1),
        le_create_big_complete_event::size(1),
        le_terminate_big_complete_event::size(1),
        le_big_sync_established_event::size(1),
        le_big_sync_lost_event::size(1),
        le_request_peer_sca_complete_event::size(1),
        le_path_loss_threshold_event::size(1),
        le_transmit_power_reporting_event::size(1),
        le_biginfo_advertising_report_event::size(1),
        reserved::bits-size(30)
      >>) do
    encoded_le_event_mask = %{
      le_connection_complete_event: le_connection_complete_event,
      le_advertising_report_event: le_advertising_report_event,
      le_connection_update_complete_event: le_connection_update_complete_event,
      le_read_remote_features_complete_event: le_read_remote_features_complete_event,
      le_long_term_key_request_event: le_long_term_key_request_event,
      le_remote_connection_parameter_request_event: le_remote_connection_parameter_request_event,
      le_data_length_change_event: le_data_length_change_event,
      le_read_local_p256_public_key_complete_event: le_read_local_p256_public_key_complete_event,
      le_generate_dhkey_complete_event: le_generate_dhkey_complete_event,
      le_enhanced_connection_complete_event: le_enhanced_connection_complete_event,
      le_directed_advertising_report_event: le_directed_advertising_report_event,
      le_phy_update_complete_event: le_phy_update_complete_event,
      le_extended_advertising_report_event: le_extended_advertising_report_event,
      le_periodic_advertising_sync_established_event:
        le_periodic_advertising_sync_established_event,
      le_periodic_advertising_report_event: le_periodic_advertising_report_event,
      le_periodic_advertising_sync_lost_event: le_periodic_advertising_sync_lost_event,
      le_scan_timeout_event: le_scan_timeout_event,
      le_advertising_set_terminated_event: le_advertising_set_terminated_event,
      le_scan_request_received_event: le_scan_request_received_event,
      le_channel_selection_algorithm_event: le_channel_selection_algorithm_event,
      le_connectionless_iq_report_event: le_connectionless_iq_report_event,
      le_connection_iq_report_event: le_connection_iq_report_event,
      le_cte_request_failed_event: le_cte_request_failed_event,
      le_periodic_advertising_sync_transfer_received_event:
        le_periodic_advertising_sync_transfer_received_event,
      le_cis_established_event: le_cis_established_event,
      le_cis_request_event: le_cis_request_event,
      le_create_big_complete_event: le_create_big_complete_event,
      le_terminate_big_complete_event: le_terminate_big_complete_event,
      le_big_sync_established_event: le_big_sync_established_event,
      le_big_sync_lost_event: le_big_sync_lost_event,
      le_request_peer_sca_complete_event: le_request_peer_sca_complete_event,
      le_path_loss_threshold_event: le_path_loss_threshold_event,
      le_transmit_power_reporting_event: le_transmit_power_reporting_event,
      le_biginfo_advertising_report_event: le_biginfo_advertising_report_event,
      reserved: reserved
    }

    decoded_le_event_mask =
      Enum.into(encoded_le_event_mask, %{}, fn
        {:reserved, reserved} -> {:reserved, reserved}
        {key, 1} -> {key, true}
        {key, 0} -> {key, false}
      end)

    parameters = %{le_event_mask: decoded_le_event_mask}

    {:ok, parameters}
  end

  @impl Command
  def ocf(), do: 0x01
end
