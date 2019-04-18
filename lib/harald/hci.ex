defmodule Harald.HCI do
  @moduledoc """
  > The HCI provides a uniform interface method of accessing a Bluetooth Controller’s
  > capabilities.

  Reference: Version 5.0, Vol. 2, Part E, 1
  """

  alias Harald.{HCI.Event, Serializable}

  @behaviour Serializable

  @typedoc """
  OpCode Group Field.

  See `t:opcode/0`
  """
  @type ogf :: 0..63

  @typedoc """
  OpCode Command Field.

  See `t:opcode/0`
  """
  @type ocf :: 0..1023

  @typedoc """
  > Each command is assigned a 2 byte Opcode used to uniquely identify different types of
  > commands. The Opcode parameter is divided into two fields, called the OpCode Group Field (OGF)
  > and OpCode Command Field (OCF). The OGF occupies the upper 6 bits of the Opcode, while the OCF
  > occupies the remaining 10 bits. The OGF of 0x3F is reserved for vendor-specific debug
  > commands. The organization of the opcodes allows additional information to be inferred without
  > fully decoding the entire Opcode.

  Reference: Version 5.0, Vol. 2, Part E, 5.4.1
  """
  @type opcode :: binary()

  @type opt :: boolean() | binary()

  @type opts :: binary() | [opt()]

  @spec opcode(ogf(), ocf()) :: opcode()
  def opcode(ogf, ocf) do
    <<opcode::size(16)>> = <<ogf::size(6), ocf::size(10)>>
    <<opcode::little-size(16)>>
  end

  @spec command(opcode(), opts()) :: binary()
  def command(opcode, opts \\ <<>>)

  def command(opcode, [_ | _] = opts) do
    opts_bin = for o <- opts, into: <<>>, do: to_bin(o)
    command(opcode, opts_bin)
  end

  def command(opcode, opts) do
    size = byte_size(opts)
    <<1, opcode::binary, size, opts::binary>>
  end

  @doc """
  Convert a value to a binary.

      iex> to_bin(false)
      <<0>>

      iex> to_bin(true)
      <<1>>

      iex> to_bin(<<1, 2, 3>>)
      <<1, 2, 3>>
  """
  @spec to_bin(boolean() | binary()) :: binary()
  def to_bin(false), do: <<0>>

  def to_bin(true), do: <<1>>

  def to_bin(bin) when is_binary(bin), do: bin

  @impl Serializable
  for module <- Event.event_modules() do
    def serialize(%unquote(module){} = event) do
      {:ok, bin} = Event.serialize(event)
      {:ok, <<Event.indicator(), bin::binary>>}
    end
  end

  @impl Serializable
  def deserialize(<<4, rest::binary>>) do
    case Event.deserialize(rest) do
      {:ok, _} = ret -> ret
      {:error, bin} when is_binary(bin) -> {:error, <<4, bin::binary>>}
      {:error, data} -> {:error, data}
    end
  end

  def deserialize(bin), do: {:error, bin}
end
