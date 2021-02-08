defmodule Harald.DataType.ManufacturerData do
  @moduledoc """
  > The Manufacturer Specific data type is used for manufacturer specific data.

  Reference: Core Specification Supplement, Part A, section 1.4.1

  Modules under the `Harald.ManufacturerData` scope should implement the
  `Harald.ManufacturerDataBehaviour` and `Harald.Serializable` behaviours.
  """

  alias Harald.DataType.ManufacturerData.Apple
  require Harald.AssignedNumbers.CompanyIdentifiers, as: CompanyIdentifiers

  @modules [Apple]

  @doc """
  Returns a list of implementation modules.
  """
  def modules, do: @modules

  @doc """
  Serializes manufacturer data.
  """
  def serialize(data)

  Enum.each(@modules, fn
    module ->
      def serialize({unquote(module.company()), data}) do
        data
        |> unquote(module).serialize()
        |> case do
          {:ok, bin} ->
            {:ok, <<unquote(CompanyIdentifiers.id(module.company())), bin::binary>>}

          :error ->
            error = %{
              remaining: data,
              serialized: <<unquote(CompanyIdentifiers.id(module.company()))>>
            }

            {:error, error}
        end
      end
  end)

  def serialize({:error, _} = ret), do: ret

  def serialize(ret), do: {:error, ret}

  @doc """
  Deserializes a manufacturer data binary.

      iex> deserialize(<<76, 0, 2, 21, 172, 185, 137, 206, 253, 163, 76, 179, 137, 41, 101, 34, 252, 127, 2, 42, 181, 255, 224, 255, 225>>)
      {:ok, {"Apple, Inc.", {"iBeacon", %{major: 46591, minor: 57599, tx_power: 225, uuid: 229590585283448776073135497520678371882}}}}
  """
  def deserialize(binary)

  Enum.each(@modules, fn
    module ->
      def deserialize(
            <<unquote(CompanyIdentifiers.id(module.company()))::little-size(16), sub_bin::binary>> =
              bin
          ) do
        case unquote(module).deserialize(sub_bin) do
          {:ok, data} -> {:ok, {unquote(module).company, data}}
          {:error, _} -> {:error, bin}
        end
      end
  end)

  def deserialize(bin), do: {:error, bin}
end
