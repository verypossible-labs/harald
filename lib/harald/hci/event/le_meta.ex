defmodule Harald.HCI.Event.LEMeta do
  @moduledoc """
  > The LE Meta Event is used to encapsulate all LE Controller specific events.

  Reference: Version 5.0, Vol 2, Part E, 7.7.65
  """

  alias Harald.{HCI.Event.LEMeta.AdvertisingReport, Serializable}

  @behaviour Serializable

  @type t :: %__MODULE__{}

  @typedoc """
  > An LE Controller uses subevent codes to transmit LE specific events from the Controller to the
  > Host. Note: The subevent code will always be the first Event Parameter (See Section 7.7.65).

  Reference: Version 5.0, Vol 2, Part E, 5.4.4
  """
  @type subevent_code :: pos_integer()

  @type serialize_ret :: {:ok, binary()} | {:error, term()}

  defstruct [:subevent]

  @event_code 0x3E

  @subevent_modules [
    AdvertisingReport
  ]

  @doc """
  See: `t:Harald.HCI.Event.event_code/0`.
  """
  def event_code, do: @event_code

  @doc """
  A list of modules representing implemented LEMeta subevents.
  """
  def subevent_modules, do: @subevent_modules

  @impl Serializable
  def serialize(event)

  Enum.each(@subevent_modules, fn subevent_module ->
    def serialize(%__MODULE__{subevent: %unquote(subevent_module){} = subevent}) do
      unquote(subevent_module).serialize(subevent)
    end
  end)

  def serialize(%__MODULE__{} = ret), do: {:error, ret}

  @impl Serializable
  def deserialize(binary)

  for module <- @subevent_modules do
    {module, subevent_code} =
      case module do
        {module, _} -> {module, module.subevent_code()}
        module -> {module, module.subevent_code()}
      end

    # def deserialize(<<unquote(subevent_code), subevent_packet::binary>>) do
    # Add test that executes this code and fails with above head
    def deserialize(<<unquote(subevent_code), _::binary>> = subevent_packet) do
      {ok_or_error, subevent} = unquote(module).deserialize(subevent_packet)
      {ok_or_error, %__MODULE__{subevent: subevent}}
    end
  end

  def deserialize(bin), do: {:error, bin}
end
