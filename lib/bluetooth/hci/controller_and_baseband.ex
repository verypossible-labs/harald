defmodule Bluetooth.HCI.ControllerAndBaseband do
  alias Bluetooth.HCI

  @moduledoc """
  HCI commands for working with the controller and baseband.

  > The Controller & Baseband Commands provide access and control to various capabilities of the
  > Bluetooth hardware. These parameters provide control of BR/EDR Controllers and of the
  > capabilities of the Link Manager and Baseband in the BR/EDR Controller, the PAL in an AMP
  > Controller, and the Link Layer in an LE Controller. The Host can use these commands to modify
  > the behavior of the local Controller.
  Bluetooth Spec v5
  """

  @ogf 0x03

  @doc """
  > The Read_Local_Name command provides the ability to read the stored user-friendly name for
  > the BR/EDR Controller. See Section 6.23.

      iex> read_local_name()
      <<20, 12, 0>>
  """
  @spec read_local_name :: HCI.command()
  def read_local_name, do: @ogf |> HCI.opcode(0x0014) |> HCI.command()
end
