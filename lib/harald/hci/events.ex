defmodule Harald.HCI.Events do
  @moduledoc """
  Reference: version 5.0, vol 2, part E, 5.4.4.
  """

  alias Harald.HCI.Events
  alias Harald.HCI.Events.Event
  alias Harald.HCI.Events.{CommandComplete, LEMeta}
  @type event_code() :: non_neg_integer()

  def encode(%Event{
        code: _event_code,
        module: event_module,
        parameters: parameters
      }) do
    event_module.encode(parameters)
  end

  def decode(bin) when is_binary(bin) do
    case bin do
      <<event_code, _length, data::binary()>> ->
        {:ok, event_module} = event_code_to_module(event_code)
        {:ok, parameters} = event_module.decode(data)
        Events.new(event_module, parameters)

      <<>> ->
        :error
    end
  end

  def event_code_to_module(0x0E), do: {:ok, CommandComplete}
  def event_code_to_module(0x3E), do: {:ok, LEMeta}
  def event_code_to_module(_event_code), do: {:error, :not_implemented}

  def new(event_module, parameters)
      when is_atom(event_module) and (is_binary(parameters) or is_map(parameters)) do
    event =
      struct(Event, %{
        code: event_module.event_code(),
        module: event_module,
        parameters: parameters
      })

    {:ok, event}
  end
end
