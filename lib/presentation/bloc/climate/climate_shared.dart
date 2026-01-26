/// Shared constants and utilities for Climate BLoCs
///
/// Contains:
/// - Temperature limits
/// - Timeout durations
/// - Debounce transformer
library;

import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Temperature limits for heating and cooling
abstract class TemperatureLimits {
  /// Minimum temperature (heating and cooling)
  static const int min = 15;

  /// Maximum temperature (heating and cooling)
  static const int max = 35;
}

/// Timeout waiting for device confirmation (power, schedule)
const Duration kPowerToggleTimeout = Duration(seconds: 15);

/// Timeout waiting for parameter change confirmation
const Duration kParamChangeTimeout = Duration(seconds: 10);

/// Sync timeout duration
const Duration kSyncTimeout = Duration(seconds: 15);

/// Debounce duration for rapid changes
const Duration kDebounceDuration = Duration(milliseconds: 500);

// =============================================================================
// EVENT TRANSFORMERS
// =============================================================================

/// Debounce transformer for rapid events
/// Waits 500ms after the last event, then processes only the last one
EventTransformer<E> debounceRestartable<E>({
  Duration duration = kDebounceDuration,
}) =>
    (events, mapper) => restartable<E>().call(
          events.debounce(duration),
          mapper,
        );

/// Extension for debounce on Stream
///
/// Timer is cancelled on handleDone and handleError to avoid race condition
extension DebounceExtension<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    Timer? timer;
    return transform(StreamTransformer<T, T>.fromHandlers(
      handleData: (data, sink) {
        timer?.cancel();
        timer = Timer(duration, () => sink.add(data));
      },
      handleError: (error, stackTrace, sink) {
        timer?.cancel();
        timer = null;
        sink.addError(error, stackTrace);
      },
      handleDone: (sink) {
        timer?.cancel();
        timer = null;
        sink.close();
      },
    ));
  }
}
