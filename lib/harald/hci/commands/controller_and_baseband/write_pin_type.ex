defmodule Harald.HCI.Commands.ControllerAndBaseband.WritePinType do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.6.
  """

  alias Harald.HCI.Commands.Command

  @behaviour Command

  @impl Command
  def encode(%{pin_type: :variable}), do: {:ok, <<0>>}
  def encode(%{pin_type: :fixed}), do: {:ok, <<1>>}

  @impl Command
  def decode(<<0>>), do: {:ok, %{pin_type: :variable}}
  def decode(<<1>>), do: {:ok, %{pin_type: :fixed}}

  @impl Command
  def decode_return_parameters(<<status>>), do: {:ok, %{status: status}}

  @impl Command
  def encode_return_parameters(%{status: status}), do: {:ok, <<status>>}

  @impl Command
  def ocf(), do: 0xA
end
