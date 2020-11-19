defmodule Harald.HCI.Commands.ControllerAndBaseband.SetEventMaskPage2 do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.69.
  """

  alias Harald.{HCI, HCI.Commands.Command, HCI.ErrorCodes}

  @type t() :: %{
          event_mask_page_2: %{
            physical_link_complete_event: HCI.flag(),
            channel_selected_event: HCI.flag(),
            disconnection_physical_link_complete_event: HCI.flag(),
            physical_link_loss_early_warning_event: HCI.flag(),
            physical_link_recovery_event: HCI.flag(),
            logical_link_complete_event: HCI.flag(),
            disconnection_logical_link_complete_event: HCI.flag(),
            flow_spec_modify_complete_event: HCI.flag(),
            number_of_completed_data_blocks_event: HCI.flag(),
            amp_start_test_event: HCI.flag(),
            amp_test_end_event: HCI.flag(),
            amp_receiver_report_event: HCI.flag(),
            short_range_mode_change_complete_event: HCI.flag(),
            amp_status_change_event: HCI.flag(),
            triggered_clock_capture_event: HCI.flag(),
            synchronization_train_complete_event: HCI.flag(),
            synchronization_train_received_event: HCI.flag(),
            connectionless_slave_broadcast_receive_event: HCI.flag(),
            connectionless_slave_broadcast_timeout_event: HCI.flag(),
            truncated_page_complete_event: HCI.flag(),
            slave_page_response_timeout_event: HCI.flag(),
            connectionless_slave_broadcast_channel_map_change_event: HCI.flag(),
            inquiry_response_notification_event: HCI.flag(),
            authenticated_payload_timeout_expired_event: HCI.flag(),
            sam_status_change_event: HCI.flag(),
            reserved_25_to_63: HCI.reserved()
          }
        }

  @behaviour Command

  @fields [
    :physical_link_complete_event,
    :channel_selected_event,
    :disconnection_physical_link_complete_event,
    :physical_link_loss_early_warning_event,
    :physical_link_recovery_event,
    :logical_link_complete_event,
    :disconnection_logical_link_complete_event,
    :flow_spec_modify_complete_event,
    :number_of_completed_data_blocks_event,
    :amp_start_test_event,
    :amp_test_end_event,
    :amp_receiver_report_event,
    :short_range_mode_change_complete_event,
    :amp_status_change_event,
    :triggered_clock_capture_event,
    :synchronization_train_complete_event,
    :synchronization_train_received_event,
    :connectionless_slave_broadcast_receive_event,
    :connectionless_slave_broadcast_timeout_event,
    :truncated_page_complete_event,
    :slave_page_response_timeout_event,
    :connectionless_slave_broadcast_channel_map_change_event,
    :inquiry_response_notification_event,
    :authenticated_payload_timeout_expired_event,
    :sam_status_change_event,
    :reserved_25_to_63
  ]

  @impl Command
  def decode(<<encoded_set_event_mask_page_2::little-size(64)>>) do
    <<
      reserved_25_to_63::size(39),
      sam_status_change_event::size(1),
      authenticated_payload_timeout_expired_event::size(1),
      inquiry_response_notification_event::size(1),
      connectionless_slave_broadcast_channel_map_change_event::size(1),
      slave_page_response_timeout_event::size(1),
      truncated_page_complete_event::size(1),
      connectionless_slave_broadcast_timeout_event::size(1),
      connectionless_slave_broadcast_receive_event::size(1),
      synchronization_train_received_event::size(1),
      synchronization_train_complete_event::size(1),
      triggered_clock_capture_event::size(1),
      amp_status_change_event::size(1),
      short_range_mode_change_complete_event::size(1),
      amp_receiver_report_event::size(1),
      amp_test_end_event::size(1),
      amp_start_test_event::size(1),
      number_of_completed_data_blocks_event::size(1),
      flow_spec_modify_complete_event::size(1),
      disconnection_logical_link_complete_event::size(1),
      logical_link_complete_event::size(1),
      physical_link_recovery_event::size(1),
      physical_link_loss_early_warning_event::size(1),
      disconnection_physical_link_complete_event::size(1),
      channel_selected_event::size(1),
      physical_link_complete_event::size(1)
    >> = <<encoded_set_event_mask_page_2::size(64)>>

    encoded_event_mask_page_2 = %{
      physical_link_complete_event: physical_link_complete_event,
      channel_selected_event: channel_selected_event,
      disconnection_physical_link_complete_event: disconnection_physical_link_complete_event,
      physical_link_loss_early_warning_event: physical_link_loss_early_warning_event,
      physical_link_recovery_event: physical_link_recovery_event,
      logical_link_complete_event: logical_link_complete_event,
      disconnection_logical_link_complete_event: disconnection_logical_link_complete_event,
      flow_spec_modify_complete_event: flow_spec_modify_complete_event,
      number_of_completed_data_blocks_event: number_of_completed_data_blocks_event,
      amp_start_test_event: amp_start_test_event,
      amp_test_end_event: amp_test_end_event,
      amp_receiver_report_event: amp_receiver_report_event,
      short_range_mode_change_complete_event: short_range_mode_change_complete_event,
      amp_status_change_event: amp_status_change_event,
      triggered_clock_capture_event: triggered_clock_capture_event,
      synchronization_train_complete_event: synchronization_train_complete_event,
      synchronization_train_received_event: synchronization_train_received_event,
      connectionless_slave_broadcast_receive_event: connectionless_slave_broadcast_receive_event,
      connectionless_slave_broadcast_timeout_event: connectionless_slave_broadcast_timeout_event,
      truncated_page_complete_event: truncated_page_complete_event,
      slave_page_response_timeout_event: slave_page_response_timeout_event,
      connectionless_slave_broadcast_channel_map_change_event:
        connectionless_slave_broadcast_channel_map_change_event,
      inquiry_response_notification_event: inquiry_response_notification_event,
      authenticated_payload_timeout_expired_event: authenticated_payload_timeout_expired_event,
      sam_status_change_event: sam_status_change_event,
      reserved_25_to_63: reserved_25_to_63
    }

    decoded_event_mask_page_2 =
      Enum.into(encoded_event_mask_page_2, %{}, fn
        {:reserved_25_to_63, reserved} -> {:reserved_25_to_63, reserved}
        {key, 1} -> {key, true}
        {key, 0} -> {key, false}
      end)

    parameters = %{event_mask_page_2: decoded_event_mask_page_2}

    {:ok, parameters}
  end

  @impl Command
  def decode_return_parameters(<<encoded_status>>) do
    {:ok, decoded_status} = ErrorCodes.decode(encoded_status)
    {:ok, %{status: decoded_status}}
  end

  @impl Command
  def encode(%{
        event_mask_page_2:
          %{
            physical_link_complete_event: _,
            channel_selected_event: _,
            disconnection_physical_link_complete_event: _,
            physical_link_loss_early_warning_event: _,
            physical_link_recovery_event: _,
            logical_link_complete_event: _,
            disconnection_logical_link_complete_event: _,
            flow_spec_modify_complete_event: _,
            number_of_completed_data_blocks_event: _,
            amp_start_test_event: _,
            amp_test_end_event: _,
            amp_receiver_report_event: _,
            short_range_mode_change_complete_event: _,
            amp_status_change_event: _,
            triggered_clock_capture_event: _,
            synchronization_train_complete_event: _,
            synchronization_train_received_event: _,
            connectionless_slave_broadcast_receive_event: _,
            connectionless_slave_broadcast_timeout_event: _,
            truncated_page_complete_event: _,
            slave_page_response_timeout_event: _,
            connectionless_slave_broadcast_channel_map_change_event: _,
            inquiry_response_notification_event: _,
            authenticated_payload_timeout_expired_event: _,
            sam_status_change_event: _,
            reserved_25_to_63: _
          } = decoded_event_mask_page_2
      }) do
    encoded_event_mask_page_2 =
      Enum.into(decoded_event_mask_page_2, %{}, fn
        {:reserved_25_to_63, reserved} -> {:reserved_25_to_63, reserved}
        {key, true} -> {key, 1}
        {key, false} -> {key, 0}
      end)

    <<encoded_set_event_mask_page_2::little-size(64)>> = <<
      encoded_event_mask_page_2.reserved_25_to_63::size(39),
      encoded_event_mask_page_2.sam_status_change_event::size(1),
      encoded_event_mask_page_2.authenticated_payload_timeout_expired_event::size(1),
      encoded_event_mask_page_2.inquiry_response_notification_event::size(1),
      encoded_event_mask_page_2.connectionless_slave_broadcast_channel_map_change_event::size(1),
      encoded_event_mask_page_2.slave_page_response_timeout_event::size(1),
      encoded_event_mask_page_2.truncated_page_complete_event::size(1),
      encoded_event_mask_page_2.connectionless_slave_broadcast_timeout_event::size(1),
      encoded_event_mask_page_2.connectionless_slave_broadcast_receive_event::size(1),
      encoded_event_mask_page_2.synchronization_train_received_event::size(1),
      encoded_event_mask_page_2.synchronization_train_complete_event::size(1),
      encoded_event_mask_page_2.triggered_clock_capture_event::size(1),
      encoded_event_mask_page_2.amp_status_change_event::size(1),
      encoded_event_mask_page_2.short_range_mode_change_complete_event::size(1),
      encoded_event_mask_page_2.amp_receiver_report_event::size(1),
      encoded_event_mask_page_2.amp_test_end_event::size(1),
      encoded_event_mask_page_2.amp_start_test_event::size(1),
      encoded_event_mask_page_2.number_of_completed_data_blocks_event::size(1),
      encoded_event_mask_page_2.flow_spec_modify_complete_event::size(1),
      encoded_event_mask_page_2.disconnection_logical_link_complete_event::size(1),
      encoded_event_mask_page_2.logical_link_complete_event::size(1),
      encoded_event_mask_page_2.physical_link_recovery_event::size(1),
      encoded_event_mask_page_2.physical_link_loss_early_warning_event::size(1),
      encoded_event_mask_page_2.disconnection_physical_link_complete_event::size(1),
      encoded_event_mask_page_2.channel_selected_event::size(1),
      encoded_event_mask_page_2.physical_link_complete_event::size(1)
    >>

    {:ok, <<encoded_set_event_mask_page_2::size(64)>>}
  end

  @impl Command
  def encode_return_parameters(%{status: decoded_status}) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)
    {:ok, <<encoded_status>>}
  end

  @doc """
  Return a map ready for encoding.

  Keys under `:event_mask` will be defaulted if not supplied.

  ## Options

  `encoded` - `boolean()`. `false`. Whether the return value is encoded or not.
  `:default` - `boolean()`. `false`. The default value for unspecified fields under the
    `:event_mask` field.
  """
  def new(%{event_mask_page_2: event_mask_page_2}, opts \\ []) do
    default = Keyword.get(opts, :default, false)

    with {:ok, event_mask_page_2} <- resolve_mask(event_mask_page_2, default) do
      maybe_encode(%{event_mask_page_2: event_mask_page_2}, Keyword.get(opts, :encoded, false))
    end
  end

  @impl Command
  def ocf(), do: 0x63

  defp maybe_encode(decoded_set_event_mask, true) do
    encode(decoded_set_event_mask)
  end

  defp maybe_encode(decoded_set_event_mask, false), do: {:ok, decoded_set_event_mask}

  defp resolve_mask(fields, default) do
    truthy_reserved = 549_755_813_888
    falsey_reserved = 0
    reserved_default = if default, do: truthy_reserved, else: falsey_reserved

    Enum.reduce_while(@fields, %{}, fn
      :reserved_25_to_63, acc ->
        case Map.fetch(fields, :reserved_25_to_63) do
          {:ok, value} when is_integer(value) -> {:cont, Map.put(acc, :reserved_25_to_63, value)}
          {:ok, _value} -> {:halt, {:error, :reserved_25_to_63}}
          :error -> {:cont, Map.put(acc, :reserved_25_to_63, reserved_default)}
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
