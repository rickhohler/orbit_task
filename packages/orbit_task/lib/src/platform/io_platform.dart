import 'dart:isolate';

String get currentIsolateName => Isolate.current.debugName ?? 'unknown';
