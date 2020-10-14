defmodule Harald.HCI.Commands.Command do
  @type ogf() :: non_neg_integer()

  @type ocf() :: non_neg_integer()

  @enforce_keys [
    :ogf,
    :packet_indicator,
    :parameter_total_length,
    :parameters,
    :type
  ]
  defstruct [
    :ogf,
    {:packet_indicator, 1},
    :parameter_total_length,
    :parameters,
    :type
  ]

  @callback encode(Command.t()) :: {:ok, binary()} | {:error, any()}
  @callback decode(binary()) :: {:ok, Command.t()} | {:error, any()}
  @callback ocf() :: {:ok, Commands.ocf()} | {:error, any()}
end
