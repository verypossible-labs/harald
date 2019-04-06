defmodule Harald.HCI.Event.LEMeta.AdvertisingReport do
  @moduledoc """
  A struct representing a LE Advertising Report.

  > The LE Advertising Report event indicates that one or more Bluetooth devices have responded to
  > an active scan or have broadcast advertisements that were received during a passive scan. The
  > Controller may queue these advertising reports and send information from multiple devices in
  > one LE Advertising Report event.
  >
  > This event shall only be generated if scanning was enabled using the LE Set Scan Enable
  > command. It only reports advertising events that used legacy advertising PDUs.

  Reference: Version 5.0, Vol 2, Part E, 7.7.65.2
  """

  alias Harald.HCI.{Event.LEMeta.AdvertisingReport.Device}
  alias Harald.Serializable

  @enforce_keys [:devices]

  defstruct @enforce_keys

  @type t :: %__MODULE__{}

  @behaviour Serializable

  @subevent_code 0x02

  @doc """
  See: `t:Harald.HCI.Event.LEMeta.subevent_code/0`.
  """
  def subevent_code, do: @subevent_code

  @doc """
  Serializes a `Harald.HCI.Event.LEMeta.AdvertisingReport` struct into a LE Advertising Report
  Event.

      iex> AdvertisingReport.serialize(
      ...>   %AdvertisingReport{
      ...>     devices: [
      ...>       %AdvertisingReport.Device{
      ...>         event_type: 0,
      ...>         address_type: 1,
      ...>         address: 2,
      ...>         data: [],
      ...>         rss: 4
      ...>       },
      ...>       %AdvertisingReport.Device{
      ...>         event_type: 1,
      ...>         address_type: 2,
      ...>         address: 5,
      ...>         data: [{"Service Data - 32-bit UUID", %{uuid: 1, data: <<2>>}}],
      ...>         rss: 7
      ...>       }
      ...>     ]
      ...>   }
      ...> )
      {:ok,
       <<2, 2, 0, 1, 1, 2, 2, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 7, 6, 32, 1, 0, 0, 0, 2, 4, 7>>}
  """
  @impl Serializable
  def serialize(advertising_report) do
    {:ok, bin} = Device.serialize(advertising_report.devices)
    {:ok, <<@subevent_code, bin::binary>>}
  end

  @doc """
  Deserializes a LE Advertising Report Event into `Harald.HCI.Event.LEMeta.AdvertisingReport`
  structs.

      iex> AdvertisingReport.deserialize(
      ...>   <<2, 2, 0, 1, 1, 2, 2, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 7, 6, 32, 1, 0, 0, 0, 2, 4,
      ...>     7>>
      ...> )
      {:ok, %AdvertisingReport{
          devices: [
            %AdvertisingReport.Device{
              event_type: 0,
              address_type: 1,
              address: 2,
              data: [],
              rss: 4
            },
            %AdvertisingReport.Device{
              event_type: 1,
              address_type: 2,
              address: 5,
              data: [{"Service Data - 32-bit UUID", %{uuid: 1, data: <<2>>}}],
              rss: 7
            }
          ]
        }
      }
  """
  @impl Serializable
  def deserialize(<<@subevent_code, arrayed_bin::binary>> = bin) do
    case Device.deserialize(arrayed_bin) do
      {:ok, devices} -> {:ok, %__MODULE__{devices: devices}}
      {:error, _} -> {:error, bin}
    end
  end

  def deserialize(bin), do: {:error, bin}
end
