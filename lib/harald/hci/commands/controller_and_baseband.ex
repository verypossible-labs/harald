defmodule Harald.HCI.Commands.ControllerAndBaseband do
  @moduledoc """
  Reference: version 5.1, vol 2, part E, 7.3.
  """

  alias Harald.HCI.Commands

  alias Harald.HCI.Commands.ControllerAndBaseband.{
    HostBufferSize,
    HostNumberOfCompletedPackets,
    ReadLocalName,
    Reset,
    SetEventMask,
    SetEventMaskPage2,
    WriteFlowControlMode,
    WriteLocalName,
    WritePinType,
    WriteSimplePairingMode,
    SetControllerToHostFlowControl
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
  def ogf(), do: 0x03

  @impl Commands
  def ocf_to_module(0x0001), do: {:ok, SetEventMask}
  def ocf_to_module(0x0003), do: {:ok, Reset}
  def ocf_to_module(0x000A), do: {:ok, WritePinType}
  def ocf_to_module(0x0013), do: {:ok, WriteLocalName}
  def ocf_to_module(0x0014), do: {:ok, ReadLocalName}
  def ocf_to_module(0x0031), do: {:ok, SetControllerToHostFlowControl}
  def ocf_to_module(0x0033), do: {:ok, HostBufferSize}
  def ocf_to_module(0x0035), do: {:ok, HostNumberOfCompletedPackets}
  def ocf_to_module(0x0056), do: {:ok, WriteSimplePairingMode}
  def ocf_to_module(0x0063), do: {:ok, SetEventMaskPage2}
  def ocf_to_module(0x0066), do: {:ok, ReadFlowControlMode}
  def ocf_to_module(0x0067), do: {:ok, WriteFlowControlMode}
  def ocf_to_module(ocf), do: {:error, {:not_implemented, {__MODULE__, ocf}}}
end
