defmodule Harald.HCI.Commands.ControllerAndBaseband.ReadLocalName do
  @moduledoc """
  Reference: version 5.2, Vol 4, Part E, 7.3.12.
  """

  alias Harald.HCI.Commands.Command

  @behaviour Command

  @impl Command
  def encode(%{}), do: {:ok, <<>>}

  @impl Command
  def decode(<<>>), do: {:ok, %{}}

  @impl Command
  def decode_return_parameters(<<status, local_name::binary-size(248)>>) do
    {:ok, %{status: status, local_name: local_name}}
  end

  @impl Command
  def ocf(), do: 0x14
end
