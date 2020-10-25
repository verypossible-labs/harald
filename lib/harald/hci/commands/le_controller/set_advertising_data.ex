defmodule Harald.HCI.Commands.LEController.SetAdvertisingData do
  @moduledoc """
  Reference: version 5.2, vol 4, part e, 7.8.7.

  ## Encode

  If `advertising_data_length`

  - is provided: the value will be used regardless of whether it is accurate.
  - is not provided: the value will be calculated automatically.
  """

  alias Harald.{HCI.Commands.Command, Host.AdvertisingData}

  @behaviour Command

  @advertising_data_size 31

  @impl Command
  def encode(%{advertising_data: decoded_advertising_data} = decoded_parameters) do
    {:ok, encoded_advertising_data} = AdvertisingData.encode(decoded_advertising_data)

    padded_encoded_advertising_data =
      String.pad_trailing(encoded_advertising_data, @advertising_data_size, <<0>>)

    advertising_data_length =
      Map.get_lazy(decoded_parameters, :advertising_data_length, fn ->
        byte_size(encoded_advertising_data)
      end)

    encoded = <<
      advertising_data_length,
      padded_encoded_advertising_data::binary-size(@advertising_data_size)
    >>

    {:ok, encoded}
  end

  def encode(_), do: {:error, :encode}

  @impl Command
  def decode(
        <<advertising_data_length, encoded_advertising_data::binary-size(@advertising_data_size)>>
      ) do
    {:ok, decoded_advertising_data} = AdvertisingData.decode(encoded_advertising_data)

    decoded = %{
      advertising_data_length: advertising_data_length,
      advertising_data: decoded_advertising_data
    }

    {:ok, decoded}
  end

  def decode(_), do: {:error, :decode}

  @impl Command
  def decode_return_parameters(<<status>>), do: {:ok, %{status: status}}

  @impl Command
  def encode_return_parameters(%{status: status}), do: {:ok, <<status>>}

  @impl Command
  def ocf(), do: 0x08
end
