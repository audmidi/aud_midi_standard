<!--
@license
Copyright (c) audanika

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# MidiNote and ChannelVelocity

## Motivation

- `MidiKey` names a note without its velocity: the channel and the note
  number a Note On refers to. Rendering notes needs the velocity too, and
  a voice that says on which channel and with which velocity a note
  number plays.
- Without shared types every consumer writes its own triple of channel,
  note and velocity and its own pair of channel and velocity, each with
  its own equality.
- `aud_midi_standard` is the dependency-free base of the family, so both
  values belong here, next to `MidiKey`.

## Strategy

- Add `MidiNote` and `ChannelVelocity` as models like `MidiKey`:
  immutable, value equality, JSON and `copyWith`, plus an `example`
  factory for tests and docs, as the code guide asks.
- Compose `MidiNote` from its fields and give it a `key` getter instead of
  deriving it from `MidiKey`.
- Let `ChannelVelocity` create the `MidiNote` of a note number.
- Keep the hand-written JSON readers of the models: the package still
  depends on the Dart SDK only.
- Release as a patch, 0.3.1: nothing existing changes, so every package
  on `^0.3.0` gets the new types without a release of its own.

## Implementation 1: MidiNote

- `MidiNote(channel:, note:, velocity:)` with channels 0 to 15, notes and
  velocities 0 to 127; values outside the ranges fail an assertion in
  debug builds.
- `key` returns the `MidiKey` of the note: its channel and its note
  number, without the velocity.
- Why not `extends MidiKey`: `MidiKey` is a final class, and its `==`
  asks `other is MidiKey`. A subclass with a velocity would compare
  asymmetrically: the key would equal the note, but not the other way
  round. Composition keeps both types plain values.
- `fromJson` reads the keys `channel`, `note` and `velocity` through the
  strict JSON reader and throws a `FormatException` for a missing key or
  a wrong type; `toJson` writes the same keys.
- `toString` prints `MidiNote(channel: 9, note: 67, velocity: 76)`.

## Implementation 2: ChannelVelocity

- `ChannelVelocity(channel:, velocity:)`: a voice, the channel and the
  velocity that notes are played with, asserted like `MidiNote`.
- `note(60)` returns the `MidiNote` of note number 60 on the channel and
  with the velocity of the voice.
- JSON with the keys `channel` and `velocity`, `copyWith` and value
  equality like the other models.

## Implementation 3: tests and documentation

- `test/model/midi_note_test.dart` and
  `test/model/channel_velocity_test.dart` cover the ranges, the key, the
  JSON round trip with its error messages, `copyWith`, `note` and the
  value semantics; the coverage stays at 100 %.
- The READMEs list notes and voices among the models, the `index.jsonc`
  names both in the domain.

## Dependency updates

- Development tooling only: the DNA layer and the analyzer moved to their
  newest patch and minor versions. Nothing changes at runtime.

## Open Points

- A `MidiNote` gives no Note On or Note Off message yet; add it when a
  consumer asks for it.
