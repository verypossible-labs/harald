defmodule Harald.HCI.Commands.LEController do
  @moduledoc """
  Reference: version 5.2, vol 4, part E, 7.8.
  """

  alias Harald.HCI.Commands.CommandGroup

  alias Harald.HCI.Commands.LEController.{
    LESetAdvertisingData,
    LESetAdvertisingEnable,
    LESetAdvertisingParameters
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
  def ogf(), do: 0x08

  @impl CommandGroup
  def ocf_to_module(0x06), do: {:ok, LESetAdvertisingParameters}
  def ocf_to_module(0x08), do: {:ok, LESetAdvertisingData}
  def ocf_to_module(0x0A), do: {:ok, LESetAdvertisingEnable}
  def ocf_to_module(_ocf), do: {:error, :not_implemented}
end
