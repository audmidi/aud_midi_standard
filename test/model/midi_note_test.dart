// @license
// Copyright (c) Audanika
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:aud_midi_standard/aud_midi_standard.dart';
import 'package:test/test.dart';

void main() {
  group('MidiNote', () {
    const note = MidiNote(channel: 9, note: 67, velocity: 76);

    group('MidiNote(channel: channel, note: note, velocity: velocity)', () {
      test('holds the channel, the note and the velocity', () {
        expect(note.channel, 9);
        expect(note.note, 67);
        expect(note.velocity, 76);
      });

      test('asserts the ranges', () {
        for (final (channel, n, velocity) in [
          (-1, 0, 0),
          (16, 0, 0),
          (0, -1, 0),
          (0, 128, 0),
          (0, 0, -1),
          (0, 0, 128),
        ]) {
          expect(
            () => MidiNote(channel: channel, note: n, velocity: velocity),
            throwsA(isA<AssertionError>()),
            reason: 'channel $channel, note $n, velocity $velocity',
          );
        }
      });
    });

    group('key', () {
      test('is the channel and the note without the velocity', () {
        expect(note.key, const MidiKey(channel: 9, note: 67));
        expect(note.copyWith(velocity: 1).key, note.key);
      });
    });

    group('fromJson(json) and toJson()', () {
      test('round trip', () {
        expect(
          note.toJson(),
          equals({'channel': 9, 'note': 67, 'velocity': 76}),
        );
        expect(MidiNote.fromJson(note.toJson()), note);
      });

      test('throws on a missing or wrong key', () {
        expect(
          () => MidiNote.fromJson({'channel': 9, 'note': 67}),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              'MidiNote: "velocity" is missing',
            ),
          ),
        );
        expect(
          () => MidiNote.fromJson({'channel': 9, 'note': '67', 'velocity': 76}),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('copyWith(...)', () {
      test('replaces the given fields', () {
        expect(note.copyWith(), note);
        expect(
          note.copyWith(channel: 1, note: 2, velocity: 3),
          const MidiNote(channel: 1, note: 2, velocity: 3),
        );
      });
    });

    test('compares by value', () {
      const same = MidiNote(channel: 9, note: 67, velocity: 76);
      expect(note, same);
      expect(note.hashCode, same.hashCode);
      expect(note == note.copyWith(channel: 10), isFalse);
      expect(note == note.copyWith(note: 68), isFalse);
      expect(note == note.copyWith(velocity: 77), isFalse);
      expect(note.toString(), 'MidiNote(channel: 9, note: 67, velocity: 76)');
    });
  });
}
