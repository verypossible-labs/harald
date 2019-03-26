defmodule Harald.HCI.Event do
  @moduledoc """
  Serialization module for HCI Events.

  > The HCI Event Packet is used by the Controller to notify the Host when events occur.

  Reference: Version 5.0, Vol 2, Part E, 5.4.4
  """

  alias Harald.HCI.Event.{InquiryComplete, LEMeta}
  alias Harald.Serializable

  @behaviour Serializable

  @event_modules [InquiryComplete, LEMeta]

  @typedoc """
  > Each event is assigned a 1-Octet event code used to uniquely identify different types of
  > events.

  Reference: Version 5.0, Vol 2, Part E, 5.4.4
  """
  @type event_code :: pos_integer()

  @type t :: struct()

  @type serialize_ret :: {:ok, binary()} | LEMeta.serialize_ret()

  @type deserialize_ret ::
          {:ok, t() | [t()]}
          | {:error,
             {:bad_event_code
              | :unhandled_event_code, event_code()}}

  @doc """
  A list of modules representing implemented events.
  """
  def event_modules, do: @event_modules

  @doc """
  HCI packet indicator for HCI Event Packet.

  Reference: Version 5.0, Vol 5, Part A, 2
  """
  def indicator, do: 4

  @impl Serializable
  @spec serialize(term()) :: serialize_ret()
  def serialize(event)

  Enum.each(@event_modules, fn module ->
    def serialize(%unquote(module){} = event) do
      {:ok, bin} = unquote(module).serialize(event)
      {:ok, <<unquote(module).event_code(), byte_size(bin), bin::binary>>}
    end
  end)

  def serialize(event), do: {:error, {:bad_event, event}}

  @impl Serializable
  @spec deserialize(binary()) :: deserialize_ret()
  def deserialize(binary)

  Enum.each(@event_modules, fn module ->
    def deserialize(<<unquote(module.event_code()), length, event_parameters::binary>> = bin) do
      if length == byte_size(event_parameters) do
        unquote(module).deserialize(event_parameters)
      else
        {:error, bin}
      end
    end
  end)

  def deserialize(<<code, _::binary>> = binary) when code in 0x00..0xFF do
    {:error, {:unhandled_event_code, binary}}
  end

  def deserialize(binary), do: {:error, {:bad_event_code, binary}}
end
