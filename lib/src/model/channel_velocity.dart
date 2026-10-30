// @license
// Copyright (c) Audanika
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'midi_json_reader.dart';
import 'midi_note.dart';

// #############################################################################
/// A voice: the channel and the velocity that notes are played with.
///
/// Voices are immutable values; two voices with the same channel and
/// velocity are equal. [note] turns a note number into the [MidiNote] of
/// the voice. Channels are 0-based. Values outside the documented ranges
/// fail an assertion in debug builds.
final class ChannelVelocity {
  /// Creates the voice of [channel] and [velocity].
  const ChannelVelocity({required this.channel, required this.velocity})
    : assert(channel >= 0 && channel <= 15),
      assert(velocity >= 0 && velocity <= 127);

  // ...........................................................................
  /// Creates an example voice for tests and docs: channel 0 with velocity
  /// 76, or the given values.
  factory ChannelVelocity.example({int? channel, int? velocity}) =>
      ChannelVelocity(channel: channel ?? 0, velocity: velocity ?? 76);

  // ...........................................................................
  /// Decodes a voice that [toJson] encoded.
  ///
  /// Throws a [FormatException] when a key is missing or has the wrong
  /// type.
  factory ChannelVelocity.fromJson(Map<String, Object?> json) {
    final reader = MidiJsonReader(json, type: 'ChannelVelocity');
    return ChannelVelocity(
      channel: reader.value<int>('channel'),
      velocity: reader.value<int>('velocity'),
    );
  }

  // ...........................................................................
  /// Returns the note [note] played on the channel with the velocity of
  /// this voice.
  MidiNote note(int note) =>
      MidiNote(channel: channel, note: note, velocity: velocity);

  /// Returns a copy with the given fields replaced.
  ChannelVelocity copyWith({int? channel, int? velocity}) => ChannelVelocity(
    channel: channel ?? this.channel,
    velocity: velocity ?? this.velocity,
  );

  /// Returns the voice as a JSON map with the keys `channel` and
  /// `velocity`.
  Map<String, Object?> toJson() => {'channel': channel, 'velocity': velocity};

  // ...........................................................................
  /// The MIDI channel, 0 to 15.
  final int channel;

  /// The velocity, 0 to 127.
  final int velocity;

  // ...........................................................................
  @override
  bool operator ==(Object other) =>
      other is ChannelVelocity &&
      other.channel == channel &&
      other.velocity == velocity;

  @override
  int get hashCode => Object.hash(ChannelVelocity, channel, velocity);

  @override
  String toString() =>
      'ChannelVelocity(channel: $channel, velocity: $velocity)';
}
