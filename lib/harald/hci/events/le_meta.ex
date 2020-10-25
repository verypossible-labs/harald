defmodule Harald.HCI.Events.LEMeta do
  alias Harald.HCI.Events.{Event, LEMeta.ConnectionComplete}

  @behaviour Event

  @callback encode(Event.t()) :: {:ok, binary()} | {:error, any()}
  @callback decode(binary()) :: {:ok, Event.t()} | {:error, any()}
  @callback sub_event_code() :: {:ok, Events.event_code()} | {:error, any()}

  @impl Event
  def encode(%{
        sub_event: %{code: code, module: sub_event_module},
        sub_event_parameters: sub_event_parameters
      }) do
    {:ok, encoded_sub_event} = sub_event_module.encode(sub_event_parameters)
    {:ok, <<code, encoded_sub_event::binary>>}
  end

  @impl Event
  def decode(<<sub_event_code, sub_event_parameters::binary>>) do
    {:ok, sub_event_module} = decode_sub_event_code(sub_event_code)
    {:ok, sub_event_parameters} = sub_event_module.decode(sub_event_parameters)

    decoded_le_meta = %{
      sub_event: %{code: sub_event_code, module: sub_event_module},
      sub_event_parameters: sub_event_parameters
    }

    {:ok, decoded_le_meta}
  end

  def decode_sub_event_code(0x01), do: {:ok, ConnectionComplete}

  def decode_sub_event_code(sub_event_code) do
    {:error, {:not_implemented, {__MODULE__, sub_event_code}}}
  end

  @impl Event
  def event_code(), do: 0x3E

  def new(sub_event_module, parameters) when is_atom(sub_event_module) and is_map(parameters) do
    event =
      struct(Event, %{
        code: event_code(),
        module: __MODULE__,
        parameters: %{
          sub_event: %{
            code: sub_event_module.sub_event_code(),
            module: sub_event_module
          },
          sub_event_parameters: parameters
        }
      })

    {:ok, event}
  end
end
