defmodule Harald.Serializable do
  @moduledoc """
  Serializable behaviour.
  """

  @callback serialize(term()) :: {:ok, binary()} | {:error, term()}

  @callback deserialize(binary()) :: {:ok, term()} | {:error, term()}

  @doc """
  Asserts that `bin` will serialize symmetrically.

  If `bin` deserializes into `{:ok, data}`, `data` should serialize perfectly back into `bin`.
  """
  defmacro assert_symmetry(mod, bin) do
    quote bind_quoted: [bin: bin, mod: mod] do
      import ExUnit.Assertions, only: [assert: 1, assert: 2]

      case mod.deserialize(bin) do
        {:ok, data} ->
          assert {:ok, bin2} = mod.serialize(data)
          assert :binary.bin_to_list(bin) == :binary.bin_to_list(bin2)

        {:error, data} when not is_binary(data) ->
          true

        {:error, bin2} ->
          assert :binary.bin_to_list(bin) == :binary.bin_to_list(bin2)
      end
    end
  end
end
