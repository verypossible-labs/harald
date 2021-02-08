defmodule Harald.Host.AdvertisingData.CompleteListOf128BitServiceClassUUIDs do
  @moduledoc """
  Reference: css v9, part a, 1.1.2

  Additional references:

  - https://www.bluetooth.com/specifications/assigned-numbers/generic-access-profile/.
  """

  alias Harald.Host.AdvertisingData

  @behaviour AdvertisingData

  @impl AdvertisingData
  def ad_type(), do: 0x07

  @impl AdvertisingData
  def decode(service_uuids) do
    service_uuid_list = for <<service_uuid::little-size(128) <- service_uuids>>, do: service_uuid

    {:ok, %{service_uuid_list: service_uuid_list}}
  end

  @impl AdvertisingData
  def encode(%{service_uuid_list: service_uuid_list}) do
    bin = for uuid <- service_uuid_list, do: <<uuid::little-size(128)>>

    service_uuids = Enum.join(bin)

    {:ok, service_uuids}
  end

  @impl AdvertisingData
  def new_ad_structure(service_uuid_list) when is_list(service_uuid_list) do
    ret = AdvertisingData.new_ad_structure(__MODULE__, %{service_uuid_list: service_uuid_list})

    {:ok, ret}
  end

  def new_ad_structure(_), do: {:error, :new_ad_structure}

  @impl AdvertisingData
  def new_ad_structure!(service_uuid_list) when is_list(service_uuid_list) do
    AdvertisingData.new_ad_structure(__MODULE__, %{
      service_class_uuid_list: service_uuid_list
    })
  end
end
