defmodule Harald.Host.AdvertisingData.CompleteLocalName do
  @moduledoc """
  Reference: css v9, part a, 1.2.

  Additional references:

  - https://www.bluetooth.com/specifications/assigned-numbers/generic-access-profile/.
  """

  alias Harald.Host.AdvertisingData

  @behaviour AdvertisingData

  @impl AdvertisingData
  def ad_type(), do: 0x09

  @impl AdvertisingData
  def decode(complete_local_name), do: {:ok, %{complete_local_name: complete_local_name}}

  @impl AdvertisingData
  def encode(%{complete_local_name: complete_local_name}), do: {:ok, complete_local_name}

  @impl AdvertisingData
  def new_ad_structure(complete_local_name) when is_binary(complete_local_name) do
    ret =
      AdvertisingData.new_ad_structure(__MODULE__, %{complete_local_name: complete_local_name})

    {:ok, ret}
  end

  def new_ad_structure(_), do: {:error, :new_ad_structure}

  @impl AdvertisingData
  def new_ad_structure!(complete_local_name) when is_binary(complete_local_name) do
    AdvertisingData.new_ad_structure(__MODULE__, %{complete_local_name: complete_local_name})
  end
end
