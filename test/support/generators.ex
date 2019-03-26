defmodule Harald.Generators do
  @moduledoc """
  StreamData generators.
  """

  use ExUnitProperties

  def generator_for(module) do
    [head | tail] = Module.split(module)
    Module.concat([head, "Generators" | tail])
  end
end
