defmodule Harald.Generators.DataType.ServiceData do
  @moduledoc """
  StreamData generators for service data.
  """

  import ExUnitProperties, only: :macros
  alias Harald.DataType.ServiceData
  require Harald.AssignedNumbers.GenericAccessProfile, as: GenericAccessProfile

  @description_32 "Service Data - 32-bit UUID"

  def binary do
    gen all gap_description <- StreamData.member_of(ServiceData.gap_descriptions()),
            bin <- binary(gap_description) do
      bin
    end
  end

  def binary(@description_32) do
    gen all uuid <- StreamData.binary(length: 4),
            data <- StreamData.binary(length: 1) do
      <<GenericAccessProfile.id(unquote(@description_32)), uuid::binary-size(4), data::binary>>
    end
  end
end
