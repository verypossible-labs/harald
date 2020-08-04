defmodule Harald.Generators.HCI.Event.InquiryComplete do
  @moduledoc """
  StreamData generators for Inquiry Complete event.

  Reference: Version 5.0, Vol 2, Part E, 7.7.1
  """

  use ExUnitProperties
  alias Harald.ErrorCode

  @spec parameters :: no_return()
  def parameters do
    gen all({status, _} <- StreamData.member_of(ErrorCode.all())) do
      <<status>>
    end
  end
end
