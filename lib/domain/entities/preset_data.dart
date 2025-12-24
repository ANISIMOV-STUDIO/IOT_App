/// Preset Data Entity - Represents HVAC preset configuration
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// HVAC preset configuration
class PresetData extends Equatable {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int temperature;
  final int airflow;
  final Color? color;

  const PresetData({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.airflow,
    this.color,
  });

  PresetData copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    int? temperature,
    int? airflow,
    Color? color,
  }) {
    return PresetData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      temperature: temperature ?? this.temperature,
      airflow: airflow ?? this.airflow,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, name, description, icon, temperature, airflow, color];
}

/// Default presets list
class DefaultPresets {
  static const List<PresetData> all = [
    PresetData(
      id: 'comfort',
      name: 'Комфорт',
      description: 'Оптимальный режим',
      icon: Icons.spa_outlined,
      temperature: 22,
      airflow: 60,
      color: Color(0xFF2D7DFF),
    ),
    PresetData(
      id: 'eco',
      name: 'Эко',
      description: 'Энергосбережение',
      icon: Icons.eco_outlined,
      temperature: 20,
      airflow: 40,
      color: Color(0xFF22C55E),
    ),
    PresetData(
      id: 'night',
      name: 'Ночь',
      description: 'Тихий режим',
      icon: Icons.nightlight_outlined,
      temperature: 19,
      airflow: 30,
      color: Color(0xFF8B5CF6),
    ),
    PresetData(
      id: 'turbo',
      name: 'Турбо',
      description: 'Максимальная мощность',
      icon: Icons.bolt_outlined,
      temperature: 18,
      airflow: 100,
      color: Color(0xFFF97316),
    ),
    PresetData(
      id: 'away',
      name: 'Нет дома',
      description: 'Минимальный режим',
      icon: Icons.home_outlined,
      temperature: 16,
      airflow: 20,
      color: Color(0xFF64748B),
    ),
    PresetData(
      id: 'sleep',
      name: 'Сон',
      description: 'Комфортный сон',
      icon: Icons.bedtime_outlined,
      temperature: 20,
      airflow: 25,
      color: Color(0xFF6366F1),
    ),
  ];
}
