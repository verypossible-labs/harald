defmodule Harald.HCI.Event do
  @moduledoc """
  Parent module for HCI events.
  """

  alias __MODULE__

  defmodule Unparsed do
    @moduledoc """
    Represents an event that does not have a parser.
    """

    @enforce_keys [:event_code, :event]
    defstruct @enforce_keys
  end

  @type unparsed_event :: binary
  @type event_code :: integer
  @type event :: %Unparsed{} | Event.LEMeta.parsed()

  @le_meta_event 0x3E

  for {function, value} <- [
        le_meta_event: @le_meta_event
      ] do
    def unquote(function)(), do: unquote(value)
  end

  @spec parse({event_code, unparsed_event}) :: event
  def parse({@le_meta_event, event}), do: Event.LEMeta.parse(event)

  def parse({event_code, event}) when is_integer(event_code) and is_binary(event) do
    %Unparsed{event_code: event_code, event: event}
  end
end
