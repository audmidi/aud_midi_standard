# MidiKey und MidiMessageCallback

## Motivation

- Zwei Dinge kehren überall wieder, wo MIDI verarbeitet wird: das Paar aus
  Kanal und Notennummer, auf das sich ein Note On, ein Note Off, ein Key
  Pressure oder ein Per-Note-Controller bezieht, und ein Empfänger, der
  eine Liste von Nachrichten entgegennimmt.
- Bisher hat jeder Nutzer beides selbst ausgeschrieben, mit eigener
  Gleichheit, eigener Dokumentation und eigenem Namen.
- `aud_midi_standard` ist die abhängigkeitsfreie Basis der Familie, also
  gehört das gemeinsame Vokabular hierher, neben `MidiIssueCallback` und
  die beschreibenden Modelle.

## Strategie

- `MidiKey` als Modell wie die anderen anlegen: unveränderlich,
  Wertgleichheit, JSON und `copyWith`.
- `MidiMessageCallback` als Typedef mit einem klaren Vertrag für die
  Liste anlegen, die er empfängt.
- Beide über die Barrel-Datei exportieren, mit Tests zu 100 % abdecken und
  in den READMEs sowie in der `index.jsonc` nennen.
- Die Namen präzise halten: ein Callback sagt, womit er gerufen wird, und
  ein Key ist eine Adresse, kein Notenereignis.

## Realisierung 1: MidiKey

- `MidiKey(channel:, note:)` mit Kanälen 0 bis 15 und Noten 0 bis 127;
  Werte außerhalb schlagen in Debug-Builds als Assertion fehl.
- `fromJson` liest die Schlüssel `channel` und `note` über den strengen
  JSON-Reader der Modelle und wirft bei fehlendem Schlüssel oder falschem
  Typ eine `FormatException`; `toJson` schreibt dieselben zwei Schlüssel.
- `copyWith` ersetzt einzelne Felder, `==` und `hashCode` vergleichen
  nach Wert, `toString` liefert `MidiKey(channel: 9, note: 67)`.
- Die Datei `lib/src/model/midi_key.dart` folgt dem Aufbau der anderen
  Modelle: Konstruktor, `fromJson`, `copyWith` und `toJson`, dann die
  Felder, dann die Gleichheit.

## Realisierung 2: MidiMessageCallback

- `typedef MidiMessageCallback = void Function(List<MidiMessage>
  messages)` in `lib/src/message/midi_message_callback.dart`.
- Der Vertrag: Die Liste gehört dem Aufgerufenen. Der Aufrufer legt sie
  für den Aufruf an und verwendet sie nicht wieder, ein Empfänger darf sie
  also behalten oder verändern.
- Er ist die Signatur von allem, was Nachrichten in Reihenfolge
  entgegennimmt, etwa der Ausgang eines Prozessors oder der Eingang des
  nächsten Glieds einer Kette.

## Realisierung 3: Tests und Dokumentation

- `test/model/midi_key_test.dart` deckt die Bereiche, den JSON-Rundlauf mit
  seinen Fehlermeldungen, `copyWith` und die Wertsemantik ab.
- `test/message/midi_message_callback_test.dart` zeigt einen Empfänger,
  der Nachrichtenlisten sammelt.
- Die READMEs führen Keys unter den Modellen und die beiden Callbacks auf,
  die `index.jsonc` nennt sie in der Domäne.

## Aktualisierte Abhängigkeiten

- `helix` 1.14 und die DNA-Schicht `dna_audanika` 0.1.0: neue Guides für
  Blogposts und Übersetzungen, ein Prompt-Hook, ein README-Prüfskript und
  überarbeitete Guides. Die DNA fragt jedes Repo jetzt nach dem Namen
  seiner Quick-Check-Pipeline; hier ist es `Quick Check`.

## Offene Punkte

- Eine Factory, die einen `MidiKey` aus einer Notennachricht baut, wird
  noch nicht gebraucht; sie kommt, sobald ein zweiter Nutzer sie braucht.
- Die Guides der Übersetzungsschicht erwarten zu jeder Datei in `doc` eine
  deutsche Kopie; die Guides selbst kommen aus der DNA und bleiben
  englisch.
