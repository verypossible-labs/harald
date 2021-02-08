defmodule Harald.HaraldCase do
  @moduledoc """
  Harald test helpers.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Harald.HaraldCase
    end
  end

  defmacro assert_binaries({:==, _, [left, right]}) do
    quote do
      format = fn bin ->
        space = ?\s

        ", " <> elements =
          bin
          |> :binary.bin_to_list()
          |> Enum.reduce("", fn element, acc -> acc <> ", #{inspect(element)}" end)

        "<<#{elements}>>"
      end

      left = format.(unquote(left))
      right = format.(unquote(right))
      assert left == right
    end
  end
end
