defmodule Harald.DataType.ManufacturerDataBehaviour do
  @moduledoc """
  Defines a behaviour that manufacturer data modules should implement.
  """

  @doc """
  Returns the company associated with some manufacturer data.

  See: `Harald.CompanyIdentifiers`
  """
  @callback company :: String.t()
end
