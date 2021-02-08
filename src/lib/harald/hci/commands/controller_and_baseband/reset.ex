defmodule Harald.HCI.Commands.ControllerAndBaseband.Reset do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.2.
  """

  alias Harald.HCI.Commands.Command

  @behaviour Command

  @impl Command
  def decode(<<>>), do: {:ok, %{}}

  @impl Command
  def decode_return_parameters(<<status>>), do: {:ok, %{status: status}}

  @impl Command
  def encode(%{}), do: {:ok, <<>>}

  @impl Command
  def encode_return_parameters(%{status: status}), do: {:ok, <<status>>}

  @impl Command
  def ocf(), do: 0x03
end
