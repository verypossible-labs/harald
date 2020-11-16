defmodule Harald.HCI.Commands.InformationalParameters.ReadLocalSupportedFeatures do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.4.3.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes}

  @behaviour Command

  @impl Command
  def decode(<<>>), do: {:ok, %{}}

  @impl Command
  def decode_return_parameters(<<
        status,
        three_slot_packets::size(1),
        five_slow_packets::size(1),
        encryption::size(1),
        slot_offset::size(1),
        timing_accuracy::size(1),
        role_switch::size(1),
        hold_mode::size(1),
        sniff_mode::size(1),
        previously_used::size(1),
        power_control_requests::size(1),
        channel_quality_driven_data_rate::size(1),
        sco_link::size(1),
        hv2_packets::size(1),
        hv3_packets::size(1),
        micro_law_log_synchronous_data::size(1),
        a_law_log_synchronous_data::size(1),
        cvsd_synchronous_data::size(1),
        paging_parameter_negotiation::size(1),
        power_control::size(1),
        transparent_synchronous_data::size(1),
        flow_control_lag_lsb::size(1),
        flow_control_lag_mb::size(1),
        flow_control_lag_msb::size(1),
        broadcast_encryption::size(1),
        reserved_24::size(1),
        enhanced_data_rate_acl_2_mbs_mode::size(1),
        enhanced_data_rate_acl_3_mbs_mode::size(1),
        enhanced_inquiry_scan::size(1),
        interlaced_inquiry_scan::size(1),
        interlaced_page_scan::size(1),
        rssi_with_inquiry_results::size(1),
        extended_sco_link_ev3_packets::size(1),
        ev4_packets::size(1),
        ev5_packets::size(1),
        reserved_34::size(1),
        afh_capable_slave::size(1),
        afh_classification_slave::size(1),
        br_edr_not_supported::size(1),
        le_supported_controller::size(1),
        three_slot_enhanced_data_rate_acl_packets::size(1),
        five_slot_enhanced_data_rate_acl_packets::size(1),
        sniff_subrating::size(1),
        pause_encryption::size(1),
        afh_capable_master::size(1),
        afh_classification_master::size(1),
        enhanced_data_rate_esco_2_mb_s_mode::size(1),
        enhanced_data_rate_esco_3_mb_s_mode::size(1),
        three_slot_enhanced_data_rate_esco_packets::size(1),
        extended_inquiry_response::size(1),
        simultaneous_le_and_br_edr_to_same_device_capable_controller::size(1),
        resserved_50::size(1),
        secure_simple_pairing_controller_support::size(1),
        encapsulated_pdu::size(1),
        erroneous_data_reporting::size(1),
        non_flushable_packet_boundary_flag::size(1),
        reserved_55::size(1),
        hci_link_supervision_timeout_changed_event::size(1),
        variable_inquiry_tx_power_level::size(1),
        enhanced_power_control::size(1),
        reserved_59_to_62::size(4),
        extended_features::size(1)
      >>) do
    {:ok, decoded_status} = ErrorCodes.decode(status)

    <<decoded_flow_control_lag::size(3)>> =
      <<flow_control_lag_msb::size(1), flow_control_lag_mb::size(1),
        flow_control_lag_lsb::size(1)>>

    decoded_lmp_features =
      %{
        three_slot_packets: three_slot_packets,
        five_slot_packets: five_slow_packets,
        encryption: encryption,
        slot_offset: slot_offset,
        timing_accuracy: timing_accuracy,
        role_switch: role_switch,
        hold_mode: hold_mode,
        sniff_mode: sniff_mode,
        previously_used: previously_used,
        power_control_requests: power_control_requests,
        channel_quality_driven_data_rate: channel_quality_driven_data_rate,
        sco_link: sco_link,
        hv2_packets: hv2_packets,
        hv3_packets: hv3_packets,
        micro_law_log_synchronous_data: micro_law_log_synchronous_data,
        a_law_log_synchronous_data: a_law_log_synchronous_data,
        cvsd_synchronous_data: cvsd_synchronous_data,
        paging_parameter_negotiation: paging_parameter_negotiation,
        power_control: power_control,
        transparent_synchronous_data: transparent_synchronous_data,
        flow_control_lag: decoded_flow_control_lag,
        broadcast_encryption: broadcast_encryption,
        reserved_24: reserved_24,
        enhanced_data_rate_acl_2_mbs_mode: enhanced_data_rate_acl_2_mbs_mode,
        enhanced_data_rate_acl_3_mbs_mode: enhanced_data_rate_acl_3_mbs_mode,
        enhanced_inquiry_scan: enhanced_inquiry_scan,
        interlaced_inquiry_scan: interlaced_inquiry_scan,
        interlaced_page_scan: interlaced_page_scan,
        rssi_with_inquiry_results: rssi_with_inquiry_results,
        extended_sco_link_ev3_packets: extended_sco_link_ev3_packets,
        ev4_packets: ev4_packets,
        ev5_packets: ev5_packets,
        reserved_34: reserved_34,
        afh_capable_slave: afh_capable_slave,
        afh_classification_slave: afh_classification_slave,
        br_edr_not_supported: br_edr_not_supported,
        le_supported_controller: le_supported_controller,
        three_slot_enhanced_data_rate_acl_packets: three_slot_enhanced_data_rate_acl_packets,
        five_slot_enhanced_data_rate_acl_packets: five_slot_enhanced_data_rate_acl_packets,
        sniff_subrating: sniff_subrating,
        pause_encryption: pause_encryption,
        afh_capable_master: afh_capable_master,
        afh_classification_master: afh_classification_master,
        enhanced_data_rate_esco_2_mb_s_mode: enhanced_data_rate_esco_2_mb_s_mode,
        enhanced_data_rate_esco_3_mb_s_mode: enhanced_data_rate_esco_3_mb_s_mode,
        three_slot_enhanced_data_rate_esco_packets: three_slot_enhanced_data_rate_esco_packets,
        extended_inquiry_response: extended_inquiry_response,
        simultaneous_le_and_br_edr_to_same_device_capable_controller:
          simultaneous_le_and_br_edr_to_same_device_capable_controller,
        resserved_50: resserved_50,
        secure_simple_pairing_controller_support: secure_simple_pairing_controller_support,
        encapsulated_pdu: encapsulated_pdu,
        erroneous_data_reporting: erroneous_data_reporting,
        non_flushable_packet_boundary_flag: non_flushable_packet_boundary_flag,
        reserved_55: reserved_55,
        hci_link_supervision_timeout_changed_event: hci_link_supervision_timeout_changed_event,
        variable_inquiry_tx_power_level: variable_inquiry_tx_power_level,
        enhanced_power_control: enhanced_power_control,
        reserved_59_to_62: reserved_59_to_62,
        extended_features: extended_features
      }
      |> Enum.into(%{}, fn
        {key, _} = kvp
        when key in [
               :flow_control_lag,
               :reserved_24,
               :reserved_34,
               :reserved_55,
               :reserved_59_to_62
             ] ->
          kvp

        {key, 0} ->
          {key, false}

        {key, 1} ->
          {key, true}
      end)

    decoded_return_parameters = %{
      status: decoded_status,
      lmp_features: decoded_lmp_features
    }

    {:ok, decoded_return_parameters}
  end

  @impl Command
  def encode(%{}), do: {:ok, <<>>}

  @impl Command
  def encode_return_parameters(%{
        status: decoded_status,
        lmp_features:
          %{
            three_slot_packets: _,
            five_slot_packets: _,
            encryption: _,
            slot_offset: _,
            timing_accuracy: _,
            role_switch: _,
            hold_mode: _,
            sniff_mode: _,
            previously_used: _,
            power_control_requests: _,
            channel_quality_driven_data_rate: _,
            sco_link: _,
            hv2_packets: _,
            hv3_packets: _,
            micro_law_log_synchronous_data: _,
            a_law_log_synchronous_data: _,
            cvsd_synchronous_data: _,
            paging_parameter_negotiation: _,
            power_control: _,
            transparent_synchronous_data: _,
            flow_control_lag: _,
            broadcast_encryption: _,
            reserved_24: _,
            enhanced_data_rate_acl_2_mbs_mode: _,
            enhanced_data_rate_acl_3_mbs_mode: _,
            enhanced_inquiry_scan: _,
            interlaced_inquiry_scan: _,
            interlaced_page_scan: _,
            rssi_with_inquiry_results: _,
            extended_sco_link_ev3_packets: _,
            ev4_packets: _,
            ev5_packets: _,
            reserved_34: _,
            afh_capable_slave: _,
            afh_classification_slave: _,
            br_edr_not_supported: _,
            le_supported_controller: _,
            three_slot_enhanced_data_rate_acl_packets: _,
            five_slot_enhanced_data_rate_acl_packets: _,
            sniff_subrating: _,
            pause_encryption: _,
            afh_capable_master: _,
            afh_classification_master: _,
            enhanced_data_rate_esco_2_mb_s_mode: _,
            enhanced_data_rate_esco_3_mb_s_mode: _,
            three_slot_enhanced_data_rate_esco_packets: _,
            extended_inquiry_response: _,
            simultaneous_le_and_br_edr_to_same_device_capable_controller: _,
            resserved_50: _,
            secure_simple_pairing_controller_support: _,
            encapsulated_pdu: _,
            erroneous_data_reporting: _,
            non_flushable_packet_boundary_flag: _,
            reserved_55: _,
            hci_link_supervision_timeout_changed_event: _,
            variable_inquiry_tx_power_level: _,
            enhanced_power_control: _,
            reserved_59_to_62: _,
            extended_features: _
          } = decoded_lmp_features
      }) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)

    encoded_lmp_features_values =
      Enum.into(decoded_lmp_features, %{}, fn
        {key, _} = kvp
        when key in [
               :flow_control_lag,
               :reserved_24,
               :reserved_34,
               :reserved_55,
               :reserved_59_to_62
             ] ->
          kvp

        {key, false} ->
          {key, 0}

        {key, true} ->
          {key, 1}
      end)

    encoded_return_parameters = <<
      encoded_status,
      encoded_lmp_features_values.three_slot_packets::size(1),
      encoded_lmp_features_values.five_slow_packets::size(1),
      encoded_lmp_features_values.encryption::size(1),
      encoded_lmp_features_values.slot_offset::size(1),
      encoded_lmp_features_values.timing_accuracy::size(1),
      encoded_lmp_features_values.role_switch::size(1),
      encoded_lmp_features_values.hold_mode::size(1),
      encoded_lmp_features_values.sniff_mode::size(1),
      encoded_lmp_features_values.previously_used::size(1),
      encoded_lmp_features_values.power_control_requests::size(1),
      encoded_lmp_features_values.channel_quality_driven_data_rate::size(1),
      encoded_lmp_features_values.sco_link::size(1),
      encoded_lmp_features_values.hv2_packets::size(1),
      encoded_lmp_features_values.hv3_packets::size(1),
      encoded_lmp_features_values.micro_law_log_synchronous_data::size(1),
      encoded_lmp_features_values.a_law_log_synchronous_data::size(1),
      encoded_lmp_features_values.cvsd_synchronous_data::size(1),
      encoded_lmp_features_values.paging_parameter_negotiation::size(1),
      encoded_lmp_features_values.power_control::size(1),
      encoded_lmp_features_values.transparent_synchronous_data::size(1),
      encoded_lmp_features_values.flow_control_lag_lsb::size(1),
      encoded_lmp_features_values.flow_control_lag_mb::size(1),
      encoded_lmp_features_values.flow_control_lag_msb::size(1),
      encoded_lmp_features_values.broadcast_encryption::size(1),
      encoded_lmp_features_values.reserved_24::size(1),
      encoded_lmp_features_values.enhanced_data_rate_acl_2_mbs_mode::size(1),
      encoded_lmp_features_values.enhanced_data_rate_acl_3_mbs_mode::size(1),
      encoded_lmp_features_values.enhanced_inquiry_scan::size(1),
      encoded_lmp_features_values.interlaced_inquiry_scan::size(1),
      encoded_lmp_features_values.interlaced_page_scan::size(1),
      encoded_lmp_features_values.rssi_with_inquiry_results::size(1),
      encoded_lmp_features_values.extended_sco_link_ev3_packets::size(1),
      encoded_lmp_features_values.ev4_packets::size(1),
      encoded_lmp_features_values.ev5_packets::size(1),
      encoded_lmp_features_values.reserved_34::size(1),
      encoded_lmp_features_values.afh_capable_slave::size(1),
      encoded_lmp_features_values.afh_classification_slave::size(1),
      encoded_lmp_features_values.br_edr_not_supported::size(1),
      encoded_lmp_features_values.le_supported_controller::size(1),
      encoded_lmp_features_values.three_slot_enhanced_data_rate_acl_packets::size(1),
      encoded_lmp_features_values.five_slot_enhanced_data_rate_acl_packets::size(1),
      encoded_lmp_features_values.sniff_subrating::size(1),
      encoded_lmp_features_values.pause_encryption::size(1),
      encoded_lmp_features_values.afh_capable_master::size(1),
      encoded_lmp_features_values.afh_classification_master::size(1),
      encoded_lmp_features_values.enhanced_data_rate_esco_2_mb_s_mode::size(1),
      encoded_lmp_features_values.enhanced_data_rate_esco_3_mb_s_mode::size(1),
      encoded_lmp_features_values.three_slot_enhanced_data_rate_esco_packets::size(1),
      encoded_lmp_features_values.extended_inquiry_response::size(1),
      encoded_lmp_features_values.simultaneous_le_and_br_edr_to_same_device_capable_controller::size(
        1
      ),
      encoded_lmp_features_values.resserved_50::size(1),
      encoded_lmp_features_values.secure_simple_pairing_controller_support::size(1),
      encoded_lmp_features_values.encapsulated_pdu::size(1),
      encoded_lmp_features_values.erroneous_data_reporting::size(1),
      encoded_lmp_features_values.non_flushable_packet_boundary_flag::size(1),
      encoded_lmp_features_values.reserved_55::size(1),
      encoded_lmp_features_values.hci_link_supervision_timeout_changed_event::size(1),
      encoded_lmp_features_values.variable_inquiry_tx_power_level::size(1),
      encoded_lmp_features_values.enhanced_power_control::size(1),
      encoded_lmp_features_values.reserved_59_to_62::size(4),
      encoded_lmp_features_values.extended_features::size(1)
    >>

    {:ok, encoded_return_parameters}
  end

  @impl Command
  def ocf(), do: 0x03
end
