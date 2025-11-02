import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/data/models/hvac_unit_model.dart';
import 'package:hvac_control/domain/entities/hvac_unit.dart';

void main() {
  group('HvacUnitModel Tests', () {
    const testJson = {
      'id': 'unit-123',
      'name': 'Living Room AC',
      'location': 'Living Room',
      'currentTemp': 22.5,
      'targetTemp': 23.0,
      'humidity': 45,
      'mode': 'cooling',
      'fanSpeed': 'medium',
      'power': true,
      'timestamp': '2025-11-02T10:30:00Z',
      'supplyFanSpeed': 75,
      'exhaustFanSpeed': 50,
      'filterStatus': 'good',
      'energyConsumption': 1.5,
      'scheduleEnabled': true,
    };

    group('fromJson', () {
      test('creates model from valid JSON', () {
        final model = HvacUnitModel.fromJson(testJson);

        expect(model.id, 'unit-123');
        expect(model.name, 'Living Room AC');
        expect(model.location, 'Living Room');
        expect(model.currentTemp, 22.5);
        expect(model.targetTemp, 23.0);
        expect(model.humidity, 45);
        expect(model.mode, 'cooling');
        expect(model.fanSpeed, 'medium');
        expect(model.power, true);
        expect(model.supplyFanSpeed, 75);
        expect(model.exhaustFanSpeed, 50);
      });

      test('handles missing optional fields', () {
        final minimalJson = {
          'id': 'unit-456',
          'name': 'Bedroom AC',
          'location': 'Bedroom',
          'currentTemp': 20.0,
          'targetTemp': 21.0,
          'humidity': 40,
          'mode': 'heating',
          'fanSpeed': 'low',
          'power': false,
          'timestamp': '2025-11-02T10:30:00Z',
        };

        final model = HvacUnitModel.fromJson(minimalJson);

        expect(model.id, 'unit-456');
        expect(model.name, 'Bedroom AC');
        expect(model.power, false);
        expect(model.supplyFanSpeed, null);
        expect(model.exhaustFanSpeed, null);
      });

      test('handles null values gracefully', () {
        final jsonWithNulls = Map<String, dynamic>.from(testJson)
          ..['supplyFanSpeed'] = null
          ..['exhaustFanSpeed'] = null
          ..['filterStatus'] = null;

        final model = HvacUnitModel.fromJson(jsonWithNulls);

        expect(model.supplyFanSpeed, null);
        expect(model.exhaustFanSpeed, null);
        // filterStatus is not a property of HvacUnit
        // expect(model.filterStatus, null);
      });

      test('parses date string correctly', () {
        final model = HvacUnitModel.fromJson(testJson);

        expect(model.timestamp, isA<DateTime>());
        expect(model.timestamp.year, 2025);
        expect(model.timestamp.month, 11);
        expect(model.timestamp.day, 2);
      });

      test('throws on invalid JSON structure', () {
        const invalidJson = {
          'id': 'unit-123',
          // Missing required fields
        };

        expect(
          () => HvacUnitModel.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('toJson', () {
      test('converts model to JSON correctly', () {
        final model = HvacUnitModel.fromJson(testJson);
        final json = model.toJson();

        expect(json['id'], 'unit-123');
        expect(json['name'], 'Living Room AC');
        expect(json['location'], 'Living Room');
        expect(json['currentTemp'], 22.5);
        expect(json['targetTemp'], 23.0);
        expect(json['humidity'], 45);
        expect(json['mode'], 'cooling');
        expect(json['fanSpeed'], 'medium');
        expect(json['power'], true);
        expect(json['supplyFanSpeed'], 75);
        expect(json['exhaustFanSpeed'], 50);
      });

      test('handles null optional fields in toJson', () {
        final minimalJson = {
          'id': 'unit-789',
          'name': 'Kitchen AC',
          'location': 'Kitchen',
          'currentTemp': 21.0,
          'targetTemp': 22.0,
          'humidity': 42,
          'mode': 'auto',
          'fanSpeed': 'auto',
          'power': true,
          'timestamp': '2025-11-02T10:30:00Z',
        };

        final model = HvacUnitModel.fromJson(minimalJson);
        final json = model.toJson();

        expect(json['supplyFanSpeed'], null);
        expect(json['exhaustFanSpeed'], null);
        expect(json.containsKey('id'), true);
        expect(json.containsKey('name'), true);
      });

      test('round-trip conversion maintains data integrity', () {
        final originalModel = HvacUnitModel.fromJson(testJson);
        final json = originalModel.toJson();
        final reconstructedModel = HvacUnitModel.fromJson(json);

        expect(reconstructedModel.id, originalModel.id);
        expect(reconstructedModel.name, originalModel.name);
        expect(reconstructedModel.currentTemp,
            originalModel.currentTemp);
        expect(reconstructedModel.targetTemp,
            originalModel.targetTemp);
        expect(reconstructedModel.power, originalModel.power);
      });
    });

    group('toEntity', () {
      test('converts to domain entity correctly', () {
        final model = HvacUnitModel.fromJson(testJson);
        final entity = model.toEntity();

        expect(entity, isA<HvacUnit>());
        expect(entity.id, model.id);
        expect(entity.name, model.name);
        expect(entity.currentTemp, model.currentTemp);
        expect(entity.targetTemp, model.targetTemp);
        expect(entity.power, model.power);
      });

      test('maintains all properties in entity conversion', () {
        final model = HvacUnitModel.fromJson(testJson);
        final entity = model.toEntity();

        expect(entity.id, 'unit-123');
        expect(entity.name, 'Living Room AC');
        expect(entity.location, 'Living Room');
        expect(entity.mode, 'cooling');
        expect(entity.fanSpeed, 'medium');
        expect(entity.power, true);
      });
    });

    group('fromEntity', () {
      test('creates model from domain entity', () {
        final entity = HvacUnit(
          id: 'entity-123',
          name: 'Office AC',
          location: 'Office',
          currentTemp: 24.0,
          targetTemp: 23.5,
          humidity: 50,
          mode: 'cooling',
          fanSpeed: 'high',
          power: true,
          timestamp: DateTime.now(),
        );

        final model = HvacUnitModel.fromEntity(entity);

        expect(model.id, entity.id);
        expect(model.name, entity.name);
        expect(model.location, entity.location);
        expect(model.currentTemp, entity.currentTemp);
        expect(model.targetTemp, entity.targetTemp);
        expect(model.power, entity.power);
      });

      test('round-trip entity conversion maintains data', () {
        final originalModel = HvacUnitModel.fromJson(testJson);
        final entity = originalModel.toEntity();
        final reconstructedModel = HvacUnitModel.fromEntity(entity);

        expect(reconstructedModel.id, originalModel.id);
        expect(reconstructedModel.name, originalModel.name);
        expect(reconstructedModel.currentTemp,
            originalModel.currentTemp);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated values', () {
        final model = HvacUnitModel.fromJson(testJson);
        final updated = model.copyWith(
          name: 'Updated Name',
          targetTemp: 25.0,
          power: false,
        );

        expect(updated.name, 'Updated Name');
        expect(updated.targetTemp, 25.0);
        expect(updated.power, false);

        // Original values remain unchanged
        expect(updated.id, model.id);
        expect(updated.location, model.location);
        expect(updated.currentTemp, model.currentTemp);
      });

      test('maintains original values when no updates provided', () {
        final model = HvacUnitModel.fromJson(testJson);
        final copy = model.copyWith();

        expect(copy.id, model.id);
        expect(copy.name, model.name);
        expect(copy.currentTemp, model.currentTemp);
        expect(copy.power, model.power);
      });
    });

    group('Equality', () {
      test('models with same data are equal', () {
        final model1 = HvacUnitModel.fromJson(testJson);
        final model2 = HvacUnitModel.fromJson(testJson);

        expect(model1, equals(model2));
        expect(model1.hashCode, model2.hashCode);
      });

      test('models with different IDs are not equal', () {
        final model1 = HvacUnitModel.fromJson(testJson);
        final modifiedJson = Map<String, dynamic>.from(testJson)
          ..['id'] = 'different-id';
        final model2 = HvacUnitModel.fromJson(modifiedJson);

        expect(model1, isNot(equals(model2)));
      });

      test('models with different values are not equal', () {
        final model1 = HvacUnitModel.fromJson(testJson);
        final model2 = model1.copyWith(targetTemp: 30.0);

        expect(model1, isNot(equals(model2)));
      });
    });

    group('Edge Cases', () {
      test('handles extreme temperature values', () {
        final extremeJson = Map<String, dynamic>.from(testJson)
          ..['currentTemp'] = -50.0
          ..['targetTemp'] = 100.0;

        final model = HvacUnitModel.fromJson(extremeJson);

        expect(model.currentTemp, -50.0);
        expect(model.targetTemp, 100.0);
      });

      test('handles very long strings', () {
        final longString = 'A' * 1000;
        final longJson = Map<String, dynamic>.from(testJson)
          ..['name'] = longString;

        final model = HvacUnitModel.fromJson(longJson);

        expect(model.name, longString);
        expect(model.name.length, 1000);
      });

      test('handles special characters in strings', () {
        final specialJson = Map<String, dynamic>.from(testJson)
          ..['name'] = 'AC Unit 🏠 #1 @ Floor-2'
          ..['location'] = 'Ñoño\'s Room & Kitchen/Living';

        final model = HvacUnitModel.fromJson(specialJson);

        expect(model.name, 'AC Unit 🏠 #1 @ Floor-2');
        expect(model.location, 'Ñoño\'s Room & Kitchen/Living');
      });

      test('handles invalid date strings gracefully', () {
        final invalidDateJson = Map<String, dynamic>.from(testJson)
          ..['timestamp'] = 'invalid-date';

        expect(
          () => HvacUnitModel.fromJson(invalidDateJson),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('Performance', () {
      test('fromJson performance with large dataset', () {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          HvacUnitModel.fromJson(testJson);
        }

        stopwatch.stop();

        // Should parse 1000 models in less than 100ms
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('toJson performance with large dataset', () {
        final model = HvacUnitModel.fromJson(testJson);
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          model.toJson();
        }

        stopwatch.stop();

        // Should serialize 1000 models in less than 50ms
        expect(stopwatch.elapsedMilliseconds, lessThan(50));
      });
    });
  });
}