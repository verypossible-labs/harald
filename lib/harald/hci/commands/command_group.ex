defmodule Harald.HCI.Commands.CommandGroup do
  alias Harald.HCI.Commands

  @callback decode(Commands.ocf(), binary()) :: {:ok, Command.t()} | :error
  @callback ogf() :: Commands.ogf()
  @callback ocf_to_module(Commands.ocf()) ::
              {:ok, Commands.ocf_module()} | {:error, :not_implemented}
end
