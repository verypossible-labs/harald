defmodule Harald.HCI.Commands.LEController.LESetAdvertisingEnable do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.8.9.
  """

  alias Harald.HCI.Commands.Command

  @behaviour Command

  @impl Command
  def encode(%{advertising_enable: false}), do: {:ok, <<0>>}
  def encode(%{advertising_enable: true}), do: {:ok, <<1>>}

  @impl Command
  def decode(<<0>>), do: {:ok, %{advertising_enable: false}}
  def decode(<<1>>), do: {:ok, %{advertising_enable: true}}

  @impl Command
  def decode_return_parameters(<<status>>), do: {:ok, %{status: status}}

  @impl Command
  def ocf(), do: 0x0A
end
