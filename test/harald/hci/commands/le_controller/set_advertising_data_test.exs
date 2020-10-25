defmodule Harald.HCI.Commands.ControllerAndBaseband.SetAdvertisingDataTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Commands.LEController.SetAdvertisingData
  alias Harald.Host.AdvertisingData.CompleteLocalName

  test "decode/1" do
    {decoded_ad_structure, encoded_ad_structure} = ad_structure_pair()
    encoded_advertising_data = encoded_ad_structure
    advertising_data_length = byte_size(encoded_advertising_data)
    padded_encoded_advertising_data = String.pad_trailing(encoded_advertising_data, 31, <<0>>)
    encoded_parameters = <<advertising_data_length, padded_encoded_advertising_data::binary>>

    insignificant_octets =
      binary_part(
        padded_encoded_advertising_data,
        advertising_data_length,
        31 - advertising_data_length
      )

    decoded_advertising_data = %{
      ad_structures: [decoded_ad_structure],
      insignificant_octets: insignificant_octets
    }

    expected_decoded_parameters = %{
      advertising_data_length: advertising_data_length,
      advertising_data: decoded_advertising_data
    }

    assert {:ok, expected_decoded_parameters} == SetAdvertisingData.decode(encoded_parameters)
  end

  test "decode_return_parameters/1" do
    status = 1
    return_parameters = <<status>>
    expected_return_parameters = %{status: status}

    assert {:ok, expected_return_parameters} ==
             SetAdvertisingData.decode_return_parameters(return_parameters)
  end

  test "encode/1" do
    {decoded_ad_structure, encoded_ad_structure} = ad_structure_pair()
    encoded_advertising_data = encoded_ad_structure
    advertising_data_length = byte_size(encoded_advertising_data)
    padded_encoded_advertising_data = String.pad_trailing(encoded_advertising_data, 31, <<0>>)

    insignificant_octets =
      binary_part(
        padded_encoded_advertising_data,
        advertising_data_length,
        31 - advertising_data_length
      )

    decoded_advertising_data = %{
      ad_structures: [decoded_ad_structure],
      insignificant_octets: insignificant_octets
    }

    padded_encoded_advertising_data = String.pad_trailing(encoded_advertising_data, 31, <<0>>)

    expected_encoded_parameters =
      <<advertising_data_length, padded_encoded_advertising_data::binary>>

    decoded_parameters = %{
      advertising_data_length: advertising_data_length,
      advertising_data: decoded_advertising_data
    }

    assert {:ok, expected_encoded_parameters} == SetAdvertisingData.encode(decoded_parameters)
  end

  test "encode_return_parameters/1" do
    status = 1
    encoded_return_parameters = <<status>>
    decoded_return_parameters = %{status: status}

    assert {:ok, encoded_return_parameters} ==
             SetAdvertisingData.encode_return_parameters(decoded_return_parameters)
  end

  test "ocf/0" do
    assert 0x08 == SetAdvertisingData.ocf()
  end

  defp ad_structure_pair() do
    complete_local_name = "bob"
    ad_module = CompleteLocalName
    ad_type = ad_module.ad_type()

    decoded_ad_structure = %{
      ad_data: %{complete_local_name: complete_local_name},
      ad_type: ad_type,
      module: ad_module
    }

    ad_data = complete_local_name
    data = <<ad_type, ad_data::binary>>
    length = byte_size(data)
    encoded_ad_structure = <<length, data::binary>>
    {decoded_ad_structure, encoded_ad_structure}
  end
end
