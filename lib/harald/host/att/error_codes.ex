defmodule Harald.Host.ATT.ErrorCodes do
  @moduledoc """
  First 19 errors:
  Reference: version 5.2, Vol 3, Section 3.4.1.1
  Errors 0xFC - 0xFF:
  Reference: Core Specification Supplement Version 9, Part B
  """
  @error_codes %{
    0x01 => "Invalid Handle",
    0x02 => "Read Not Permitted",
    0x03 => "Write Not Permitted",
    0x04 => "Invalid PDU",
    0x05 => "Insufficient Authentication",
    0x06 => "Request Not Supported",
    0x07 => "Invalid Offset",
    0x08 => "Insufficient Authorization",
    0x09 => "Prepare Queue Full",
    0x0A => "Attribute Not Found",
    0x0B => "Attribute Not Long",
    0x0C => "Insufficient Encryption Key Size",
    0x0D => "Invalid Attribute Value Length",
    0x0E => "Unlikely Error",
    0x0F => "Insufficient Encryption",
    0x10 => "Unsupported Group Type",
    0x11 => "Insufficient Resources",
    0x12 => "Database Out Of Sync",
    0x13 => "Value Not Allowed",
    0xFC => "Write Request Rejected",
    0xFD => "Client Characteristic Configuration Descriptor Improperly Configured",
    0xFE => "Procedure Already in Progress",
    0xFF => "Out of Range"
  }

  Enum.each(@error_codes, fn
    {error_code, _name}
    when error_code in 0x80..0x9F ->
      def decode(unquote(error_code)), do: {:ok, unquote("Application Error")}

    {error_code, name} ->
      def decode(unquote(error_code)), do: {:ok, unquote(name)}
      def encode(unquote(name)), do: {:ok, unquote(error_code)}
  end)

  def decode(encoded_error_code) do
    {:error, {:decode, {__MODULE__, encoded_error_code}}}
  end

  def encode(decoded_error_code) do
    {:error, {:encode, {__MODULE__, decoded_error_code}}}
  end
end
