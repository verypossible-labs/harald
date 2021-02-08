defmodule Harald.HCI.Commands.ControllerAndBaseband.ReadFlowControlMode do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.72.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes}

  @behaviour Command

  @impl Command
  def decode(<<>>), do: {:ok, %{}}

  @impl Command
  def decode_return_parameters(<<encoded_status, encoded_flow_control_mode>>) do
    {:ok, decoded_status} = ErrorCodes.decode(encoded_status)

    decoded_flow_control_mode =
      case encoded_flow_control_mode do
        0 -> :packet
        1 -> :data_block
      end

    {:ok, %{flow_control_mode: decoded_flow_control_mode, status: decoded_status}}
  end

  @impl Command
  def encode(%{}), do: {:ok, %{}}

  @impl Command
  def encode_return_parameters(%{
        flow_control_mode: decoded_flow_control_mode,
        status: decoded_status
      }) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)

    encoded_flow_control_mode =
      case decoded_flow_control_mode do
        :packet -> 0
        :data_block -> 1
      end

    {:ok, <<encoded_status, encoded_flow_control_mode>>}
  end

  @impl Command
  def ocf(), do: 0x0066
end
