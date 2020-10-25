defmodule Harald.HCI.Commands.ControllerAndBaseband do
  @moduledoc """
  Reference: version 5.1, vol 2, part E, 7.3.
  """

  alias Harald.HCI.Commands.CommandGroup

  alias Harald.HCI.Commands.ControllerAndBaseband.{
    ReadLocalName,
    WriteLocalName,
    WritePinType,
    WriteSimplePairingMode,
    SetEventMask
  }

  @behaviour CommandGroup

  @impl CommandGroup
  def decode(ocf, bin) when is_integer(ocf) and is_binary(bin) do
    with {:ok, ocf_module} <- ocf_to_module(ocf),
         {:ok, parameters} <- ocf_module.decode(bin) do
      {:ok, {ocf_module, parameters}}
    end
  end

  @impl CommandGroup
  def ogf(), do: 0x03

  @impl CommandGroup
  def ocf_to_module(0x01), do: {:ok, SetEventMask}
  def ocf_to_module(0x0A), do: {:ok, WritePinType}
  def ocf_to_module(0x13), do: {:ok, WriteLocalName}
  def ocf_to_module(0x14), do: {:ok, ReadLocalName}
  def ocf_to_module(0x56), do: {:ok, WriteSimplePairingMode}
  def ocf_to_module(ocf), do: {:error, {:not_implemented, {__MODULE__, ocf}}}
end
