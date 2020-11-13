defmodule Harald.HCI.Commands.LEController do
  @moduledoc """
  Reference: version 5.2, vol 4, part E, 7.8.
  """

  alias Harald.HCI.Commands

  alias Harald.HCI.Commands.LEController.{
    ReadBufferSizeV1,
    SetAdvertisingData,
    SetAdvertisingEnable,
    SetAdvertisingParameters,
    SetEventMask
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
  def ogf(), do: 0x08

  @impl Commands
  def ocf_to_module(0x01), do: {:ok, SetEventMask}
  def ocf_to_module(0x02), do: {:ok, ReadBufferSizeV1}
  def ocf_to_module(0x06), do: {:ok, SetAdvertisingParameters}
  def ocf_to_module(0x08), do: {:ok, SetAdvertisingData}
  def ocf_to_module(0x0A), do: {:ok, SetAdvertisingEnable}
  def ocf_to_module(ocf), do: {:error, {:not_implemented, {__MODULE__, ocf}}}
end
