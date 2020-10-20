defmodule Harald.HCI.Commands do
  @moduledoc """
  Reference: version 5.1, vol 2, part E, 5.4.1.
  """

  alias Harald.HCI.Packet
  alias Harald.HCI.Commands
  alias Harald.HCI.Commands.{Command, ControllerAndBaseband, LEController}

  @type ogf() :: non_neg_integer()

  @type ocf() :: non_neg_integer()

  @type op_code() :: binary()

  @spec header(ogf(), ocf(), non_neg_integer()) :: {:ok, binary()} | {:error, any()}

  def decode(bin) when is_binary(bin) do
    indicator = Packet.indicator(:command)

    case bin do
      <<^indicator, op_code::binary-size(2), parameter_total_length,
        parameters::binary-size(parameter_total_length)>> ->
        {:ok, %{ocf: ocf, ogf: ogf}} = decode_op_code(op_code)
        {:ok, ogf_module} = ogf_to_module(ogf)
        {:ok, {ocf_module, parameters}} = ogf_module.decode(ocf, parameters)
        Commands.new(ogf_module, ocf_module, parameters)

      <<>> ->
        :error
    end
  end

  def encode(ogf_module, ocf_module, %{} = parameters \\ %{})
      when is_atom(ogf_module) and is_atom(ocf_module) do
    {:ok, parameters_bin} = ocf_module.encode(parameters)
    parameter_total_length = byte_size(parameters_bin)
    {:ok, header} = header(ogf_module.ogf(), ocf_module.ocf(), parameter_total_length)
    {:ok, <<header::binary(), parameters_bin::binary()>>}
  end

  def header(ogf, ocf, parameter_total_length)
      when is_integer(ogf) and is_integer(ocf) and is_integer(parameter_total_length) do
    indicator = Packet.indicator(:command)
    {:ok, op_code} = encode_op_code(ogf, ocf)
    {:ok, <<indicator, op_code::binary(), parameter_total_length>>}
  end

  def new(ogf_module, ocf_module, parameters)
      when is_atom(ogf_module) and is_atom(ocf_module) and is_map(parameters) do
    command =
      struct(Command, %{
        command_op_code: %{
          ocf: ocf_module.ocf(),
          ogf: ogf_module.ogf(),
          ocf_module: ocf_module,
          ogf_module: ogf_module
        },
        parameters: parameters
      })

    {:ok, command}
  end

  @spec encode_op_code(ogf(), ocf()) :: op_code()
  def encode_op_code(ogf, ocf) when is_integer(ogf) and is_integer(ocf) do
    <<op_code::size(16)>> = <<ogf::size(6), ocf::size(10)>>
    {:ok, <<op_code::little-size(16)>>}
  end

  def decode_op_code(<<op_code::little-size(16)>>) do
    <<ogf::size(6), ocf::size(10)>> = <<op_code::size(16)>>
    {:ok, %{ogf: ogf, ocf: ocf}}
  end

  def ogf_to_module(0x03), do: {:ok, ControllerAndBaseband}
  def ogf_to_module(0x08), do: {:ok, LEController}
  def ogf_to_module(_ogf), do: {:error, :not_implemented}
end
