defmodule Harald.HCI do
  @moduledoc """
  Reference: version 5.1, vol 2, part E, 1.
  """

  @type bit_range() :: Range.t()

  @type flag() :: boolean()

  @type reserved() :: non_neg_integer()

  @type reserved_map() :: %{bit_range() => reserved()}
end
