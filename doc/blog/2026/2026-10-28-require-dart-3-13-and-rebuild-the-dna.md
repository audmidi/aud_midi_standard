<!--
@license
Copyright (c) audanika

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Require Dart 3.13 and rebuild the DNA

## Motivation

- The family of MIDI packages is maintained in one pass: every repo
  moves to the current Dart SDK, takes the current versions of its
  dependencies and rebuilds its DNA instances.
- `aud_midi_standard` is the dependency-free base of that family. It
  already used `dna_audanika` 0.1.0 and `helix` 1.14, so its share of
  the pass is small: the SDK floor, the formatting the new SDK asks for
  and the DNA instances.
- A common SDK floor keeps the family resolvable as one: a consumer on
  Dart 3.13 should not have to carry a package that still allows 3.12.

## Strategy

- Raise the SDK constraint to `^3.13.0`, the version the family builds
  and tests with.
- Let `gg do upgrade deps` confirm that no dependency has a newer
  version; the lock file stays as it is.
- Rebuild the DNA with `gg dna build` and let the DNA test of the repo
  verify the result when the checks run.
- Let `dart format` of the new SDK reformat what it formats differently
  now, and keep the public API untouched: no model, message or callback
  changes in this pass.

## Implementation 1: SDK floor and formatting

- `pubspec.yaml`: `environment.sdk` moves from `^3.12.2` to `^3.13.0`.
- The formatter of Dart 3.13 adds a trailing comma to the single
  parameter of `MidiTime`, `MidiDeviceId`, `MidiPortId` and
  `MidiTimedMessage` and rewraps three tests. Seven files change by a
  line or two each; nothing changes in behaviour.
- The analyzer and the tests stay green at 100 % coverage.

## Implementation 2: DNA instances

- `gg dna build` of gg 17.6 rebuilt the instances with the helix 1.13
  engine that gg ships: it folded `.claude/CLAUDE_dna_gg.md` into
  `CLAUDE.md` and committed that as `#gg: generated DNA`.
- The DNA test of the repo runs with `helix` 1.14, the dev dependency,
  and rebuilt the instances again on the next check: the separate file
  came back and the manifest records 1.14 as the engine. That landed
  as a second `#gg: generated DNA` commit.
- The two commits cancel out: the instances of the repo are the ones it
  had before, built and verified by its own engine.

## Dependency updates

- No dependency changed its version. `dna_audanika` 0.1.0 and `helix`
  1.14 were already current; `gg do upgrade deps` reported the repo as
  up to date.

## Open Points

- gg 17.6 builds the DNA with helix 1.13 while the repo tests it with
  helix 1.14. Until gg moves to 1.14, `gg dna build` and the DNA test
  disagree about `CLAUDE.md`; the test has the last word.
- The DNA variables of this repo still name `audanika` as the git
  organisation, while the repo lives under `audmidi`. The badge URLs the
  README template renders point there. A follow-up pass over the MIDI
  family should set `dnaGitOrg` and `dnaGitOrgUrl` to `audmidi`.
