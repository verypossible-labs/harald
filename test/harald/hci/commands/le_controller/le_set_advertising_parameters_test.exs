defmodule Harald.HCI.Commands.ControllerAndBaseband.LESetAdvertisingParametersTest do
  use ExUnit.Case, async: true
  alias Harald.HCI.Commands.{Command, LEController}
  alias Harald.HCI.{Commands, Commands.LEController.LESetAdvertisingParameters}

  test "decode/1" do
    advertising_interval_min = 0x800
    advertising_interval_max = 0x800
    advertising_type = 0x000
    own_address_type = 0x000
    peer_address_type = 0x000
    peer_address = <<0, 0, 0, 0, 0, 0>>
    advertising_channel_map = 0x007
    advertising_filter_policy = 0x000

    parameters =
      <<advertising_interval_min::little-size(16), advertising_interval_max::little-size(16),
        advertising_type, own_address_type, peer_address_type,
        peer_address::binary-little-size(6), advertising_channel_map, advertising_filter_policy>>

    parameters_length = byte_size(parameters)
    expected_bin = <<1, 6, 32, parameters_length, parameters::binary>>

    expected_command = %Command{
      command_op_code: %{
        ocf: 0x06,
        ocf_module: LESetAdvertisingParameters,
        ogf: 0x08,
        ogf_module: LEController
      },
      parameters: %{
        advertising_interval_min: advertising_interval_min,
        advertising_interval_max: advertising_interval_max,
        advertising_type: advertising_type,
        own_address_type: own_address_type,
        peer_address_type: peer_address_type,
        peer_address: peer_address,
        advertising_channel_map: advertising_channel_map,
        advertising_filter_policy: advertising_filter_policy
      }
    }

    assert {:ok, expected_command} == Commands.decode(expected_bin)
  end

  test "encode/1" do
    advertising_interval_min = 0x800
    advertising_interval_max = 0x800
    advertising_type = 0x000
    own_address_type = 0x000
    peer_address_type = 0x000
    peer_address = <<0, 0, 0, 0, 0, 0>>
    advertising_channel_map = 0x007
    advertising_filter_policy = 0x000

    parameters =
      <<advertising_interval_min::little-size(16), advertising_interval_max::little-size(16),
        advertising_type, own_address_type, peer_address_type,
        peer_address::binary-little-size(6), advertising_channel_map, advertising_filter_policy>>

    parameters_length = byte_size(parameters)
    expected_bin = <<1, 6, 32, parameters_length, parameters::binary>>
    expected_size = byte_size(expected_bin)

    parameters = %{
      advertising_interval_min: advertising_interval_min,
      advertising_interval_max: advertising_interval_max,
      advertising_type: advertising_type,
      own_address_type: own_address_type,
      peer_address_type: peer_address_type,
      peer_address: peer_address,
      advertising_channel_map: advertising_channel_map,
      advertising_filter_policy: advertising_filter_policy
    }

    assert {:ok, actual_bin} =
             Commands.encode(LEController, LESetAdvertisingParameters, parameters)

    assert expected_size == byte_size(actual_bin)
    assert expected_bin == actual_bin
  end

  test "decode_return_parameters/1" do
    status = 1
    return_parameters = <<status>>
    expected_return_parameters = %{status: status}

    assert {:ok, expected_return_parameters} ==
             LESetAdvertisingParameters.decode_return_parameters(return_parameters)
  end

  test "encode_return_parameters/1" do
    status = 1
    encoded_return_parameters = <<status>>
    decoded_return_parameters = %{status: status}

    assert {:ok, encoded_return_parameters} ==
             LESetAdvertisingParameters.encode_return_parameters(decoded_return_parameters)
  end
end
