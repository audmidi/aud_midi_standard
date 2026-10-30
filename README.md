# aud_midi_standard

English | [Deutsch](README.de.md)

MIDI 1.0 and 2.0 (UMP) standards as dependency-free Dart: constants, models,
parsers, codecs. It also holds the translation between MIDI 1.0 and MIDI 2.0
and the descriptive models of the aud_midi family.

Part of the aud_midi family, see [aud_midi](https://github.com/audmidi/aud_midi).

## Motivation

The MIDI standards should be usable as a plain Dart package by any project —
an audio engine, a sequencer, a test tool or a converter — without native
code, without an isolate and without the runtime of the aud_midi family. At
the same time the message model has to cover the whole UMP standard, so that
no MIDI 2.0 feature ever forces an API break. The package aims for:

- Zero dependencies, runs on the Dart VM, Web and Wasm
- One typed, sealed message hierarchy for MIDI 1.0 and MIDI 2.0
- Two independent raw forms: MIDI 1.0 bytes and Universal MIDI Packets
- Complete UMP codec, MIDI 1.0 ↔ 2.0 translation per M2-104-UM
- Device, port, capability and event models shared by all backends
- Absorbs `gg_midi_vars`

## Installation

```bash
dart pub add aud_midi_standard
```

## Usage

Parse a MIDI 1.0 byte stream, translate a message to MIDI 2.0, encode it as
UMP and decode it again:

```dart
import 'package:aud_midi_standard/aud_midi_standard.dart';

void main() {
  // Parse a MIDI 1.0 byte stream with running status
  final parser = MidiByteParser();
  for (final (:message, :time) in parser.add([0x90, 60, 100, 64, 90])) {
    print('$time $message');
  }

  // Translate to the MIDI 2.0 protocol and encode as UMP on group 1
  const noteOn = MidiNoteOn(channel: 0, note: 60, velocity: 100);
  final noteOn2 = noteOn.toMidi2().single;
  print(noteOn2);
  print(noteOn2.toUmp(group: 1));

  // Decode the packets again and translate back to MIDI 1.0 bytes
  final words = noteOn2.toUmp(group: 1).expand((ump) => ump.words).toList();
  final decoded = UmpDecoder().add(words).single;
  print(
    'group ${decoded.group}: ${decoded.message.toMidi1().single.toBytes()}',
  );

  // Use the constants migrated from gg_midi_vars
  print(MidiNoteNumbers.c4);
  print(MidiControllers.toStr(MidiControllers.allNotesOff));
}
```

It prints:

```text
0 MidiNoteOn(channel: 0, note: 60, velocity: 100)
0 MidiNoteOn(channel: 0, note: 64, velocity: 90)
MidiNoteOn2(channel: 0, note: 60, velocity: 51492, attributeType: 0, attribute: 0)
[Ump(41903c00 c9240000)]
group 1: MidiBytes(90 3c 64)
60
allNotesOff
```

## Limitations

The package covers the standards only: it opens no port, talks to no
operating system and schedules nothing. Ports, devices and timing come from
the backends and the runtime of the aud_midi family.

## Documentation

- [Plan of the aud_midi family](https://github.com/audmidi/aud_midi_pm/blob/main/doc/2026-Q4/tickets/2026-10-06-aud_midi_01-initial-midi-implementation.md)
- [Decisions](https://github.com/audmidi/aud_midi_pm/blob/main/doc/2026-Q4/concepts/decisions/000-index.md),
  e.g. the translation rules
- [Guides](doc/guides/)

## Status

Before 1.0 — the API may change between minor versions. The package
covers:

- Messages: MIDI 1.0 channel voice, system common and real-time, SysEx;
  MIDI 2.0 channel voice incl. per-note controllers and management;
  utility, SysEx8, Mixed Data Set, flex data and UMP stream messages
- Codecs: byte parser (running status, SysEx reassembly with limits,
  real-time interleaving) and encoder; UMP encoder and decoder for
  message types 0x0–0xF with reassembly; default translation of
  M2-104-UM Appendix D with value scaling; BLE-MIDI packet codec
- Constants: status bytes, controllers and note numbers (gg_midi_vars
  names kept), RPNs, General MIDI 1 and 2, manufacturer ids, universal
  SysEx, MIDI time code, UMP status values, flex data, chords
- Models: ports, devices, capabilities, virtual ports, BLE peripherals,
  network hosts and sessions, events, packets, diagnostics, keys
  (`MidiKey`: channel and note), notes (`MidiNote`: channel, note and
  velocity), voices (`ChannelVelocity`: channel and velocity) — immutable,
  with JSON and `copyWith`
- Callbacks: `MidiIssueCallback` for parser issues, `MidiMessageCallback`
  for receivers of message lists
- 100 % test coverage; specification references in every doc comment

## Contributing

See [doc/guides/develop-guide.md](doc/guides/develop-guide.md).

## License

MIT — see [LICENSE](LICENSE).
