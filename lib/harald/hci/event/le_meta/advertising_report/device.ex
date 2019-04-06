defmodule Harald.HCI.Event.LEMeta.AdvertisingReport.Device do
  @moduledoc """
  A struct representing a single device within a LE Advertising Report.

  > The LE Advertising Report event indicates that one or more Bluetooth devices have responded to
  > an active scan or have broadcast advertisements that were received during a passive scan. The
  > Controller may queue these advertising reports and send information from multiple devices in
  > one LE Advertising Report event.
  >
  > This event shall only be generated if scanning was enabled using the LE Set Scan Enable
  > command. It only reports advertising events that used legacy advertising PDUs.

  Reference: Version 5.0, Vol 2, Part E, 7.7.65.2

  The `:data` field of an `Harald.HCI.Event.LEMeta.AdvertisingReport.Device` struct represents AD
  Structures.

  > The significant part contains a sequence of AD structures. Each AD structure shall have a
  > Length field of one octet, which contains the Length value, and a Data field of Length octets.

  Reference: Version 5.0, Vol 3, Part C, 11
  """

  alias Harald.HCI.{ArrayedData, Event.LEMeta.AdvertisingReport.Device}
  alias Harald.{ManufacturerData, Serializable, Transport.UART.Framing}
  require Harald.AssignedNumbers.GenericAccessProfile, as: GenericAccessProfile

  @enforce_keys [:event_type, :address_type, :address, :data, :rss]

  defstruct @enforce_keys

  @arrayed_data_schema [
    event_type: 8,
    address_type: 8,
    address: 48,
    length_data: {:variable, :data, 8},
    data: :length_data,
    rss: 8
  ]

  @type t :: %__MODULE__{}

  @behaviour Serializable

  @subevent_code 0x02

  @doc """
  See: `t:Harald.HCI.Event.LEMeta.subevent_code/0`.
  """
  def subevent_code, do: @subevent_code

  @doc """
  Serializes a list of `Harald.HCI.Event.LEMeta.AdvertisingReport` structs into a LE Advertising
  Report Event.

      iex> AdvertisingReport.serialize([
      ...>   %AdvertisingReport{
      ...>     event_type: 0,
      ...>     address_type: 1,
      ...>     address: 2,
      ...>     data: [],
      ...>     rss: 4
      ...>   },
      ...>   %AdvertisingReport{
      ...>     event_type: 1,
      ...>     address_type: 2,
      ...>     address: 5,
      ...>     data: [{"Service Data - 32-bit UUID", %{uuid: 1, data: <<2>>}}],
      ...>     rss: 7
      ...>   }
      ...> ])
      {:ok,
       <<2, 2, 0, 1, 1, 2, 2, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 7, 6, 32, 1, 0, 0, 0, 2, 4, 7>>}
  """
  @impl Serializable
  def serialize(devices) when is_list(devices) do
    devices = for device <- devices, do: serialize_device_data(device)
    ArrayedData.serialize(@arrayed_data_schema, devices)
  end

  @doc """
  Given a list of `Harald.HCI.Event.LEMeta.AdvertisingReport.Device` structs', serializes their
  `:data` fields into AD Structures.

      iex> serialize_device_data(
      ...>   %AdvertisingReport.Device{
      ...>     address: 1,
      ...>     address_type: 2,
      ...>     data: [
      ...>       {"Manufacturer Specific Data",
      ...>        {"Apple, Inc.",
      ...>         {"iBeacon",
      ...>          %{
      ...>            major: 4,
      ...>            minor: 5,
      ...>            tx_power: 6,
      ...>            uuid: 7
      ...>          }}}},
      ...>       {"Service Data - 32-bit UUID", %{uuid: 8, data: <<9>>}}
      ...>     ],
      ...>     event_type: 1,
      ...>     rss: 2
      ...>   }
      ...> )
      [
        %Harald.HCI.Event.LEMeta.AdvertisingReport.Device{
          address: 1,
          address_type: 2,
          data: <<25, 255, 76, 2, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 4, 0, 5,
                  6, 6, 32, 8, 0, 0, 0, 9>>,
          event_type: 1,
          rss: 2
        }
      ]
  """
  def serialize_device_data(device) do
    Map.update!(device, :data, fn data ->
      data
      |> serialize_advertising_data()
      |> case do
        {:ok, bin} -> bin
        {:error, _} = error -> error
      end
    end)
  end

  @doc """
  Serializes a `Harald.HCI.Event.LEMeta.AdvertisingReport` struct's `:data` field into AD
  Structures.

      iex> serialize_advertising_data([
      ...>   {"Manufacturer Specific Data",
      ...>     {"Apple, Inc.",
      ...>       {"iBeacon",
      ...>         %{
      ...>           major: 1,
      ...>           minor: 2,
      ...>           tx_power: 3,
      ...>           uuid: 1
      ...>         }}}},
      ...>   {"Service Data - 32-bit UUID", %{uuid: 1, data: <<2>>}}
      ...> ])
      {:ok,
       <<25, 255, 76, 2, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 2, 3, 6, 32,
         1, 0, 0, 0, 2>>}
  """
  def serialize_advertising_data(ads, bin \\ <<>>)

  def serialize_advertising_data([], bin) do
    {:ok, bin}
  end

  def serialize_advertising_data([{:error, {:bad_length, length, data}} | ads], bin) do
    serialize_advertising_data(ads, <<bin::bits, length, data::bits>>)
  end

  def serialize_advertising_data([{:error, {:unknown_type, {ad_type, ad_data}}} | ads], bin) do
    data = <<ad_type, ad_data::bits>>
    length = byte_size(data)
    serialize_advertising_data(ads, <<bin::bits, length, data::bits>>)
  end

  def serialize_advertising_data([{:early_termination, 0} | ads], bin) do
    serialize_advertising_data(ads, <<bin::bits, 0>>)
  end

  def serialize_advertising_data([{"Manufacturer Specific Data", data} | ads], bin) do
    data
    |> ManufacturerData.serialize()
    |> case do
      {:ok, company_bin} ->
        manufacturer_data_bin = <<
          GenericAccessProfile.id("Manufacturer Specific Data"),
          company_bin::binary
        >>

        length = byte_size(manufacturer_data_bin)
        serialize_advertising_data(ads, <<bin::bits, length, manufacturer_data_bin::binary>>)

      {:error, {company_bin, data}} ->
        manufacturer_data_bin = <<
          GenericAccessProfile.id("Manufacturer Specific Data"),
          company_bin::binary
        >>

        length = byte_size(manufacturer_data_bin)
        {:error, {<<bin::bits, length, manufacturer_data_bin::binary>>, data, ads}}
    end
  end

  def serialize_advertising_data(
        [{"Service Data - 32-bit UUID", %{data: data, uuid: uuid}} | ads],
        bin
      ) do
    service_data_32 = <<
      GenericAccessProfile.id("Service Data - 32-bit UUID"),
      uuid::little-size(32),
      data::binary
    >>

    length = byte_size(service_data_32)
    serialize_advertising_data(ads, <<bin::bits, length, service_data_32::binary>>)
  end

  def serialize_advertising_data([{ad_type, ad_data} | ads], bin) do
    data = <<ad_type, ad_data::bits>>
    length = byte_size(data)
    serialize_advertising_data(ads, <<bin::bits, length, data::bits>>)
  end

  @doc """
  Deserializes a LE Advertising Report Event into `Harald.HCI.Event.LEMeta.AdvertisingReport`
  structs.

      iex> AdvertisingReport.deserialize(
      ...>   <<2, 2, 0, 1, 1, 2, 2, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 7, 6, 32, 1, 0, 0, 0, 2, 4,
      ...>     7>>
      ...> )
      {:ok, [
        %AdvertisingReport{
          event_type: 0,
          address_type: 1,
          address: 2,
          data: [],
          rss: 4
        },
        %AdvertisingReport{
          event_type: 1,
          address_type: 2,
          address: 5,
          data: [{"Service Data - 32-bit UUID", %{uuid: 1, data: <<2>>}}],
          rss: 7
        }
      ]}
  """
  @impl Serializable
  def deserialize(<<num_reports, arrayed_parameters::binary>> = bin) do
    @arrayed_data_schema
    |> ArrayedData.deserialize(num_reports, Device, arrayed_parameters)
    |> case do
      {:ok, devices} -> deserialize_advertising_datas(devices)
      {:error, _} -> {:error, bin}
    end
  end

  def deserialize(bin), do: {:error, bin}

  @doc """
      iex> deserialize_advertising_data(<<25, 255, 76, 2, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      ...>   0, 0, 0, 1, 0, 1, 0, 2, 3, 6, 32, 1, 0, 0, 0, 2>>)
      {:ok, [
        {"Manufacturer Specific Data", {"Apple, Inc.", {"iBeacon", %{
          major: 1,
          minor: 2,
          tx_power: 3,
          uuid: 1
        }}}},
        {"Service Data - 32-bit UUID", %{uuid: 1, data: <<2>>}}]
      }
  """
  def deserialize_advertising_data(data, acc \\ {:ok, []})

  def deserialize_advertising_data(<<>>, {status, ads}), do: {status, Enum.reverse(ads)}

  # > If the Length field is set to zero, then the Data field has zero octets. This shall only
  # > occur to allow an early termination of the Advertising or Scan Response data.
  # Reference Version 5.0, Vol 3, Part C, 11
  def deserialize_advertising_data(<<0, data::binary>>, {status, ads}) do
    deserialize_advertising_data(data, {status, [{:early_termination, 0} | ads]})
  end

  def deserialize_advertising_data(<<length>>, {_, ads}) do
    # AD Structure with a non-zero length and no data
    deserialize_advertising_data(<<>>, {:error, [{:error, {:bad_length, length, <<>>}} | ads]})
  end

  def deserialize_advertising_data(<<length>> <> data, {status, ads}) do
    data_length = byte_size(data)

    case length > data_length do
      true ->
        # AD Structure with a non-zero length and not enough data
        deserialize_advertising_data(
          <<>>,
          {:error, [{:error, {:bad_length, length, data}} | ads]}
        )

      false ->
        {0, ad_structure, rest} = Framing.binary_split(data, length)

        case deserialize_ads(ad_structure) do
          {:ok, ad} ->
            deserialize_advertising_data(rest, {status, [ad | ads]})

          {:error, _} = error ->
            deserialize_advertising_data(rest, {:error, [error | ads]})
        end
    end
  end

  @doc """
  Deserializes AD Structures.

      iex> deserialize_ads(<<0xFF, 76, 2, 0x15, 1::size(168)>>)
      {:ok,
       {"Manufacturer Specific Data",
        {"Apple, Inc.", {"iBeacon", %{major: 0, minor: 0, tx_power: 1, uuid: 0}}}}}

      iex> deserialize_ads(<<0x20, 1::size(40)>>)
      {:ok, {"Service Data - 32-bit UUID", %{uuid: 0, data: <<1>>}}}

      iex> deserialize_ads(<<0xFF>>)
      {:error, {"Manufacturer Specific Data", {:error, {:unhandled_company_id, <<>>}}}}

      iex> deserialize_ads(<<0x44, 1, 2, 3>>)
      {:error, {:unknown_type, {0x44, <<1, 2, 3>>}}}
  """
  def deserialize_ads(<<GenericAccessProfile.id("Manufacturer Specific Data"), bin::binary>>) do
    bin
    |> ManufacturerData.deserialize()
    |> case do
      {:ok, data} -> {:ok, {"Manufacturer Specific Data", data}}
      {:error, _} = error -> {:error, {"Manufacturer Specific Data", error}}
    end
  end

  def deserialize_ads(<<GenericAccessProfile.id("Service Data - 32-bit UUID"), bin::binary>>) do
    <<
      uuid::little-size(32),
      data::binary
    >> = bin

    service_data_32 = %{
      uuid: uuid,
      data: data
    }

    {:ok, {"Service Data - 32-bit UUID", service_data_32}}
  end

  def deserialize_ads(<<type, bin::bits>>) when type in GenericAccessProfile.ids() do
    {:ok, {type, bin}}
  end

  def deserialize_ads(<<type, bin::bits>>), do: {:error, {:unknown_type, {type, bin}}}

  defp deserialize_advertising_datas(devices) do
    {status, devices} =
      Enum.reduce(devices, {:ok, []}, fn device, {status, devices} ->
        {status, device} = update_device(device, status)
        {status, [device | devices]}
      end)

    {status, Enum.reverse(devices)}
  end

  defp update_device(device, status) do
    Map.get_and_update(device, :data, fn data ->
      case deserialize_advertising_data(data) do
        {:ok, data} -> {status, data}
        {:error, data} -> {:error, data}
      end
    end)
  end
end
