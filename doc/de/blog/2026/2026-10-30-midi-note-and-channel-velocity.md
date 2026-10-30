<!--
@license
Copyright (c) audanika

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# MidiNote und ChannelVelocity

## Motivation

- `MidiKey` benennt eine Note ohne ihre Velocity: den Kanal und die
  Notennummer, auf die sich ein Note On bezieht. Wer Noten rendert,
  braucht auch die Velocity, und eine Stimme, die sagt, auf welchem Kanal
  und mit welcher Velocity eine Notennummer spielt.
- Ohne gemeinsame Typen schreibt jeder Nutzer sein eigenes Tripel aus
  Kanal, Note und Velocity und sein eigenes Paar aus Kanal und Velocity,
  jedes mit eigener Gleichheit.
- `aud_midi_standard` ist die abhängigkeitsfreie Basis der Familie, also
  gehören beide Werte hierher, neben `MidiKey`.

## Strategie

- `MidiNote` und `ChannelVelocity` als Modelle wie `MidiKey` anlegen:
  unveränderlich, Wertgleichheit, JSON und `copyWith`.
- `MidiNote` aus seinen Feldern zusammensetzen und ihm einen Getter `key`
  geben, statt es von `MidiKey` abzuleiten.
- `ChannelVelocity` die `MidiNote` einer Notennummer erzeugen lassen.
- Die handgeschriebenen JSON-Leser der Modelle behalten: Das Paket hängt
  weiter nur vom Dart SDK ab.
- Als Patch veröffentlichen, 0.3.1: Nichts Bestehendes ändert sich, also
  bekommt jedes Paket auf `^0.3.0` die neuen Typen ohne eigenes Release.

## Umsetzung 1: MidiNote

- `MidiNote(channel:, note:, velocity:)` mit Kanälen 0 bis 15, Noten und
  Velocities 0 bis 127; Werte außerhalb der Bereiche lösen in
  Debug-Builds eine Assertion aus.
- `key` liefert den `MidiKey` der Note: ihren Kanal und ihre Notennummer,
  ohne die Velocity.
- Warum nicht `extends MidiKey`: `MidiKey` ist eine final class, und ihr
  `==` fragt `other is MidiKey`. Eine Unterklasse mit Velocity würde
  unsymmetrisch vergleichen: Der Key wäre gleich der Note, aber nicht
  umgekehrt. Die Komposition hält beide Typen zu einfachen Werten.
- `fromJson` liest die Schlüssel `channel`, `note` und `velocity` über
  den strengen JSON-Leser und wirft bei fehlendem Schlüssel oder falschem
  Typ eine `FormatException`; `toJson` schreibt dieselben Schlüssel.
- `toString` gibt `MidiNote(channel: 9, note: 67, velocity: 76)` aus.

## Umsetzung 2: ChannelVelocity

- `ChannelVelocity(channel:, velocity:)`: eine Stimme, der Kanal und die
  Velocity, mit denen Noten gespielt werden, geprüft wie `MidiNote`.
- `note(60)` liefert die `MidiNote` der Notennummer 60 auf dem Kanal und
  mit der Velocity der Stimme.
- JSON mit den Schlüsseln `channel` und `velocity`, `copyWith` und
  Wertgleichheit wie bei den anderen Modellen.

## Umsetzung 3: Tests und Dokumentation

- `test/model/midi_note_test.dart` und
  `test/model/channel_velocity_test.dart` decken die Bereiche, den Key,
  den JSON-Rundlauf mit seinen Fehlermeldungen, `copyWith`, `note` und
  die Wertsemantik ab; die Abdeckung bleibt bei 100 %.
- Die READMEs nennen Noten und Stimmen unter den Modellen, die
  `index.jsonc` nennt beide in der Domäne.

## Aktualisierte Abhängigkeiten

- Nur Entwicklungswerkzeuge: Die DNA-Schicht und der Analyzer sind auf
  ihre neuesten Patch- und Minor-Versionen gestiegen. Zur Laufzeit ändert
  sich nichts.

## Offene Punkte

- Eine `MidiNote` liefert noch keine Note-On- oder Note-Off-Nachricht;
  das kommt, wenn ein Nutzer danach fragt.
