defmodule Harald.HCI.Events do
  @moduledoc """
  Reference: version 5.0, vol 2, part E, 5.4.4.
  """

  alias Harald.HCI.Events
  alias Harald.HCI.{Events.Event, Events.CommandComplete}

  @type event_code() :: non_neg_integer()

  def decode(bin) when is_binary(bin) do
    case bin do
      <<event_code, _length, data::binary()>> ->
        {:ok, event_code_module} = event_code_to_module(event_code)
        {:ok, parameters} = event_code_module.decode(data)
        Events.new(event_code_module, parameters)

      <<>> ->
        :error
    end
  end

  def event_code_to_module(0xE), do: {:ok, CommandComplete}
  def event_code_to_module(_event_code), do: {:error, :not_implemented}

  def new(event_code_module, parameters)
      when is_atom(event_code_module) and (is_binary(parameters) or is_map(parameters)) do
    event =
      struct(Event, %{
        event_code: event_code_module,
        parameters: parameters
      })

    {:ok, event}
  end

  # alias Harald.HCI.Event.{InquiryComplete, LEMeta}
  # alias Harald.Serializable

  # @behaviour Serializable

  # @event_modules [InquiryComplete, LEMeta]

  # @typedoc """
  # > Each event is assigned a 1-Octet event code used to uniquely identify different types of
  # > events.

  # Reference: Version 5.0, Vol 2, Part E, 5.4.4
  # """
  # @type event_code :: pos_integer()

  # @type t :: struct()

  # @type serialize_ret :: {:ok, binary()} | LEMeta.serialize_ret()

  # @type deserialize_ret :: {:ok, t() | [t()]} | {:error, binary()}

  # @doc """
  # A list of modules representing implemented events.
  # """
  # def event_modules, do: @event_modules

  # @doc """
  # HCI packet indicator for HCI Event Packet.

  # Reference: Version 5.0, Vol 5, Part A, 2
  # """
  # def indicator, do: 4

  # @impl Serializable
  # def serialize(event)

  # Enum.each(@event_modules, fn module ->
  #   def serialize(%unquote(module){} = event) do
  #     {:ok, bin} = unquote(module).serialize(event)
  #     {:ok, <<unquote(module).event_code(), byte_size(bin), bin::binary>>}
  #   end
  # end)

  # def serialize(event), do: {:error, {:bad_event, event}}

  # @impl Serializable
  # def deserialize(binary)

  # Enum.each(@event_modules, fn module ->
  #   def deserialize(<<unquote(module.event_code()), length, event_parameters::binary>> = bin) do
  #     if length == byte_size(event_parameters) do
  #       unquote(module).deserialize(event_parameters)
  #     else
  #       {:error, bin}
  #     end
  #   end
  # end)

  # def deserialize(bin) when is_binary(bin), do: {:error, bin}
end
