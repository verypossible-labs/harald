# Frequently Asked Questions

## Can I do X with Harald

A BLE scan is the only high level function implemented so far. Though sending
and receiving all Bluetooth Commands and Events is within the scope of Harald,
the spec is vast and it will take some time to implement. As such, it will be
common to find oneself in a position where you want to do something that isn't
implemented yet.

## Harald has not implemented X yet, how do I do X

At the end of the day Bluetooth boils down to sending commands and receiving
events. Those are defined within the
[Bluetooth Core Specification](https://www.bluetooth.com/specifications/bluetooth-core-specification).
Find out what commands and events you require, then leverage the plumbing of
Harald to send and receive binaries you are responsible for creating and
parsing. Ideally a PR is then opened!

## What if I get stuck

Create an issue or head over to `#nervesbluetooth` in the Elixir Slack
workspace. Researching what you are trying to do deeper than "send data" or
"connect to something", along with putting together a list of required commands
and events, and then asking for help, will go a long way towards creating a
situation maintainers can be productive with.
