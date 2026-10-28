# aud_midi_standard

[English](README.md) | Deutsch

Die Standards MIDI 1.0 und 2.0 (UMP) als Dart ohne Abhängigkeiten:
Konstanten, Modelle, Parser, Codecs. Dazu die Übersetzung zwischen MIDI 1.0
und MIDI 2.0 und die beschreibenden Modelle der aud_midi-Familie.

Teil der aud_midi-Familie, siehe [aud_midi](https://github.com/audmidi/aud_midi).

## Motivation

Die MIDI-Standards sollen als reines Dart-Paket in jedem Projekt nutzbar
sein — in einer Audio-Engine, einem Sequenzer, einem Testwerkzeug oder einem
Konverter — ohne nativen Code, ohne Isolate und ohne die Laufzeit der
aud_midi-Familie. Zugleich muss das Nachrichtenmodell den ganzen
UMP-Standard abdecken, damit kein MIDI-2.0-Feature je einen API-Bruch
erzwingt. Das Paket zielt auf:

- Keine Abhängigkeiten, läuft auf der Dart-VM, im Web und in Wasm
- Eine typisierte, versiegelte Nachrichtenhierarchie für MIDI 1.0 und
  MIDI 2.0
- Zwei unabhängige Rohformen: MIDI-1.0-Bytes und Universal MIDI Packets
- Vollständiger UMP-Codec, Übersetzung MIDI 1.0 ↔ 2.0 nach M2-104-UM
- Geräte-, Port-, Capability- und Event-Modelle für alle Backends
- Übernimmt `gg_midi_vars`

## Installation

```bash
dart pub add aud_midi_standard
```

## Verwendung

Einen MIDI-1.0-Bytestrom parsen, eine Nachricht nach MIDI 2.0 übersetzen,
als UMP kodieren und wieder dekodieren:

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

Es gibt aus:

```text
0 MidiNoteOn(channel: 0, note: 60, velocity: 100)
0 MidiNoteOn(channel: 0, note: 64, velocity: 90)
MidiNoteOn2(channel: 0, note: 60, velocity: 51492, attributeType: 0, attribute: 0)
[Ump(41903c00 c9240000)]
group 1: MidiBytes(90 3c 64)
60
allNotesOff
```

## Einschränkungen

Das Paket deckt nur die Standards ab: Es öffnet keinen Port, spricht mit
keinem Betriebssystem und plant nichts zeitlich ein. Ports, Geräte und
Timing kommen aus den Backends und der Laufzeit der aud_midi-Familie.

## Dokumentation

- [Plan der aud_midi-Familie](https://github.com/audmidi/aud_midi_pm/blob/main/doc/2026-Q4/tickets/2026-10-06-aud_midi_01-initial-midi-implementation.md)
- [Entscheidungen](https://github.com/audmidi/aud_midi_pm/blob/main/doc/2026-Q4/concepts/decisions/000-index.md),
  z. B. die Übersetzungsregeln
- [Guides](doc/guides/)

## Status

Vor 1.0 — die API kann sich zwischen Minor-Versionen ändern. Das Paket
deckt ab:

- Nachrichten: MIDI-1.0-Channel-Voice, System Common und Real-Time,
  SysEx; MIDI-2.0-Channel-Voice inkl. Per-Note-Controllern und
  -Management; Utility, SysEx8, Mixed Data Set, Flex Data und
  UMP-Stream-Nachrichten
- Codecs: Byte-Parser (Running Status, SysEx-Zusammenbau mit Grenzen,
  eingestreute Real-Time-Nachrichten) und Encoder; UMP-Encoder und
  -Decoder für die Message Types 0x0–0xF mit Zusammenbau; Standard-
  Übersetzung nach M2-104-UM Anhang D mit Werteskalierung;
  BLE-MIDI-Paket-Codec
- Konstanten: Statusbytes, Controller und Notennummern (Namen aus
  gg_midi_vars erhalten), RPNs, General MIDI 1 und 2, Hersteller-IDs,
  Universal SysEx, MIDI Time Code, UMP-Statuswerte, Flex Data, Akkorde
- Modelle: Ports, Geräte, Capabilities, virtuelle Ports,
  BLE-Peripheriegeräte, Netzwerk-Hosts und -Sessions, Events, Pakete,
  Diagnosen, Keys (`MidiKey`: Kanal und Note) — unveränderlich, mit JSON
  und `copyWith`
- Callbacks: `MidiIssueCallback` für Parser-Probleme,
  `MidiMessageCallback` für Empfänger von Nachrichtenlisten
- 100 % Testabdeckung; Spezifikationsverweise in jedem Doc-Kommentar

## Mitwirken

Siehe [doc/guides/develop-guide.md](doc/guides/develop-guide.md).

## Lizenz

MIT — siehe [LICENSE](LICENSE).
