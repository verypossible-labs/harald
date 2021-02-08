defmodule Harald.HCI.Events.Event do
  @enforce_keys [
    :code,
    :module,
    :parameters
  ]
  defstruct [
    :code,
    :module,
    :parameters
  ]

  @callback encode(Event.t()) :: {:ok, binary()} | {:error, any()}
  @callback decode(binary()) :: {:ok, Event.t()} | {:error, any()}
  @callback event_code() :: {:ok, Events.event_code()} | {:error, any()}
end
