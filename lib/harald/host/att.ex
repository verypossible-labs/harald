defmodule Harald.Host.ATT do
  @moduledoc """
  Reference: version 5.2, vol 3, part f.
  """

  @enforce_keys [
    :attribute,
    :parameters
  ]

  defstruct [
    :attribute,
    :parameters
  ]

  def decode(<<
        encoded_attribute_opcode,
        encoded_attribute_parameters::binary
      >>) do
    {:ok, decoded_attribute_opcode} = decode_attribute_opcode(encoded_attribute_opcode)

    {:ok, decoded_attribute_parameters} =
      decode_attribute(decoded_attribute_opcode, encoded_attribute_parameters)

    decoded_att = %__MODULE__{
      attribute: %{opcode: encoded_attribute_opcode, type: decoded_attribute_opcode},
      parameters: decoded_attribute_parameters
    }

    {:ok, decoded_att}
  end

  def decode_attribute(:att_exchange_mtu_rsp, <<decoded_client_rx_mtu::little-size(16)>>) do
    {:ok, %{client_rx_mtu: decoded_client_rx_mtu}}
  end

  def decode_attribute(attribute_opcode, encoded_attribute_parameters) do
    {:error, {:decode_attribute, {attribute_opcode, encoded_attribute_parameters}}}
  end

  def decode_attribute_opcode(0x02), do: {:ok, :att_exchange_mtu_rsp}

  def decode_attribute_opcode(attribute_opcode) do
    {:error, {:decode_attribute_opcode, attribute_opcode}}
  end

  def channel_id_to_module(0x04), do: {:ok, Att}
  def channel_id_to_module(channel_id), do: {:error, {:not_implemented, {__MODULE__, channel_id}}}

  def encode(%__MODULE__{
        attribute: %{opcode: encoded_attribute_opcode, type: _decoded_attribute_opcode},
        parameters: decoded_attribute_parameters
      }) do
    {:ok, encoded_attribute_parameters} =
      encode_attribute(encoded_attribute_opcode, decoded_attribute_parameters)

    encoded_att = <<
      encoded_attribute_opcode,
      encoded_attribute_parameters::binary
    >>

    {:ok, encoded_att}
  end

  def encode_attribute(0x02, %{client_rx_mtu: decoded_client_rx_mtu}) do
    {:ok, <<decoded_client_rx_mtu::little-size(16)>>}
  end

  def encode_attribute(attribute_opcode, decoded_attribute_parameters) do
    {:error, {:encode_attribute, {attribute_opcode, decoded_attribute_parameters}}}
  end

  def encode_attribute_opcode(:att_exchange_mtu_rsp), do: {:ok, 0x02}

  def encode_attribute_opcode(decoded_attribute_opcode) do
    {:error, {:decode_attribute_opcode, decoded_attribute_opcode}}
  end

  @doc """
  Reference: version 5.2, vol 3, part a, 2.
  """
  def id(), do: 0x04

  def new(decoded_attribute_opcode, decoded_attribute_parameters) do
    {:ok, encoded_attribute_opcode} = encode_attribute_opcode(decoded_attribute_opcode)

    acl_data = %__MODULE__{
      attribute: %{opcode: encoded_attribute_opcode, type: decoded_attribute_opcode},
      parameters: decoded_attribute_parameters
    }

    {:ok, acl_data}
  end
end
