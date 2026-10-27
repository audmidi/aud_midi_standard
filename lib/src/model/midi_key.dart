// @license
// Copyright (c) Audanika
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'midi_json_reader.dart';

// #############################################################################
/// A key of a channel: the channel and the note number that a Note On, a
/// Note Off, a key pressure or a per-note controller refers to.
///
/// Keys are immutable values; two keys with the same channel and note are
/// equal. Channels and notes are 0-based. Values outside the documented
/// ranges fail an assertion in debug builds.
final class MidiKey {
  /// Creates the key of [note] on [channel].
  const MidiKey({required this.channel, required this.note})
    : assert(channel >= 0 && channel <= 15),
      assert(note >= 0 && note <= 127);

  // ...........................................................................
  /// Decodes a key that [toJson] encoded.
  ///
  /// Throws a [FormatException] when a key is missing or has the wrong
  /// type.
  factory MidiKey.fromJson(Map<String, Object?> json) {
    final reader = MidiJsonReader(json, type: 'MidiKey');
    return MidiKey(
      channel: reader.value<int>('channel'),
      note: reader.value<int>('note'),
    );
  }

  // ...........................................................................
  /// Returns a copy with the given fields replaced.
  MidiKey copyWith({int? channel, int? note}) =>
      MidiKey(channel: channel ?? this.channel, note: note ?? this.note);

  /// Returns the key as a JSON map with the keys `channel` and `note`.
  Map<String, Object?> toJson() => {'channel': channel, 'note': note};

  // ...........................................................................
  /// The MIDI channel, 0 to 15.
  final int channel;

  /// The note number, 0 to 127.
  final int note;

  // ...........................................................................
  @override
  bool operator ==(Object other) =>
      other is MidiKey && other.channel == channel && other.note == note;

  @override
  int get hashCode => Object.hash(MidiKey, channel, note);

  @override
  String toString() => 'MidiKey(channel: $channel, note: $note)';
}
