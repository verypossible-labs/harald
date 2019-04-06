defmodule Harald.Serializable do
  @moduledoc """
  Serializable behaviour.
  """

  @callback serialize(term()) :: {:ok, binary()} | {:error, term()}

  @callback deserialize(binary()) :: {:ok, term()} | {:error, term()}
end
