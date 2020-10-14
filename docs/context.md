# Context

## Bluetooth

The Bluetooth specification defines a host controller interface (HCI) to allow:

- lower level radio and physical/link operations to be handled by a Bluetooth module referred to
  as the "controller". For example, this may be a WL1835MOD (Beagle Bone Black Wireless), BCM43438
  (Raspberry Pi 3 Model B+), or many other chips.
- higher level profile, logical link, and connection/pairing operations to be handled by what is
  referred to as the "host". For example, this may be Bluez, Bluedroid, Bluekitchen, etc.

## Elixir

Harald plays a portion of the Bluetooth HCI host role:

- Decode/encode binary HCI packets/Elixir maps.
- Send HCI packets over UART.
- Receive HCI packets over UART and fan them out to all subscribed pids.
