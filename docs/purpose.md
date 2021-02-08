# Purpose

Harald provides the foundation for building Bluetooth libraries and applications in Elixir by
defining Elixir data structures and functions to decode and encode to and from binary HCI packets.

Harald does not provide any stateful or process based functionality. The expectation is that
higher level libraries will leverage Harald to provide higher level interfaces that can be made
stateful and leveraged more efficiently by applications.
