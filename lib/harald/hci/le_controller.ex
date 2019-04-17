defmodule Harald.HCI.LEController do
  @moduledoc """
  > The LE Controller Commands provide access and control to various capabilities of the Bluetooth
  > hardware, as well as methods for the Host to affect how the Link Layer manages the piconet,
  > and controls connections.

  Reference: Version 5.0, Vol 2, Part E, 7.8
  """

  alias Harald.HCI

  @ogf 0x08

  @doc """
  > The LE_Set_Scan_Enable command is used to start scanning. Scanning is used to discover
  > advertising devices nearby.
  >
  > The Filter_Duplicates parameter controls whether the Link Layer should filter out duplicate
  > advertising reports (Filtering_Enabled) to the Host, or if the Link Layer should generate
  > advertising reports for each packet received (Filtering_Disabled). See [Vol 6] Part B, Section
  > 4.4.3.5.
  >
  > If the scanning parameters' Own_Address_Type parameter is set to 0x01 or 0x03 and the random
  > address for the device has not been initialized, the Controller shall return the error code
  > Invalid HCI Command Parameters (0x12).
  >
  > If the LE_Scan_Enable parameter is set to 0x01 and scanning is already enabled, any change to
  > the Filter_Duplicates setting shall take effect. Note: Disabling scanning when it is disabled
  > has no effect.

  Reference: Version 5.0, Vol 2, Part E, 7.8.11

      iex> set_enable_scan(true)
      <<12, 32, 2, 1, 0>>

      iex> set_enable_scan(false)
      <<12, 32, 2, 0, 0>>
  """
  @spec set_enable_scan(HCI.opt(), HCI.opt()) :: HCI.command()
  def set_enable_scan(enable, filter_duplicates \\ false) do
    @ogf |> HCI.opcode(0x000C) |> HCI.command([enable, filter_duplicates])
  end

  @doc """
  > The LE_Set_Scan_Parameters command is used to set the scan parameters. The LE_Scan_Type
  > parameter controls the type of scan to perform.
  >
  > The LE_Scan_Interval and LE_Scan_Window parameters are recommendations from the Host on how
  > long (LE_Scan_Window) and how frequently (LE_Scan_Interval) the Controller should scan
  > (See [Vol 6] Part B, Section 4.5.3). The LE_Scan_Window parameter shall always be set to a
  > value smaller or equal to the value set for the LE_Scan_Interval parameter. If they are set to
  > the same value scanning should be run continuously.
  >
  > Own_Address_Type parameter indicates the type of address being used in the scan request
  > packets.
  >
  > The Host shall not issue this command when scanning is enabled in the Controller; if it is the
  > Command Disallowed error code shall be used.

  Reference: Version 5.0, Vol 2, Part E, 7.8.10

      iex> set_scan_parameters(le_scan_type: 0x01)
      <<11, 32, 7, 1, 16, 0, 16, 0, 0, 0>>

      iex> set_scan_parameters(
      iex>   le_scan_type: 0x01,
      iex>   le_scan_interval: 0x0004,
      iex>   le_scan_window: 0x0004,
      iex>   own_address_type: 0x01,
      iex>   scanning_filter_policy: 0x01
      iex> )
      <<11, 32, 7, 1, 4, 0, 4, 0, 1, 1>>
  """
  @spec set_scan_parameters(keyword) :: HCI.command()
  def set_scan_parameters(new_params) do
    # Defaults according to the Bluetooth Core Spec v5.
    params =
      [
        le_scan_type: 0x00,
        le_scan_interval: 0x0010,
        le_scan_window: 0x0010,
        own_address_type: 0x00,
        scanning_filter_policy: 0x00
      ]
      |> Keyword.merge(new_params)

    opts = <<
      params[:le_scan_type],
      params[:le_scan_interval]::size(16)-little,
      params[:le_scan_window]::size(16)-little,
      params[:own_address_type],
      params[:scanning_filter_policy]
    >>

    @ogf |> HCI.opcode(0x000B) |> HCI.command(opts)
  end
end
