defmodule Harald.HCI.Commands.Command do
  @type ogf() :: non_neg_integer()

  @type ocf() :: non_neg_integer()

  @enforce_keys [
    :command_op_code,
    :parameters
  ]

  defstruct [
    :command_op_code,
    :parameters
  ]

  @callback encode(Command.t()) :: {:ok, binary()} | {:error, any()}
  @callback decode(binary()) :: {:ok, Command.t()} | {:error, any()}
  @callback decode_return_parameters(binary()) :: {:ok, map()} | {:error, any()}
  @callback encode_return_parameters(map()) :: {:ok, binary()} | {:error, any()}
  @callback ocf() :: {:ok, Commands.ocf()} | {:error, any()}
end
