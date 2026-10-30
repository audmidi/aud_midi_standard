// @license
// Copyright (c) Audanika
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:aud_midi_standard/aud_midi_standard.dart';
import 'package:test/test.dart';

void main() {
  group('ChannelVelocity', () {
    const voice = ChannelVelocity(channel: 2, velocity: 76);

    group('ChannelVelocity(channel: channel, velocity: velocity)', () {
      test('holds the channel and the velocity', () {
        expect(voice.channel, 2);
        expect(voice.velocity, 76);
      });

      test('asserts the ranges', () {
        for (final (channel, velocity) in [
          (-1, 0),
          (16, 0),
          (0, -1),
          (0, 128),
        ]) {
          expect(
            () => ChannelVelocity(channel: channel, velocity: velocity),
            throwsA(isA<AssertionError>()),
            reason: 'channel $channel, velocity $velocity',
          );
        }
      });
    });

    group('note(note)', () {
      test('plays the note on the channel with the velocity', () {
        expect(
          voice.note(60),
          const MidiNote(channel: 2, note: 60, velocity: 76),
        );
      });
    });

    group('fromJson(json) and toJson()', () {
      test('round trip', () {
        expect(voice.toJson(), equals({'channel': 2, 'velocity': 76}));
        expect(ChannelVelocity.fromJson(voice.toJson()), voice);
      });

      test('throws on a missing or wrong key', () {
        expect(
          () => ChannelVelocity.fromJson({'channel': 2}),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              'ChannelVelocity: "velocity" is missing',
            ),
          ),
        );
        expect(
          () => ChannelVelocity.fromJson({'channel': 2, 'velocity': 7.6}),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('copyWith(...)', () {
      test('replaces the given fields', () {
        expect(voice.copyWith(), voice);
        expect(
          voice.copyWith(channel: 1, velocity: 3),
          const ChannelVelocity(channel: 1, velocity: 3),
        );
      });
    });

    test('compares by value', () {
      const same = ChannelVelocity(channel: 2, velocity: 76);
      expect(voice, same);
      expect(voice.hashCode, same.hashCode);
      expect(voice == voice.copyWith(channel: 3), isFalse);
      expect(voice == voice.copyWith(velocity: 77), isFalse);
      expect(voice.toString(), 'ChannelVelocity(channel: 2, velocity: 76)');
    });
  });
}
