defmodule Harald.HCI.Commands.ControllerAndBaseband.WriteSynchronousFlowControlEnable do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.37.
  """

  alias Harald.HCI.Commands.Command

  @behaviour Command

  @impl Command
  def encode(%{synchronous_flow_control_enable: true}), do: {:ok, <<1>>}
  def encode(%{synchronous_flow_control_enable: false}), do: {:ok, <<0>>}

  @impl Command
  def decode(<<1>>), do: {:ok, %{synchronous_flow_control_enable: true}}
  def decode(<<0>>), do: {:ok, %{synchronous_flow_control_enable: false}}

  @impl Command
  def decode_return_parameters(<<status>>), do: {:ok, %{status: status}}

  @impl Command
  def encode_return_parameters(%{status: status}), do: {:ok, <<status>>}

  @impl Command
  def ocf(), do: 0x2F
end
