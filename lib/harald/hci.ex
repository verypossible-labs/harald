defmodule Harald.HCI do
  @moduledoc """
  A module for working directly with the Bluetooth HCI.
  """

  @type ogf :: 0..63
  @type ocf :: 0..1023
  @type opcode :: binary
  @type opt :: boolean | binary
  @type opts :: binary | [opt]
  @type command :: <<_::8, _::_*8>>

  @spec opcode(ogf, ocf) :: opcode
  def opcode(ogf, ocf) when ogf < 64 and ocf < 1024 do
    <<opcode::size(16)>> = <<ogf::size(6), ocf::size(10)>>
    <<opcode::size(16)-little>>
  end

  @spec command(opcode, opts) :: command
  def command(opcode, opts \\ "")

  def command(opcode, [_ | _] = opts) do
    opts_bin = for o <- opts, into: "", do: to_bin(o)

    command(opcode, opts_bin)
  end

  def command(opcode, opts) do
    s = byte_size(opts)
    opcode <> <<s::size(8)>> <> opts
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
  @spec to_bin(boolean | binary) :: binary
  def to_bin(false), do: <<0>>
  def to_bin(true), do: <<1>>
  def to_bin(bin) when is_binary(bin), do: bin
end
