defmodule Harald.HCI.Event.InquiryComplete do
  @moduledoc """
  > The Inquiry Complete event indicates that the Inquiry is finished. This event contains a
  > Status parameter, which is used to indicate if the Inquiry completed successfully or if the
  > Inquiry was not completed.
  Reference: Version 5.0, Vol 2, Part E, 7.7.1
  """

  alias Harald.{ErrorCode, Serializable}

  @behaviour Serializable

  @type t :: %__MODULE__{}

  defstruct [:status]

  @event_code 0x01

  def event_code, do: @event_code

  @impl Serializable
  def serialize(%__MODULE__{status: status}), do: {:ok, <<ErrorCode.error_code(status)>>}

  @impl Serializable
  def deserialize(<<status>>), do: {:ok, %__MODULE__{status: ErrorCode.name(status)}}

  def deserialize(bin), do: {:error, bin}
end
