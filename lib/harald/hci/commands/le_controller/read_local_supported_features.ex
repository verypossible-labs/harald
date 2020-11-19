defmodule Harald.HCI.Commands.LEController.ReadLocalSupportedFeatures do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.8.3.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes}

  @behaviour Command

  @impl Command
  def decode(<<>>), do: {:ok, %{}}

  @impl Command
  def decode_return_parameters(<<
        status,
        le_encryption::size(1),
        connection_parameters_request_procedure::size(1),
        extended_reject_indication::size(1),
        slave_initiated_features_exchange::size(1),
        le_ping::size(1),
        le_data_packet_length_extension::size(1),
        ll_privacy::size(1),
        extended_scanner_filter_policies::size(1),
        le_2m_phy::size(1),
        stable_modulation_index_transmitter::size(1),
        stable_modulation_index_receiver::size(1),
        le_coded_phy::size(1),
        le_extended_advertising::size(1),
        le_periodic_advertising::size(1),
        channel_selection_algorithm_2::size(1),
        le_power_class_1::size(1),
        minimum_number_of_used_channels_procedure::size(1),
        connection_cte_request::size(1),
        connection_cte_response::size(1),
        connectionless_cte_transmitter::size(1),
        connectionless_cte_receiver::size(1),
        antenna_switching_during_cte_transmission_aod::size(1),
        antenna_switching_during_cte_reception_aoa::size(1),
        receiving_constant_tone_extensions::size(1),
        periodic_advertising_sync_transfer_sender::size(1),
        periodic_advertising_sync_transfer_recipient::size(1),
        sleep_clock_accuracy_updates::size(1),
        remote_public_key_validation::size(1),
        connected_isochronous_stream_master::size(1),
        connected_isochronous_stream_slave::size(1),
        isochronous_broadcaster::size(1),
        synchronized_receiver::size(1),
        isochronous_channels_host_support::size(1),
        le_power_control_request::size(1),
        le_power_change_indication::size(1),
        le_path_loss_monitoring::size(1),
        reserved_36_to_63::size(28)
      >>) do
    {:ok, decoded_status} = ErrorCodes.decode(status)

    decoded_le_features =
      %{
        le_encryption: le_encryption,
        connection_parameters_request_procedure: connection_parameters_request_procedure,
        extended_reject_indication: extended_reject_indication,
        slave_initiated_features_exchange: slave_initiated_features_exchange,
        le_ping: le_ping,
        le_data_packet_length_extension: le_data_packet_length_extension,
        ll_privacy: ll_privacy,
        extended_scanner_filter_policies: extended_scanner_filter_policies,
        le_2m_phy: le_2m_phy,
        stable_modulation_index_transmitter: stable_modulation_index_transmitter,
        stable_modulation_index_receiver: stable_modulation_index_receiver,
        le_coded_phy: le_coded_phy,
        le_extended_advertising: le_extended_advertising,
        le_periodic_advertising: le_periodic_advertising,
        channel_selection_algorithm_2: channel_selection_algorithm_2,
        le_power_class_1: le_power_class_1,
        minimum_number_of_used_channels_procedure: minimum_number_of_used_channels_procedure,
        connection_cte_request: connection_cte_request,
        connection_cte_response: connection_cte_response,
        connectionless_cte_transmitter: connectionless_cte_transmitter,
        connectionless_cte_receiver: connectionless_cte_receiver,
        antenna_switching_during_cte_transmission_aod:
          antenna_switching_during_cte_transmission_aod,
        antenna_switching_during_cte_reception_aoa: antenna_switching_during_cte_reception_aoa,
        receiving_constant_tone_extensions: receiving_constant_tone_extensions,
        periodic_advertising_sync_transfer_sender: periodic_advertising_sync_transfer_sender,
        periodic_advertising_sync_transfer_recipient:
          periodic_advertising_sync_transfer_recipient,
        sleep_clock_accuracy_updates: sleep_clock_accuracy_updates,
        remote_public_key_validation: remote_public_key_validation,
        connected_isochronous_stream_master: connected_isochronous_stream_master,
        connected_isochronous_stream_slave: connected_isochronous_stream_slave,
        isochronous_broadcaster: isochronous_broadcaster,
        synchronized_receiver: synchronized_receiver,
        isochronous_channels_host_support: isochronous_channels_host_support,
        le_power_control_request: le_power_control_request,
        le_power_change_indication: le_power_change_indication,
        le_path_loss_monitoring: le_path_loss_monitoring,
        reserved_36_to_63: reserved_36_to_63
      }
      |> Enum.into(%{}, fn
        {:reserved_36_to_63, _} = kvp -> kvp
        {key, 0} -> {key, false}
        {key, 1} -> {key, true}
      end)

    decoded_return_parameters = %{
      status: decoded_status,
      le_features: decoded_le_features
    }

    {:ok, decoded_return_parameters}
  end

  @impl Command
  def encode(%{}), do: {:ok, <<>>}

  @impl Command
  def encode_return_parameters(%{
        status: decoded_status,
        le_features:
          %{
            le_encryption: _,
            connection_parameters_request_procedure: _,
            extended_reject_indication: _,
            slave_initiated_features_exchange: _,
            le_ping: _,
            le_data_packet_length_extension: _,
            ll_privacy: _,
            extended_scanner_filter_policies: _,
            le_2m_phy: _,
            stable_modulation_index_transmitter: _,
            stable_modulation_index_receiver: _,
            le_coded_phy: _,
            le_extended_advertising: _,
            le_periodic_advertising: _,
            channel_selection_algorithm_2: _,
            le_power_class_1: _,
            minimum_number_of_used_channels_procedure: _,
            connection_cte_request: _,
            connection_cte_response: _,
            connectionless_cte_transmitter: _,
            connectionless_cte_receiver: _,
            antenna_switching_during_cte_transmission_aod: _,
            antenna_switching_during_cte_reception_aoa: _,
            receiving_constant_tone_extensions: _,
            periodic_advertising_sync_transfer_sender: _,
            periodic_advertising_sync_transfer_recipient: _,
            sleep_clock_accuracy_updates: _,
            remote_public_key_validation: _,
            connected_isochronous_stream_master: _,
            connected_isochronous_stream_slave: _,
            isochronous_broadcaster: _,
            synchronized_receiver: _,
            isochronous_channels_host_support: _,
            le_power_control_request: _,
            le_power_change_indication: _,
            le_path_loss_monitoring: _,
            reserved_36_to_63: _
          } = decoded_le_features
      }) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)

    encoded_le_features_values =
      Enum.into(decoded_le_features, %{}, fn
        {:reserved_36_to_63, _} = kvp -> kvp
        {key, false} -> {key, 0}
        {key, true} -> {key, 1}
      end)

    encoded_return_parameters = <<
      encoded_status,
      encoded_le_features_values.le_encryption::size(1),
      encoded_le_features_values.connection_parameters_request_procedure::size(1),
      encoded_le_features_values.extended_reject_indication::size(1),
      encoded_le_features_values.slave_initiated_features_exchange::size(1),
      encoded_le_features_values.le_ping::size(1),
      encoded_le_features_values.le_data_packet_length_extension::size(1),
      encoded_le_features_values.ll_privacy::size(1),
      encoded_le_features_values.extended_scanner_filter_policies::size(1),
      encoded_le_features_values.le_2m_phy::size(1),
      encoded_le_features_values.stable_modulation_index_transmitter::size(1),
      encoded_le_features_values.stable_modulation_index_receiver::size(1),
      encoded_le_features_values.le_coded_phy::size(1),
      encoded_le_features_values.le_extended_advertising::size(1),
      encoded_le_features_values.le_periodic_advertising::size(1),
      encoded_le_features_values.channel_selection_algorithm_2::size(1),
      encoded_le_features_values.le_power_class_1::size(1),
      encoded_le_features_values.minimum_number_of_used_channels_procedure::size(1),
      encoded_le_features_values.connection_cte_request::size(1),
      encoded_le_features_values.connection_cte_response::size(1),
      encoded_le_features_values.connectionless_cte_transmitter::size(1),
      encoded_le_features_values.connectionless_cte_receiver::size(1),
      encoded_le_features_values.antenna_switching_during_cte_transmission_aod::size(1),
      encoded_le_features_values.antenna_switching_during_cte_reception_aoa::size(1),
      encoded_le_features_values.receiving_constant_tone_extensions::size(1),
      encoded_le_features_values.periodic_advertising_sync_transfer_sender::size(1),
      encoded_le_features_values.periodic_advertising_sync_transfer_recipient::size(1),
      encoded_le_features_values.sleep_clock_accuracy_updates::size(1),
      encoded_le_features_values.remote_public_key_validation::size(1),
      encoded_le_features_values.connected_isochronous_stream_master::size(1),
      encoded_le_features_values.connected_isochronous_stream_slave::size(1),
      encoded_le_features_values.isochronous_broadcaster::size(1),
      encoded_le_features_values.synchronized_receiver::size(1),
      encoded_le_features_values.isochronous_channels_host_support::size(1),
      encoded_le_features_values.le_power_control_request::size(1),
      encoded_le_features_values.le_power_change_indication::size(1),
      encoded_le_features_values.le_path_loss_monitoring::size(1),
      encoded_le_features_values.reserved_36_to_63::size(28)
    >>

    {:ok, encoded_return_parameters}
  end

  @impl Command
  def ocf(), do: 0x03
end
