defmodule Harald.DataType do
  @moduledoc """
  Reference: Core Specification Supplement, Part A
  """

  alias Harald.DataType.{ManufacturerData, ServiceData}

  @doc """
  Returns a list of data type implementation modules.
  """
  def modules do
    [
      ManufacturerData,
      ServiceData
    ]
  end
end
