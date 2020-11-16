defmodule Harald.HCI.Commands.ControllerAndBaseband.WriteFlowControlMode do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.73.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes, Events.Event}

  @behaviour Command

  @impl Command
  def decode(<<encoded_flow_control_mode>>) do
    decoded_flow_control_mode =
      case encoded_flow_control_mode do
        0 -> :packet
        1 -> :data_block
      end

    decoded_write_flow_control_mode = %{flow_control_mode: decoded_flow_control_mode}
    {:ok, decoded_write_flow_control_mode}
  end

  @impl Command
  def decode_return_parameters(<<encoded_status>>) do
    {:ok, decoded_status} = ErrorCodes.decode(encoded_status)
    {:ok, %{status: decoded_status}}
  end

  @impl Command
  def encode(%{flow_control_mode: decoded_flow_control_mode}) do
    encoded_flow_control_mode =
      case decoded_flow_control_mode do
        :packet -> 0
        :data_block -> 1
      end

    {:ok, <<encoded_flow_control_mode>>}
  end

  @impl Command
  def encode_return_parameters(%{status: decoded_status}) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)
    {:ok, <<encoded_status>>}
  end

  @impl Command
  def ocf(), do: 0x0067
end
