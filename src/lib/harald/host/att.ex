defmodule Harald.Host.ATT do
  @moduledoc """
  Reference: version 5.2, vol 3, part f.
  """

  alias Harald.Host.ATT.{
    ExchangeMTUReq,
    ExecuteWriteReq,
    ExecuteWriteRsp,
    FindInformationReq,
    FindInformationRsp,
    PrepareWriteReq,
    PrepareWriteRsp,
    ReadBlobReq,
    ReadBlobRsp,
    ReadByGroupTypeReq,
    ReadByGroupTypeRsp,
    ReadByTypeReq,
    ReadByTypeRsp,
    ReadReq,
    ReadRsp,
    WriteCmd,
    WriteReq,
    WriteRsp
  }

  @enforce_keys [
    :attribute,
    :parameters
  ]

  defstruct [
    :attribute,
    :parameters
  ]

  def decode(
        <<
          encoded_attribute_opcode,
          encoded_attribute_parameters::binary
        >> = encoded_bin
      ) do
    with {:ok, opcode_module} <- opcode_to_module(encoded_attribute_opcode),
         {:ok, decoded_attribute_parameters} <- opcode_module.decode(encoded_attribute_parameters) do
      decoded_att = %__MODULE__{
        attribute: %{opcode: encoded_attribute_opcode, module: opcode_module},
        parameters: decoded_attribute_parameters
      }

      {:ok, decoded_att}
    else
      {:error, {:not_implemented, error}} -> {:error, {:not_implemented, error, encoded_bin}}
    end
  end

  def encode(%__MODULE__{
        attribute: %{opcode: encoded_attribute_opcode, module: opcode_module},
        parameters: decoded_attribute_parameters
      }) do
    {:ok, encoded_attribute_parameters} = opcode_module.encode(decoded_attribute_parameters)

    encoded_att = <<
      encoded_attribute_opcode,
      encoded_attribute_parameters::binary
    >>

    {:ok, encoded_att}
  end

  @doc """
  Reference: version 5.2, vol 3, part a, 2.
  """
  def id(), do: 0x04

  def new(opcode_module, decoded_attribute_parameters) do
    encoded_attribute_opcode = opcode_module.opcode()

    acl_data = %__MODULE__{
      attribute: %{opcode: encoded_attribute_opcode, module: opcode_module},
      parameters: decoded_attribute_parameters
    }

    {:ok, acl_data}
  end

  def opcode_to_module(0x02), do: {:ok, ExchangeMTUReq}
  def opcode_to_module(0x03), do: {:ok, ExchangeMTURsp}
  def opcode_to_module(0x04), do: {:ok, FindInformationReq}
  def opcode_to_module(0x05), do: {:ok, FindInformationRsp}
  def opcode_to_module(0x08), do: {:ok, ReadByTypeReq}
  def opcode_to_module(0x09), do: {:ok, ReadByTypeRsp}
  def opcode_to_module(0x0A), do: {:ok, ReadReq}
  def opcode_to_module(0x0B), do: {:ok, ReadRsp}
  def opcode_to_module(0x0C), do: {:ok, ReadBlobReq}
  def opcode_to_module(0x0D), do: {:ok, ReadBlobRsp}
  def opcode_to_module(0x10), do: {:ok, ReadByGroupTypeReq}
  def opcode_to_module(0x11), do: {:ok, ReadByGroupTypeRsp}
  def opcode_to_module(0x12), do: {:ok, WriteReq}
  def opcode_to_module(0x13), do: {:ok, WriteRsp}
  def opcode_to_module(0x16), do: {:ok, PrepareWriteReq}
  def opcode_to_module(0x17), do: {:ok, PrepareWriteRsp}
  def opcode_to_module(0x18), do: {:ok, ExecuteWriteReq}
  def opcode_to_module(0x19), do: {:ok, ExecuteWriteRsp}
  def opcode_to_module(0x52), do: {:ok, WriteCmd}
  def opcode_to_module(opcode), do: {:error, {:not_implemented, {__MODULE__, opcode}}}
end
