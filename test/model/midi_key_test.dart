// @license
// Copyright (c) Audanika
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:aud_midi_standard/aud_midi_standard.dart';
import 'package:test/test.dart';

void main() {
  group('MidiKey', () {
    const key = MidiKey(channel: 9, note: 67);

    group('MidiKey(channel: channel, note: note)', () {
      test('holds the channel and the note', () {
        expect(key.channel, 9);
        expect(key.note, 67);
      });

      test('asserts the ranges', () {
        for (final (channel, note) in [(-1, 0), (16, 0), (0, -1), (0, 128)]) {
          expect(
            () => MidiKey(channel: channel, note: note),
            throwsA(isA<AssertionError>()),
            reason: 'channel $channel, note $note',
          );
        }
      });
    });

    group('fromJson(json) and toJson()', () {
      test('round trip', () {
        expect(key.toJson(), equals({'channel': 9, 'note': 67}));
        expect(MidiKey.fromJson(key.toJson()), key);
      });

      test('throws on a missing or wrong key', () {
        expect(
          () => MidiKey.fromJson({'channel': 9}),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              'MidiKey: "note" is missing',
            ),
          ),
        );
        expect(
          () => MidiKey.fromJson({'channel': '9', 'note': 67}),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('copyWith(...)', () {
      test('replaces the given fields', () {
        expect(key.copyWith(), key);
        expect(
          key.copyWith(channel: 1, note: 2),
          const MidiKey(channel: 1, note: 2),
        );
      });
    });

    test('compares by value', () {
      expect(key, const MidiKey(channel: 9, note: 67));
      expect(key.hashCode, const MidiKey(channel: 9, note: 67).hashCode);
      expect(key == const MidiKey(channel: 10, note: 67), isFalse);
      expect(key == const MidiKey(channel: 9, note: 68), isFalse);
      expect(key.toString(), 'MidiKey(channel: 9, note: 67)');
    });
  });
}
