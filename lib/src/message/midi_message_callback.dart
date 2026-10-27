// @license
// Copyright (c) Audanika
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'midi_message.dart';

// #############################################################################
/// Receives messages in order: the signature of everything that takes a
/// list of messages, such as the output of a processor or the input of the
/// next link in a chain.
///
/// The list belongs to the callee: the caller creates it for the call and
/// does not reuse it.
typedef MidiMessageCallback = void Function(List<MidiMessage> messages);
