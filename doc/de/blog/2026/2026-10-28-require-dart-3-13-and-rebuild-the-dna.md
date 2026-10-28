<!--
@license
Copyright (c) audanika

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Dart 3.13 voraussetzen und die DNA neu bauen

## Motivation

- Die Familie der MIDI-Pakete wird in einem Durchgang gepflegt: Jedes
  Repo wechselt auf das aktuelle Dart SDK, übernimmt die aktuellen
  Versionen seiner Abhängigkeiten und baut seine DNA-Instanzen neu.
- `aud_midi_standard` ist die abhängigkeitsfreie Basis dieser Familie.
  Es nutzte bereits `dna_audanika` 0.1.0 und `helix` 1.14, sein Anteil
  am Durchgang ist daher klein: die SDK-Untergrenze, die Formatierung,
  die das neue SDK verlangt, und die DNA-Instanzen.
- Eine gemeinsame SDK-Untergrenze hält die Familie als Ganzes auflösbar:
  Ein Nutzer auf Dart 3.13 soll kein Paket mitschleppen müssen, das noch
  3.12 erlaubt.

## Strategie

- Die SDK-Bedingung auf `^3.13.0` anheben, die Version, mit der die
  Familie baut und testet.
- `gg do upgrade deps` bestätigen lassen, dass keine Abhängigkeit eine
  neuere Version hat; die Lock-Datei bleibt wie sie ist.
- Die DNA mit `gg dna build` neu bauen und den DNA-Test des Repos das
  Ergebnis prüfen lassen, wenn die Checks laufen.
- `dart format` des neuen SDK umformatieren lassen, was es nun anders
  formatiert, und die öffentliche API unangetastet lassen: keine
  Änderung an Modellen, Nachrichten oder Callbacks in diesem Durchgang.

## Realisierung 1: SDK-Untergrenze und Formatierung

- `pubspec.yaml`: `environment.sdk` wechselt von `^3.12.2` auf
  `^3.13.0`.
- Der Formatierer von Dart 3.13 hängt an den einzelnen Parameter von
  `MidiTime`, `MidiDeviceId`, `MidiPortId` und `MidiTimedMessage` ein
  abschließendes Komma an und bricht drei Tests neu um. Sieben Dateien
  ändern sich um ein bis zwei Zeilen; am Verhalten ändert sich nichts.
- Analyzer und Tests bleiben grün bei 100 % Abdeckung.

## Realisierung 2: DNA-Instanzen

- `gg dna build` von gg 17.6 hat die Instanzen mit der helix-1.13-Engine
  gebaut, die gg mitbringt: Es hat `.claude/CLAUDE_dna_gg.md` in
  `CLAUDE.md` eingefaltet und das als `#gg: generated DNA` committet.
- Der DNA-Test des Repos läuft mit `helix` 1.14, der Dev-Abhängigkeit,
  und hat die Instanzen beim nächsten Check erneut gebaut: Die separate
  Datei kam zurück und das Manifest hält 1.14 als Engine fest. Das
  landete als zweiter Commit `#gg: generated DNA`.
- Die beiden Commits heben sich auf: Die Instanzen des Repos sind die,
  die es vorher hatte, gebaut und geprüft von seiner eigenen Engine.

## Aktualisierte Abhängigkeiten

- Keine Abhängigkeit hat ihre Version geändert. `dna_audanika` 0.1.0 und
  `helix` 1.14 waren bereits aktuell; `gg do upgrade deps` meldete das
  Repo als auf dem neuesten Stand.

## Offene Punkte

- gg 17.6 baut die DNA mit helix 1.13, während das Repo sie mit helix
  1.14 testet. Bis gg auf 1.14 wechselt, sind sich `gg dna build` und
  der DNA-Test über `CLAUDE.md` uneins; der Test hat das letzte Wort.
- Die DNA-Variablen dieses Repos nennen weiterhin `audanika` als
  Git-Organisation, während das Repo unter `audmidi` liegt. Die
  Badge-URLs, die die README-Vorlage rendert, zeigen dorthin. Ein
  späterer Durchgang über die MIDI-Familie sollte `dnaGitOrg` und
  `dnaGitOrgUrl` auf `audmidi` setzen.
