defmodule Harald.HCI.Commands.InformationalParameters do
  @moduledoc """
  Reference: version 5.2, vol 4, part E, 7.8.
  """

  alias Harald.HCI.Commands

  alias Harald.HCI.Commands.InformationalParameters.{
    ReadBdAddr,
    ReadBufferSize,
    ReadLocalSupportedFeatures
  }

  @behaviour Commands

  @impl Commands
  def decode(ocf, bin) when is_integer(ocf) and is_binary(bin) do
    with {:ok, ocf_module} <- ocf_to_module(ocf),
         {:ok, parameters} <- ocf_module.decode(bin) do
      {:ok, {ocf_module, parameters}}
    end
  end

  @impl Commands
  def ogf(), do: 0x04

  @impl Commands
  def ocf_to_module(0x03), do: {:ok, ReadLocalSupportedFeatures}
  def ocf_to_module(0x05), do: {:ok, ReadBufferSize}
  def ocf_to_module(0x09), do: {:ok, ReadBdAddr}
  def ocf_to_module(ocf), do: {:error, {:not_implemented, {__MODULE__, ocf}}}
end
