defmodule Harald.Host.AdvertisingData do
  @moduledoc """
  Reference: version 5.2, vol 3, part c, 11.
  """

  alias Harald.Host.AdvertisingData.CompleteLocalName

  @callback ad_type() :: pos_integer()
  @callback decode(binary()) :: {:ok, map()} | {:error, :decode}
  @callback encode(map()) :: {:ok, binary()} | {:error, :encode}
  @callback new_ad_structure(map()) :: {:ok, map()} | {:error, :new_advertising_data}
  @callback new_ad_structure!(map()) :: map()

  def ad_type_to_module(0x09), do: {:ok, CompleteLocalName}
  def ad_type_to_module(_), do: {:error, :not_implemented}

  def decode(encoded_ad_structures) do
    decoded_ad_structures = do_decode(encoded_ad_structures)
    {:ok, decoded_ad_structures}
  end

  def decode_ad_structure(<<length, ad_type, encoded_ad_data::binary>>)
      when byte_size(encoded_ad_data) == length - 1 do
    decoded_ad_structure = encoded_ad_data_to_decoded_ad_structure(ad_type, encoded_ad_data)

    {:ok, decoded_ad_structure}
  end

  def encode(decoded_advertising_data) do
    decoded_advertising_data.ad_structures
    |> Enum.reduce_while(<<>>, fn decoded_ad_structure, acc ->
      case encode_ad_structure(decoded_ad_structure) do
        {:ok, encoded_ad_structure} -> {:cont, acc <> encoded_ad_structure}
        _ -> {:halt, {:error, :encode}}
      end
    end)
    |> case do
      {:error, _} = e -> e
      encoded_ad_structures -> {:ok, encoded_ad_structures}
    end
  end

  def encode_ad_structure(decoded_ad_structure) do
    {:ok, encoded_ad_data} = decoded_ad_structure.module.encode(decoded_ad_structure.ad_data)
    length = byte_size(encoded_ad_data) + 1
    encoded_ad_structure = <<length, decoded_ad_structure.ad_type, encoded_ad_data::binary>>
    {:ok, encoded_ad_structure}
  end

  def new_ad_structure(ad_type_module, decoded_ad_data) do
    new_ad_structure(ad_type_module, ad_type_module.ad_type(), decoded_ad_data)
  end

  def new_ad_structure(ad_type_module, ad_type, decoded_ad_data) do
    %{
      ad_data: decoded_ad_data,
      ad_type: ad_type,
      module: ad_type_module
    }
  end

  defp do_decode(rest, decoded_ad_structures \\ [])

  defp do_decode(<<>> = rest, decoded_ad_structures) do
    decoded_ad_structures = Enum.reverse(decoded_ad_structures)
    %{ad_structures: decoded_ad_structures, insignificant_octets: rest}
  end

  defp do_decode(<<0, _::binary>> = rest, decoded_ad_structures) do
    case :binary.decode_unsigned(rest) do
      0 ->
        decoded_ad_structures = Enum.reverse(decoded_ad_structures)
        %{ad_structures: decoded_ad_structures, insignificant_octets: rest}

      _ ->
        {:error, :decode}
    end
  end

  defp do_decode(<<length, ad_type, rest::binary>>, decoded_ad_structures) do
    ad_data_length = length - 1
    <<encoded_ad_data::binary-size(ad_data_length), rest::binary>> = rest
    decoded_ad_structure = encoded_ad_data_to_decoded_ad_structure(ad_type, encoded_ad_data)
    decoded_ad_structures = [decoded_ad_structure | decoded_ad_structures]
    do_decode(rest, decoded_ad_structures)
  end

  defp encoded_ad_data_to_decoded_ad_structure(ad_type, encoded_ad_data) do
    {:ok, ad_type_module} = ad_type_to_module(ad_type)
    {:ok, decoded_ad_data} = ad_type_module.decode(encoded_ad_data)
    new_ad_structure(ad_type_module, ad_type, decoded_ad_data)
  end
end
