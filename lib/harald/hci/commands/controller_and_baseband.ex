defmodule Harald.HCI.Commands.ControllerAndBaseband do
  @moduledoc """
  Reference: version 5.1, vol 2, part E, 7.3.
  """

  alias Harald.HCI.Commands.CommandGroup

  @behaviour CommandGroup

  @impl CommandGroup
  def decode(ocf, bin) when is_integer(ocf) and is_binary(bin) do
    with {:ok, ocf_module} <- ocf_to_module(ocf) do
      ocf_module.decode(bin)
    end
  end

  @impl CommandGroup
  def ogf(), do: 0x3

  @impl CommandGroup
  def ocf_to_module(0x14), do: {:ok, ReadLocalName}
  def ocf_to_module(_ocf), do: {:error, :not_implemented}
end
