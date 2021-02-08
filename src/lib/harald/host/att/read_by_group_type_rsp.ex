defmodule Harald.Host.ATT.ReadByGroupTypeRsp do
  @moduledoc """
  Reference: version 5.2, Vol 3, Part F, 3.4.4.10
  """

  def encode(%{length: length, attribute_data_list: attribute_data_list}) do
    value_length = (length - 4) * 8

    encoded_attribute_data_list =
      for data_element <- attribute_data_list do
        attribute_handle = data_element.attribute_handle
        end_group_handle = data_element.end_group_handle
        attribute_value = data_element.attribute_value

        <<attribute_handle::little-size(16), end_group_handle::little-size(16),
          attribute_value::little-size(value_length)>>
      end

    encoded_attribute_data = Enum.join(encoded_attribute_data_list)

    {:ok, <<length::size(8), encoded_attribute_data::binary>>}
  end

  def encode(decoded_read_by_group_type_rsp) do
    {:error, {:encode, {__MODULE__, decoded_read_by_group_type_rsp}}}
  end

  def decode(<<length::size(8), attribute_data_list::binary>>) do
    value_length = (length - 4) * 8

    decoded_attribute_data_list =
      for <<attribute_handle::little-size(16), end_group_handle::little-size(16),
            attribute_value::little-size(value_length) <- attribute_data_list>> do
        %{
          attribute_handle: attribute_handle,
          end_group_handle: end_group_handle,
          attribute_value: attribute_value
        }
      end

    parameters = %{
      length: length,
      attribute_data_list: decoded_attribute_data_list
    }

    {:ok, parameters}
  end

  def decode(encoded_read_by_group_type_rsp) do
    {:error, {:decode, {__MODULE__, encoded_read_by_group_type_rsp}}}
  end

  def opcode(), do: 0x11
end
