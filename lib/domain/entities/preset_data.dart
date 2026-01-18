/// Preset Data Entity - Represents HVAC preset configuration
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';

/// HVAC preset configuration
class PresetData extends Equatable {

  const PresetData({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.airflow,
    this.color,
  });
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int temperature;
  final int airflow;
  final Color? color;

  PresetData copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    int? temperature,
    int? airflow,
    Color? color,
  }) => PresetData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      temperature: temperature ?? this.temperature,
      airflow: airflow ?? this.airflow,
      color: color ?? this.color,
    );

  @override
  List<Object?> get props => [id, name, description, icon, temperature, airflow, color];
}

/// Default presets list
class DefaultPresets {
  /// Get localized presets
  static List<PresetData> getAll(AppLocalizations l10n) => [
    PresetData(
      id: 'comfort',
      name: l10n.presetComfort,
      description: l10n.presetComfortDesc,
      icon: Icons.spa_outlined,
      temperature: 22,
      airflow: 60,
      color: const Color(0xFF2D7DFF),
    ),
    PresetData(
      id: 'eco',
      name: l10n.presetEco,
      description: l10n.presetEcoDesc,
      icon: Icons.eco_outlined,
      temperature: 20,
      airflow: 40,
      color: const Color(0xFF22C55E),
    ),
    PresetData(
      id: 'night',
      name: l10n.presetNight,
      description: l10n.presetNightDesc,
      icon: Icons.nightlight_outlined,
      temperature: 19,
      airflow: 30,
      color: const Color(0xFF8B5CF6),
    ),
    PresetData(
      id: 'turbo',
      name: l10n.presetTurbo,
      description: l10n.presetTurboDesc,
      icon: Icons.bolt_outlined,
      temperature: 18,
      airflow: 100,
      color: const Color(0xFFF97316),
    ),
    PresetData(
      id: 'away',
      name: l10n.presetAway,
      description: l10n.presetAwayDesc,
      icon: Icons.home_outlined,
      temperature: 16,
      airflow: 20,
      color: const Color(0xFF64748B),
    ),
    PresetData(
      id: 'sleep',
      name: l10n.presetSleep,
      description: l10n.presetSleepDesc,
      icon: Icons.bedtime_outlined,
      temperature: 20,
      airflow: 25,
      color: const Color(0xFF6366F1),
    ),
  ];
}
