defmodule Harald.HCI.Commands.LEController.SetEventMaskTest do
  use Harald.HaraldCase, async: true
  alias Harald.HCI.Commands.{Command, LEController}
  alias Harald.HCI.{Commands, Commands.LEController.SetEventMask}

  test "decode/1" do
    decoded_le_event_mask = %{
      le_connection_complete_event: 1,
      le_advertising_report_event: 1,
      le_connection_update_complete_event: 1,
      le_read_remote_features_complete_event: 1,
      le_long_term_key_request_event: 1,
      le_remote_connection_parameter_request_event: 1,
      le_data_length_change_event: 1,
      le_read_local_p256_public_key_complete_event: 1,
      le_generate_dhkey_complete_event: 1,
      le_enhanced_connection_complete_event: 1,
      le_directed_advertising_report_event: 1,
      le_phy_update_complete_event: 1,
      le_extended_advertising_report_event: 1,
      le_periodic_advertising_sync_established_event: 1,
      le_periodic_advertising_report_event: 1,
      le_periodic_advertising_sync_lost_event: 1,
      le_scan_timeout_event: 1,
      le_advertising_set_terminated_event: 1,
      le_scan_request_received_event: 1,
      le_channel_selection_algorithm_event: 1,
      le_connectionless_iq_report_event: 1,
      le_connection_iq_report_event: 1,
      le_cte_request_failed_event: 1,
      le_periodic_advertising_sync_transfer_received_event: 1,
      le_cis_established_event: 1,
      le_cis_request_event: 1,
      le_create_big_complete_event: 1,
      le_terminate_big_complete_event: 1,
      le_big_sync_established_event: 1,
      le_big_sync_lost_event: 1,
      le_request_peer_sca_complete_event: 1,
      le_path_loss_threshold_event: 1,
      le_transmit_power_reporting_event: 1,
      le_biginfo_advertising_report_event: 1,
      reserved: 0
    }

    <<encoded_set_event_mask::little-size(64)>> = <<
      decoded_le_event_mask.reserved::size(30),
      decoded_le_event_mask.le_biginfo_advertising_report_event::size(1),
      decoded_le_event_mask.le_transmit_power_reporting_event::size(1),
      decoded_le_event_mask.le_path_loss_threshold_event::size(1),
      decoded_le_event_mask.le_request_peer_sca_complete_event::size(1),
      decoded_le_event_mask.le_big_sync_lost_event::size(1),
      decoded_le_event_mask.le_big_sync_established_event::size(1),
      decoded_le_event_mask.le_terminate_big_complete_event::size(1),
      decoded_le_event_mask.le_create_big_complete_event::size(1),
      decoded_le_event_mask.le_cis_request_event::size(1),
      decoded_le_event_mask.le_cis_established_event::size(1),
      decoded_le_event_mask.le_periodic_advertising_sync_transfer_received_event::size(1),
      decoded_le_event_mask.le_cte_request_failed_event::size(1),
      decoded_le_event_mask.le_connection_iq_report_event::size(1),
      decoded_le_event_mask.le_connectionless_iq_report_event::size(1),
      decoded_le_event_mask.le_channel_selection_algorithm_event::size(1),
      decoded_le_event_mask.le_scan_request_received_event::size(1),
      decoded_le_event_mask.le_advertising_set_terminated_event::size(1),
      decoded_le_event_mask.le_scan_timeout_event::size(1),
      decoded_le_event_mask.le_periodic_advertising_sync_lost_event::size(1),
      decoded_le_event_mask.le_periodic_advertising_report_event::size(1),
      decoded_le_event_mask.le_periodic_advertising_sync_established_event::size(1),
      decoded_le_event_mask.le_extended_advertising_report_event::size(1),
      decoded_le_event_mask.le_phy_update_complete_event::size(1),
      decoded_le_event_mask.le_directed_advertising_report_event::size(1),
      decoded_le_event_mask.le_enhanced_connection_complete_event::size(1),
      decoded_le_event_mask.le_generate_dhkey_complete_event::size(1),
      decoded_le_event_mask.le_read_local_p256_public_key_complete_event::size(1),
      decoded_le_event_mask.le_data_length_change_event::size(1),
      decoded_le_event_mask.le_remote_connection_parameter_request_event::size(1),
      decoded_le_event_mask.le_long_term_key_request_event::size(1),
      decoded_le_event_mask.le_read_remote_features_complete_event::size(1),
      decoded_le_event_mask.le_connection_update_complete_event::size(1),
      decoded_le_event_mask.le_advertising_report_event::size(1),
      decoded_le_event_mask.le_connection_complete_event::size(1)
    >>

    reserved = 0

    decoded_le_event_mask = %{
      le_advertising_report_event: true,
      le_advertising_set_terminated_event: true,
      le_big_sync_established_event: true,
      le_big_sync_lost_event: true,
      le_biginfo_advertising_report_event: true,
      le_channel_selection_algorithm_event: true,
      le_cis_established_event: true,
      le_cis_request_event: true,
      le_connection_complete_event: true,
      le_connection_iq_report_event: true,
      le_connection_update_complete_event: true,
      le_connectionless_iq_report_event: true,
      le_create_big_complete_event: true,
      le_cte_request_failed_event: true,
      le_data_length_change_event: true,
      le_directed_advertising_report_event: true,
      le_enhanced_connection_complete_event: true,
      le_extended_advertising_report_event: true,
      le_generate_dhkey_complete_event: true,
      le_long_term_key_request_event: true,
      le_path_loss_threshold_event: true,
      le_periodic_advertising_report_event: true,
      le_periodic_advertising_sync_established_event: true,
      le_periodic_advertising_sync_lost_event: true,
      le_periodic_advertising_sync_transfer_received_event: true,
      le_phy_update_complete_event: true,
      le_read_local_p256_public_key_complete_event: true,
      le_read_remote_features_complete_event: true,
      le_remote_connection_parameter_request_event: true,
      le_request_peer_sca_complete_event: true,
      le_scan_request_received_event: true,
      le_scan_timeout_event: true,
      le_terminate_big_complete_event: true,
      le_transmit_power_reporting_event: true,
      reserved: reserved
    }

    parameters = <<encoded_set_event_mask::size(64)>>
    parameters_length = byte_size(parameters)
    expected_bin = <<1, 1, 32, parameters_length, parameters::binary>>

    expected_command = %Command{
      command_op_code: %{
        ocf: 0x01,
        ocf_module: SetEventMask,
        ogf: 0x08,
        ogf_module: LEController
      },
      parameters: %{
        le_event_mask: decoded_le_event_mask
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
    reserved = 0

    decoded_le_event_mask = %{
      le_connection_complete_event: 1,
      le_advertising_report_event: 1,
      le_connection_update_complete_event: 1,
      le_read_remote_features_complete_event: 1,
      le_long_term_key_request_event: 1,
      le_remote_connection_parameter_request_event: 1,
      le_data_length_change_event: 1,
      le_read_local_p256_public_key_complete_event: 1,
      le_generate_dhkey_complete_event: 1,
      le_enhanced_connection_complete_event: 1,
      le_directed_advertising_report_event: 1,
      le_phy_update_complete_event: 1,
      le_extended_advertising_report_event: 1,
      le_periodic_advertising_sync_established_event: 1,
      le_periodic_advertising_report_event: 1,
      le_periodic_advertising_sync_lost_event: 1,
      le_scan_timeout_event: 1,
      le_advertising_set_terminated_event: 1,
      le_scan_request_received_event: 1,
      le_channel_selection_algorithm_event: 1,
      le_connectionless_iq_report_event: 1,
      le_connection_iq_report_event: 1,
      le_cte_request_failed_event: 1,
      le_periodic_advertising_sync_transfer_received_event: 1,
      le_cis_established_event: 1,
      le_cis_request_event: 1,
      le_create_big_complete_event: 1,
      le_terminate_big_complete_event: 1,
      le_big_sync_established_event: 1,
      le_big_sync_lost_event: 1,
      le_request_peer_sca_complete_event: 1,
      le_path_loss_threshold_event: 1,
      le_transmit_power_reporting_event: 1,
      le_biginfo_advertising_report_event: 1,
      reserved: reserved
    }

    <<encoded_set_event_mask::little-size(64)>> = <<
      decoded_le_event_mask.reserved::size(30),
      decoded_le_event_mask.le_biginfo_advertising_report_event::size(1),
      decoded_le_event_mask.le_transmit_power_reporting_event::size(1),
      decoded_le_event_mask.le_path_loss_threshold_event::size(1),
      decoded_le_event_mask.le_request_peer_sca_complete_event::size(1),
      decoded_le_event_mask.le_big_sync_lost_event::size(1),
      decoded_le_event_mask.le_big_sync_established_event::size(1),
      decoded_le_event_mask.le_terminate_big_complete_event::size(1),
      decoded_le_event_mask.le_create_big_complete_event::size(1),
      decoded_le_event_mask.le_cis_request_event::size(1),
      decoded_le_event_mask.le_cis_established_event::size(1),
      decoded_le_event_mask.le_periodic_advertising_sync_transfer_received_event::size(1),
      decoded_le_event_mask.le_cte_request_failed_event::size(1),
      decoded_le_event_mask.le_connection_iq_report_event::size(1),
      decoded_le_event_mask.le_connectionless_iq_report_event::size(1),
      decoded_le_event_mask.le_channel_selection_algorithm_event::size(1),
      decoded_le_event_mask.le_scan_request_received_event::size(1),
      decoded_le_event_mask.le_advertising_set_terminated_event::size(1),
      decoded_le_event_mask.le_scan_timeout_event::size(1),
      decoded_le_event_mask.le_periodic_advertising_sync_lost_event::size(1),
      decoded_le_event_mask.le_periodic_advertising_report_event::size(1),
      decoded_le_event_mask.le_periodic_advertising_sync_established_event::size(1),
      decoded_le_event_mask.le_extended_advertising_report_event::size(1),
      decoded_le_event_mask.le_phy_update_complete_event::size(1),
      decoded_le_event_mask.le_directed_advertising_report_event::size(1),
      decoded_le_event_mask.le_enhanced_connection_complete_event::size(1),
      decoded_le_event_mask.le_generate_dhkey_complete_event::size(1),
      decoded_le_event_mask.le_read_local_p256_public_key_complete_event::size(1),
      decoded_le_event_mask.le_data_length_change_event::size(1),
      decoded_le_event_mask.le_remote_connection_parameter_request_event::size(1),
      decoded_le_event_mask.le_long_term_key_request_event::size(1),
      decoded_le_event_mask.le_read_remote_features_complete_event::size(1),
      decoded_le_event_mask.le_connection_update_complete_event::size(1),
      decoded_le_event_mask.le_advertising_report_event::size(1),
      decoded_le_event_mask.le_connection_complete_event::size(1)
    >>

    decoded_le_event_mask = %{
      le_advertising_report_event: true,
      le_advertising_set_terminated_event: true,
      le_big_sync_established_event: true,
      le_big_sync_lost_event: true,
      le_biginfo_advertising_report_event: true,
      le_channel_selection_algorithm_event: true,
      le_cis_established_event: true,
      le_cis_request_event: true,
      le_connection_complete_event: true,
      le_connection_iq_report_event: true,
      le_connection_update_complete_event: true,
      le_connectionless_iq_report_event: true,
      le_create_big_complete_event: true,
      le_cte_request_failed_event: true,
      le_data_length_change_event: true,
      le_directed_advertising_report_event: true,
      le_enhanced_connection_complete_event: true,
      le_extended_advertising_report_event: true,
      le_generate_dhkey_complete_event: true,
      le_long_term_key_request_event: true,
      le_path_loss_threshold_event: true,
      le_periodic_advertising_report_event: true,
      le_periodic_advertising_sync_established_event: true,
      le_periodic_advertising_sync_lost_event: true,
      le_periodic_advertising_sync_transfer_received_event: true,
      le_phy_update_complete_event: true,
      le_read_local_p256_public_key_complete_event: true,
      le_read_remote_features_complete_event: true,
      le_remote_connection_parameter_request_event: true,
      le_request_peer_sca_complete_event: true,
      le_scan_request_received_event: true,
      le_scan_timeout_event: true,
      le_terminate_big_complete_event: true,
      le_transmit_power_reporting_event: true,
      reserved: reserved
    }

    parameters = <<encoded_set_event_mask::size(64)>>
    parameters_length = byte_size(parameters)
    expected_bin = <<1, 1, 32, parameters_length, parameters::binary>>
    expected_size = byte_size(expected_bin)
    parameters = %{le_event_mask: decoded_le_event_mask}

    assert {:ok, actual_bin} = Commands.encode(LEController, SetEventMask, parameters)
    assert expected_size == byte_size(actual_bin)
    assert_binaries(expected_bin == actual_bin)
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
