defmodule Harald.Generators.DataType.ManufacturerData do
  @moduledoc """
  StreamData generators for manufacturer data.
  """

  use ExUnitProperties
  alias Harald.{DataType.ManufacturerData, Generators}
  require Harald.AssignedNumbers.GenericAccessProfile, as: GenericAccessProfile

  @spec binary :: no_return()
  def binary do
    gen all modules <- StreamData.constant(ManufacturerData.modules()),
            module <- StreamData.one_of(modules),
            bin <- Generators.generator_for(module).binary() do
      <<GenericAccessProfile.id("Manufacturer Specific Data"), bin::binary>>
    end
  end
end
