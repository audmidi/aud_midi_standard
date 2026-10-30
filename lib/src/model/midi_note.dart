// @license
// Copyright (c) Audanika
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'midi_json_reader.dart';
import 'midi_key.dart';

// #############################################################################
/// A note with its velocity: the channel, the note number and the velocity
/// that a Note On plays.
///
/// Notes are immutable values; two notes with the same channel, note and
/// velocity are equal. [key] is the note without its velocity. Channels and
/// notes are 0-based. Values outside the documented ranges fail an
/// assertion in debug builds.
final class MidiNote {
  /// Creates the note [note] on [channel] with [velocity].
  const MidiNote({
    required this.channel,
    required this.note,
    required this.velocity,
  }) : assert(channel >= 0 && channel <= 15),
       assert(note >= 0 && note <= 127),
       assert(velocity >= 0 && velocity <= 127);

  // ...........................................................................
  /// Decodes a note that [toJson] encoded.
  ///
  /// Throws a [FormatException] when a key is missing or has the wrong
  /// type.
  factory MidiNote.fromJson(Map<String, Object?> json) {
    final reader = MidiJsonReader(json, type: 'MidiNote');
    return MidiNote(
      channel: reader.value<int>('channel'),
      note: reader.value<int>('note'),
      velocity: reader.value<int>('velocity'),
    );
  }

  // ...........................................................................
  /// Returns a copy with the given fields replaced.
  MidiNote copyWith({int? channel, int? note, int? velocity}) => MidiNote(
    channel: channel ?? this.channel,
    note: note ?? this.note,
    velocity: velocity ?? this.velocity,
  );

  /// Returns the note as a JSON map with the keys `channel`, `note` and
  /// `velocity`.
  Map<String, Object?> toJson() => {
    'channel': channel,
    'note': note,
    'velocity': velocity,
  };

  // ...........................................................................
  /// The MIDI channel, 0 to 15.
  final int channel;

  /// The note number, 0 to 127.
  final int note;

  /// The velocity, 0 to 127.
  final int velocity;

  /// The key of the note: its channel and its note number.
  MidiKey get key => MidiKey(channel: channel, note: note);

  // ...........................................................................
  @override
  bool operator ==(Object other) =>
      other is MidiNote &&
      other.channel == channel &&
      other.note == note &&
      other.velocity == velocity;

  @override
  int get hashCode => Object.hash(MidiNote, channel, note, velocity);

  @override
  String toString() =>
      'MidiNote(channel: $channel, note: $note, velocity: $velocity)';
}
