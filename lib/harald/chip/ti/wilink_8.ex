defmodule Harald.Chip.TI.WiLink8 do
  @moduledoc """
  Setup functionality for the TI WiLink 8.
  """

  alias Harald.Chip.TI.BTS
  require Logger

  def setup(_namespace, args) do
    bts_path = Keyword.fetch!(args, :bts_path)
    gpio_bt_en = Keyword.fetch!(args, :gpio_bt_en)
    {:ok, pin_ref} = Circuits.GPIO.open(gpio_bt_en, :output)
    Circuits.GPIO.write(pin_ref, 0)
    Process.sleep(5)
    Circuits.GPIO.write(pin_ref, 1)
    Process.sleep(200)

    hci_commands =
      bts_path
      |> BTS.parse()
      |> Enum.filter(fn <<1, opcode::size(16), _::binary>> ->
        <<x::little-size(16)>> = <<opcode::size(16)>>

        case x do
          65334 -> false
          64780 -> false
          _ -> true
        end
      end)

    {:ok, hci_commands}
  end
end
