defmodule Harald.HCI.Commands.ControllerAndBaseband.ReadLocalName do
  alias Harald.HCI.Commands.Command

  @behaviour Command

  @impl Command
  def encode(%{}), do: {:ok, <<>>}

  @impl Command
  def decode(<<>>), do: {:ok, %{}}

  @impl Command
  def ocf(), do: 0x14
end
