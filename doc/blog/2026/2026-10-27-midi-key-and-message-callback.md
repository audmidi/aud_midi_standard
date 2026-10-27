# MidiKey and MidiMessageCallback

## Motivation

- Two things recur wherever MIDI is processed: the pair of channel and
  note number that a Note On, a Note Off, a key pressure or a per-note
  controller refers to, and a receiver that takes a list of messages.
- Until now every consumer spelled both out for itself, with its own
  equality, its own documentation and its own name.
- `aud_midi_standard` is the dependency-free base of the family, so the
  shared vocabulary belongs here, next to `MidiIssueCallback` and the
  descriptive models.

## Strategy

- Add `MidiKey` as a model like the others: immutable, value equality,
  JSON and `copyWith`.
- Add `MidiMessageCallback` as a typedef with a clear contract for the
  list it receives.
- Export both through the barrel file, cover them with tests at 100 %,
  and name them in the READMEs and in the `index.jsonc`.
- Keep the names specific: a callback says what it is called with, and a
  key is an address, not a note event.

## Implementation 1: MidiKey

- `MidiKey(channel:, note:)` with channels 0 to 15 and notes 0 to 127;
  values outside the ranges fail an assertion in debug builds.
- `fromJson` reads the keys `channel` and `note` through the strict JSON
  reader of the models and throws a `FormatException` for a missing key
  or a wrong type; `toJson` writes the same two keys.
- `copyWith` replaces single fields, `==` and `hashCode` compare by
  value, `toString` prints `MidiKey(channel: 9, note: 67)`.
- The file `lib/src/model/midi_key.dart` follows the layout of the other
  models: constructor, `fromJson`, `copyWith` and `toJson`, then the
  fields, then equality.

## Implementation 2: MidiMessageCallback

- `typedef MidiMessageCallback = void Function(List<MidiMessage>
  messages)` in `lib/src/message/midi_message_callback.dart`.
- The contract: the list belongs to the callee. The caller creates it for
  the call and does not reuse it, so a receiver may keep or mutate it.
- It is the signature of everything that takes messages in order, such
  as the output of a processor or the input of the next link in a chain.

## Implementation 3: tests and documentation

- `test/model/midi_key_test.dart` covers the ranges, the JSON round trip
  with its error messages, `copyWith` and the value semantics.
- `test/message/midi_message_callback_test.dart` shows a receiver
  collecting lists of messages.
- The READMEs list keys among the models and the two callbacks, the
  `index.jsonc` names them in the domain.

## Dependency updates

- `helix` 1.14 and the DNA layer `dna_audanika` 0.1.0: new guides for
  blog posts and translations, a prompt hook, a README check script and
  refreshed guides. The DNA now asks every repo for the name of its quick
  check pipeline; it is `Quick Check` here.

## Open Points

- A factory that builds a `MidiKey` from a note message is not needed
  yet; add it when a second consumer asks for it.
- The guides of the translate layer expect a German copy of every file in
  `doc`; the guides themselves come from the DNA and stay English.
