// @license
// Copyright (c) Audanika
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:aud_midi_standard/aud_midi_standard.dart';
import 'package:test/test.dart';

void main() {
  group('MidiMessageCallback', () {
    test('receives a list of messages', () {
      final received = <List<MidiMessage>>[];
      final MidiMessageCallback callback = received.add;
      const noteOn = MidiNoteOn(channel: 0, note: 60, velocity: 100);
      callback([noteOn, const MidiStart()]);
      expect(
        received,
        equals([
          <MidiMessage>[noteOn, const MidiStart()],
        ]),
      );
    });
  });
}
