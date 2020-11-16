defmodule Harald.HCI.Commands.InformationalParameters.ReadBDADDR do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.4.6.
  """

  alias Harald.HCI.{Commands.Command, ErrorCodes, Events.Event}

  @behaviour Command

  @impl Command
  def decode(<<>>), do: {:ok, %{}}

  @impl Command
  def decode_return_parameters(<<status, bd_addr::little-size(48)>>) do
    {:ok, decoded_status} = ErrorCodes.decode(status)
    {:ok, %{status: decoded_status, bd_addr: bd_addr}}
  end

  @impl Command
  def encode(%{}), do: {:ok, <<>>}

  @impl Command
  def encode_return_parameters(%{status: decoded_status, bd_addr: bd_addr}) do
    {:ok, encoded_status} = ErrorCodes.encode(decoded_status)
    {:ok, <<encoded_status, bd_addr::little-size(48)>>}
  end

  @impl Command
  def ocf(), do: 0x09
end
