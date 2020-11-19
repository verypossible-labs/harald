defmodule Harald.HCI.Commands.ControllerAndBaseband.SetControllerToHostFlowControl do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.38.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes}

  @behaviour Command

  @impl Command
  def encode(%{flow_control_enable: false}), do: {:ok, <<0>>}
  def encode(%{flow_control_enable: :acl_data}), do: {:ok, <<1>>}
  def encode(%{flow_control_enable: :synchronous_data}), do: {:ok, <<2>>}
  def encode(%{flow_control_enable: :acl_data_and_synchronous_data}), do: {:ok, <<3>>}

  @impl Command
  def decode(<<0>>), do: {:ok, %{flow_control_enable: false}}
  def decode(<<1>>), do: {:ok, %{flow_control_enable: :acl_data}}
  def decode(<<2>>), do: {:ok, %{flow_control_enable: :synchronous_data}}
  def decode(<<3>>), do: {:ok, %{flow_control_enable: :acl_data_and_synchronous_data}}

  @impl Command
  def decode_return_parameters(<<encoded_status>>) do
    {:ok, decoded_status} = ErrorCodes.decode(encoded_status)
    {:ok, %{status: decoded_status}}
  end

  @impl Command
  def encode_return_parameters(%{status: decoded_status}) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)
    {:ok, <<encoded_status>>}
  end

  @impl Command
  def ocf(), do: 0x31
end
