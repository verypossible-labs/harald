defmodule Harald.HCI.Events.LEMeta do
  @moduledoc """
  Reference: version 5.1, vol 2, part E, 7.7.65.
  """

  # for module <- @subevent_modules do
  #   {module, subevent_code} =
  #     case module do
  #       {module, _} -> {module, module.subevent_code()}
  #       module -> {module, module.subevent_code()}
  #     end

  #   # def deserialize(<<unquote(subevent_code), subevent_packet::binary>>) do
  #   # Add test that executes this code and fails with above head
  #   def deserialize(<<unquote(subevent_code), _::binary>> = subevent_packet) do
  #     {ok_or_error, subevent} = unquote(module).deserialize(subevent_packet)
  #     {ok_or_error, %__MODULE__{subevent: subevent}}
  #   end
  # end
end
