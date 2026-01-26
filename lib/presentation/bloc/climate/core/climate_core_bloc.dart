/// ClimateCoreBloc - Core lifecycle and SignalR management
///
/// Responsibilities:
/// - Device lifecycle (subscription, refresh, device change)
/// - SignalR stream management
/// - DeviceFullState loading and caching
/// - Sync timeout handling
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/domain/usecases/usecases.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_shared.dart';

import 'package:hvac_control/presentation/bloc/climate/core/climate_core_event.dart';
import 'package:hvac_control/presentation/bloc/climate/core/climate_core_state.dart';

export 'package:hvac_control/presentation/bloc/climate/core/climate_core_event.dart';
export 'package:hvac_control/presentation/bloc/climate/core/climate_core_state.dart';

/// BLoC for core climate lifecycle management
class ClimateCoreBloc extends Bloc<ClimateCoreEvent, ClimateCoreState> {
  ClimateCoreBloc({
    required GetCurrentClimateState getCurrentClimateState,
    required GetDeviceFullState getDeviceFullState,
    required WatchCurrentClimate watchCurrentClimate,
    required WatchDeviceFullState watchDeviceFullState,
    required RequestDeviceUpdate requestDeviceUpdate,
  })  : _getCurrentClimateState = getCurrentClimateState,
        _getDeviceFullState = getDeviceFullState,
        _watchCurrentClimate = watchCurrentClimate,
        _watchDeviceFullState = watchDeviceFullState,
        _requestDeviceUpdate = requestDeviceUpdate,
        super(const ClimateCoreState()) {
    // Debug ID
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    _blocId = timestamp.substring(timestamp.length - 4);
    developer.log('ClimateCoreBloc CREATED: blocId=$_blocId', name: 'ClimateCoreBloc');

    // Lifecycle events
    on<ClimateCoreSubscriptionRequested>(_onSubscriptionRequested);
    on<ClimateCoreRefreshRequested>(_onRefreshRequested);
    on<ClimateCoreSyncTimeout>(_onSyncTimeout);
    // restartable: cancels previous request on rapid device switching
    on<ClimateCoreDeviceChanged>(_onDeviceChanged, transformer: restartable());

    // Stream updates
    on<ClimateCoreStateUpdated>(_onStateUpdated);
    on<ClimateCoreFullStateLoaded>(_onFullStateLoaded);

    // Local state updates
    on<ClimateCoreQuickSensorsUpdated>(_onQuickSensorsUpdated);
  }

  late final String _blocId;
  final GetCurrentClimateState _getCurrentClimateState;
  final GetDeviceFullState _getDeviceFullState;
  final WatchCurrentClimate _watchCurrentClimate;
  final WatchDeviceFullState _watchDeviceFullState;
  final RequestDeviceUpdate _requestDeviceUpdate;

  StreamSubscription<ClimateState>? _climateSubscription;
  StreamSubscription<DeviceFullState>? _deviceFullStateSubscription;
  Timer? _syncTimer;

  /// Device ID already subscribed to SignalR (to prevent duplicates)
  String? _subscribedDeviceId;

  /// Request subscription to climate state
  Future<void> _onSubscriptionRequested(
    ClimateCoreSubscriptionRequested event,
    Emitter<ClimateCoreState> emit,
  ) async {
    emit(state.copyWith(status: ClimateCoreStatus.loading));

    try {
      // Load current state via Use Case
      final climate = await _getCurrentClimateState();

      emit(state.copyWith(
        status: ClimateCoreStatus.success,
        climate: climate,
      ));

      // Subscribe to updates via Use Case
      await _climateSubscription?.cancel();
      _climateSubscription = _watchCurrentClimate().listen(
        (climate) {
          if (!isClosed) {
            add(ClimateCoreStateUpdated(climate));
          }
        },
        onError: (error) {
          // Ignore stream errors - data already loaded
        },
      );

      // Request fresh data from device (fire-and-forget)
      if (climate.roomId.isNotEmpty) {
        _requestDeviceUpdate(climate.roomId).ignore();
      }
    } catch (e) {
      emit(state.copyWith(
        status: ClimateCoreStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Force refresh device data (sync button)
  Future<void> _onRefreshRequested(
    ClimateCoreRefreshRequested event,
    Emitter<ClimateCoreState> emit,
  ) async {
    // Prevent repeated clicks while syncing
    if (state.isSyncing) {
      return;
    }

    final deviceId = state.climate?.roomId ?? state.deviceFullState?.id;
    if (deviceId == null || deviceId.isEmpty) {
      return;
    }

    // Enable sync indicator
    emit(state.copyWith(isSyncing: true));

    // Timeout in case data doesn't arrive
    _syncTimer?.cancel();
    _syncTimer = Timer(kSyncTimeout, () {
      if (!isClosed && state.isSyncing) {
        add(const ClimateCoreSyncTimeout());
      }
    });

    // Request fresh data from device
    try {
      await _requestDeviceUpdate(deviceId);
    } catch (e) {
      _syncTimer?.cancel();
      emit(state.copyWith(isSyncing: false));
    }
  }

  /// Sync timeout handler
  void _onSyncTimeout(
    ClimateCoreSyncTimeout event,
    Emitter<ClimateCoreState> emit,
  ) {
    developer.log(
      '_onRefreshRequested: timeout waiting for device update',
      name: 'ClimateCoreBloc',
    );
    emit(state.copyWith(isSyncing: false));
  }

  /// Device changed - load its state
  Future<void> _onDeviceChanged(
    ClimateCoreDeviceChanged event,
    Emitter<ClimateCoreState> emit,
  ) async {
    emit(state.copyWith(status: ClimateCoreStatus.loading));

    try {
      // Load full device state (includes climate + alarms)
      final fullState = await _getDeviceFullState(
        GetDeviceFullStateParams(deviceId: event.deviceId),
      );

      // Build ClimateState from full state to optimize requests
      final climate = ClimateState(
        roomId: fullState.id,
        deviceName: fullState.name,
        currentTemperature: fullState.currentTemperature,
        targetTemperature: fullState.targetTemperature,
        humidity: fullState.humidity,
        targetHumidity: fullState.targetHumidity,
        // Get fan values from current mode settings
        supplyAirflow: fullState.modeSettings?[fullState.operatingMode]?.supplyFan?.toDouble() ?? 50,
        exhaustAirflow: fullState.modeSettings?[fullState.operatingMode]?.exhaustFan?.toDouble() ?? 50,
        mode: fullState.mode,
        preset: fullState.operatingMode,
        airQuality: AirQualityLevel.good,
        co2Ppm: fullState.coIndicator ?? 0,
        isOn: fullState.power,
      );

      emit(state.copyWith(
        status: ClimateCoreStatus.success,
        climate: climate,
        deviceFullState: fullState,
        isSyncing: false,
      ));

      // Subscribe to real-time DeviceFullState updates (SignalR)
      // Check to avoid duplicate subscriptions
      if (_subscribedDeviceId != event.deviceId) {
        await _deviceFullStateSubscription?.cancel();
        developer.log(
          '[$_blocId] _onDeviceChanged: subscribing to SignalR for device ${event.deviceId}',
          name: 'ClimateCoreBloc',
        );
        _subscribedDeviceId = event.deviceId;
        _deviceFullStateSubscription = _watchDeviceFullState(
          WatchDeviceFullStateParams(deviceId: event.deviceId),
        ).listen(
          (fullState) {
            if (!isClosed) {
              add(ClimateCoreFullStateLoaded(fullState));
            }
          },
          onError: (Object error) {
            // Not critical if SignalR doesn't work
            ApiLogger.warning('[ClimateCoreBloc] DeviceFullState stream error', error);
          },
        );
      } else {
        developer.log(
          '[$_blocId] _onDeviceChanged: already subscribed to device ${event.deviceId}, skipping',
          name: 'ClimateCoreBloc',
        );
      }

      // Request fresh data from device (fire-and-forget)
      _requestDeviceUpdate(event.deviceId).ignore();
    } catch (e) {
      emit(state.copyWith(
        status: ClimateCoreStatus.failure,
        errorMessage: 'State loading error: $e',
      ));
    }
  }

  /// Climate state update from stream
  void _onStateUpdated(
    ClimateCoreStateUpdated event,
    Emitter<ClimateCoreState> emit,
  ) {
    developer.log(
      '[$_blocId] _onStateUpdated: preset=${event.climate.preset} at ${DateTime.now()}',
      name: 'ClimateCoreBloc',
    );

    // Reset sync indicator - data arrived
    if (state.isSyncing) {
      _syncTimer?.cancel();
      _syncTimer = null;
    }

    emit(state.copyWith(
      climate: event.climate,
      isSyncing: false,
    ));
  }

  /// Full device state loaded from SignalR
  ///
  /// IMPORTANT: quickSensors is a user setting, not telemetry.
  /// SignalR updates may not contain quickSensors, so we preserve
  /// existing value. Update via ClimateCoreQuickSensorsUpdated event.
  void _onFullStateLoaded(
    ClimateCoreFullStateLoaded event,
    Emitter<ClimateCoreState> emit,
  ) {
    final existing = state.deviceFullState;
    final incoming = event.fullState;

    // Merge modeSettings: if incoming is null, take from existing
    final mergedModeSettings = _mergeModeSettings(
      existing?.modeSettings,
      incoming.modeSettings,
    );

    // Preserve quickSensors - it's a user preference, not telemetry
    final mergedState = existing != null
        ? incoming.copyWith(
            quickSensors: existing.quickSensors,
            modeSettings: mergedModeSettings,
          )
        : incoming;

    // Reset sync indicator - data arrived
    if (state.isSyncing) {
      _syncTimer?.cancel();
      _syncTimer = null;
    }

    emit(state.copyWith(
      deviceFullState: mergedState,
      isSyncing: false,
    ));
  }

  /// Merge modeSettings: incoming values take priority, but null doesn't overwrite.
  ///
  /// SignalR response is the source of truth. We trust incoming data and update UI.
  /// Optimistic update already showed the user the change, SignalR confirms it.
  Map<String, ModeSettings>? _mergeModeSettings(
    Map<String, ModeSettings>? existing,
    Map<String, ModeSettings>? incoming,
  ) {
    if (incoming == null) {
      return existing;
    }
    if (existing == null) {
      return incoming;
    }

    final merged = <String, ModeSettings>{...existing};
    for (final entry in incoming.entries) {
      final existingSettings = existing[entry.key];
      if (existingSettings == null) {
        merged[entry.key] = entry.value;
      } else {
        // Merge individual fields: incoming takes priority, but null doesn't overwrite.
        merged[entry.key] = ModeSettings(
          heatingTemperature:
              entry.value.heatingTemperature ?? existingSettings.heatingTemperature,
          coolingTemperature:
              entry.value.coolingTemperature ?? existingSettings.coolingTemperature,
          supplyFan: entry.value.supplyFan ?? existingSettings.supplyFan,
          exhaustFan: entry.value.exhaustFan ?? existingSettings.exhaustFan,
        );
      }
    }
    return merged;
  }

  /// Quick sensors updated in local state (after successful save)
  void _onQuickSensorsUpdated(
    ClimateCoreQuickSensorsUpdated event,
    Emitter<ClimateCoreState> emit,
  ) {
    if (state.deviceFullState != null) {
      emit(state.copyWith(
        deviceFullState: state.deviceFullState!.copyWith(
          quickSensors: event.quickSensors,
        ),
      ));
    }
  }

  @override
  Future<void> close() async {
    developer.log('ClimateCoreBloc CLOSED: blocId=$_blocId', name: 'ClimateCoreBloc');

    // Cancel all subscriptions first and wait for completion
    await _climateSubscription?.cancel();
    await _deviceFullStateSubscription?.cancel();

    // Timers can be cancelled synchronously
    _syncTimer?.cancel();

    _subscribedDeviceId = null;

    return super.close();
  }
}
