/// App BLoC Observer
/// 
/// Observes all BLoC/Cubit events, state changes, and errors.
/// Useful for debugging and logging.
library;

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Custom BLoC observer for debugging and logging
class AppBlocObserver extends BlocObserver {
  /// Whether to enable verbose logging
  final bool verbose;

  AppBlocObserver({this.verbose = false});

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode && verbose) {
      log('onCreate -- ${bloc.runtimeType}');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      log('onChange -- ${bloc.runtimeType}');
      if (verbose) {
        log('  currentState: ${change.currentState}');
        log('  nextState: ${change.nextState}');
      }
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      log('onEvent -- ${bloc.runtimeType}: $event');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode && verbose) {
      log('onTransition -- ${bloc.runtimeType}');
      log('  event: ${transition.event}');
      log('  currentState: ${transition.currentState}');
      log('  nextState: ${transition.nextState}');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('onError -- ${bloc.runtimeType}: $error', stackTrace: stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode && verbose) {
      log('onClose -- ${bloc.runtimeType}');
    }
  }
}