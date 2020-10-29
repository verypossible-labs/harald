defmodule Harald.Host.ATT.FindInformationRsp do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.3.2
  """

  def encode(%{format: format, information_data: information_data})
      when format == :handle_and_16_bit_uuid do
    encoded_information_data = encode_information_data(16, information_data)
    {:ok, <<0x1::little-size(8), encoded_information_data::binary>>}
  end

  def encode(%{format: format, information_data: information_data})
      when format == :handle_and_128_bit_uuid do
    encoded_information_data = encode_information_data(128, information_data)
    {:ok, <<0x2::little-size(8), encoded_information_data::binary>>}
  end

  def encode(decoded_find_information_rsp) do
    {:error, {:encode, {__MODULE__, decoded_find_information_rsp}}}
  end

  def encode_information_data(uuid_size, decoded_information_data) do
    encoded_information_data =
      for data_element <- decoded_information_data do
        handle = data_element.handle
        uuid = data_element.uuid
        <<handle::little-size(16), uuid::little-size(uuid_size)>>
      end

    Enum.join(encoded_information_data)
  end

  def decode(<<format::little-size(8), information_data::binary>>)
      when byte_size(information_data) == 0 do
    {:error, {:decode, {__MODULE__, <<format>>}}}
  end

  def decode(<<format::little-size(8), information_data::binary>>)
      when format == 0x01 and rem(byte_size(information_data), 4) == 0 do
    decoded_information_data =
      for <<handle::little-size(16), uuid::little-size(16) <- information_data>> do
        %{handle: handle, uuid: uuid}
      end

    parameters = %{format: :handle_and_16_bit_uuid, information_data: decoded_information_data}
    {:ok, parameters}
  end

  def decode(<<format::little-size(8), information_data::binary>>)
      when format == 0x02 and rem(byte_size(information_data), 18) == 0 do
    decoded_information_data =
      for <<handle::little-size(16), uuid::little-size(128) <- information_data>> do
        %{handle: handle, uuid: uuid}
      end

    parameters = %{format: :handle_and_128_bit_uuid, information_data: decoded_information_data}
    {:ok, parameters}
  end

  def decode(encoded_find_information_rsp) do
    {:error, {:decode, {__MODULE__, encoded_find_information_rsp}}}
  end

  def opcode(), do: 0x05
end
