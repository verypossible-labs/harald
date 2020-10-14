defmodule Harald.HCI.Events.Event do
  @enforce_keys [
    :event_code,
    :parameters
  ]
  defstruct [
    :event_code,
    :parameters
  ]

  @callback encode(Event.t()) :: {:ok, binary()} | {:error, any()}
  @callback decode(binary()) :: {:ok, Event.t()} | {:error, any()}
  @callback event_code() :: {:ok, Events.event_code()} | {:error, any()}
end
