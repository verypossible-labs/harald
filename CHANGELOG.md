# v[VERSION]

## Breaking Changes

  - `ManufacturerDataBehaviour`
    - renamed to `Harald.DataType.ManufacturerDataBehaviour`
  - `Hci`
    - `t::command/0` updated
    - `opcode/2` no longer guards its parameters
    - `command/{1,2}`'s return is prefixed with the command packet indicator
      `<<1>>`
  - `ControllerAndBaseband`
    - `read_local_name/0`'s return is prefixed with a command packet indicator
  - `LeController`
    - `set_enable_scan/2`'s return is prefixed with a command packet indicator
    - `set_scan_parameters/1`'s return is prefixed with a command packet
      indicator
  - `Le`
    - `scan/{1,2}`'s return is now wrapped in an ok tuple
  - `Transport`
    - `t::command/0` removed
    - `send_command/2` renamed to `send_binary/2`
  - `TransportAdapter`
  - `UART` `send_command/2` renamed to `send_binary/2`
    - `send_binary/2` no longer prepends its `bin`s with `<<1>>`

## Bugfixes

  - `ManufacturerData`
    - `deserialize/1` asserts the company identifier to be 2 bytes

## Enhancements

  - documentation improvements
  - `Hci`
    - `t::event/0` added
  - `Le`
    - `scan/{1,2}` no longer crashes when the transport times out
  - `Packet`
    - `type/1` added to return the associated packet indicator
  - `Transport`
    - `start_link/1`
      - `:handle_start` option added, a callback once the transport starts. The
        callback shall return a list of binaries that will be sent to the
        Bluetooth Controller before anything else
      - fails explicitly when a namespace is not provided
    - `add_handler/2` added
    - `t::handler_msg/0` added
    - `t::handle_start/0` added
    - `t::handle_start_ret/0` added
    - `t::handlers/0` added
