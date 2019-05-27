# 0.2.0

## Breaking Changes

- [ManufacturerData] `deserialize/1` returns `{:error, bin}` instead of
  `{:error, {:unhandled_company_id, bin}}`
- [Event] `deserialize/1` returns `{:error, bin}` instead of
  `{:error, {:bad_event_code, bin}}`
- [Apple] when attempting to deserialize a non-binary term, crash
- [AdvertisingReport] `deserialize/1` always returns
  `{status, %AdvertisingReport{}}`
- [Device]
  - when attempting to deserialize a non-binary term, crash
  - faults nested within a device discovered during deserialization will no
    longer be realized through tuples like `{:early_termination, 0}`, instead
    the violating binary will be returned as-is

## Enhancements

- [Apple] `deserialize/1` returns `{:error, bin}` instead of crashing on invalid
  input
- [ArrayedData] `deserialize/1` returns `{:error, bin}` instead of crashing on
  invalid input
- [Transport]
  - `LE` is always included as a handler WRT `Transport`
  - errors during deserialization no longer prevent a Bluetooth event from being
    dispatched to handlers
