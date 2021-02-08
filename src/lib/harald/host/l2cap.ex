defmodule Harald.Host.L2CAP do
  @moduledoc """
  Reference: version 5.2, vol 3, part a.
  """

  alias Harald.Host.ATT

  @enforce_keys [
    :length,
    :channel,
    :information_payload
  ]

  defstruct [
    :length,
    :channel,
    :information_payload
  ]

  def channel_id_to_module(0x04), do: {:ok, ATT}
  def channel_id_to_module(channel_id), do: {:error, {:not_implemented, {__MODULE__, channel_id}}}

  def decode(
        <<
          length::little-size(16),
          channel_id::little-size(16),
          encoded_information_payload::binary-size(length)
        >> = encoded_bin
      ) do
    with {:ok, channel_module} <- channel_id_to_module(channel_id),
         {:ok, decoded_information_payload} <- channel_module.decode(encoded_information_payload) do
      decoded_l2cap = %__MODULE__{
        length: length,
        channel: %{id: channel_id, module: channel_module},
        information_payload: decoded_information_payload
      }

      {:ok, decoded_l2cap}
    else
      {:error, {:not_implemented, error, _bin}} ->
        {:error, {:not_implemented, error, encoded_bin}}
    end
  end

  def encode(%__MODULE__{
        length: length,
        channel: %{id: channel_id, module: channel_module},
        information_payload: decoded_information_payload
      }) do
    {:ok, encoded_information_payload} = channel_module.encode(decoded_information_payload)

    length =
      case length do
        nil -> byte_size(encoded_information_payload)
        length -> length
      end

    encoded_l2cap = <<
      length::little-size(16),
      channel_id::little-size(16),
      encoded_information_payload::binary-size(length)
    >>

    {:ok, encoded_l2cap}
  end

  def new(channel_module, decoded_information_payload) do
    decoded_l2cap = %__MODULE__{
      length: nil,
      channel: %{id: channel_module.id, module: channel_module},
      information_payload: decoded_information_payload
    }

    {:ok, encoded_information_payload} = channel_module.encode(decoded_information_payload)
    length = byte_size(encoded_information_payload)
    {:ok, Map.put(decoded_l2cap, :length, length)}
  end
end
