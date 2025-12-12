/// Cache Service
///
/// Persistent cache using Hive with in-memory fallback
library;

import 'package:hive_flutter/hive_flutter.dart';
import 'talker_service.dart';

class CacheService {
  static const String _boxName = 'app_cache';
  static const String _expiryBoxName = 'cache_expiry';

  Box<dynamic>? _box;
  Box<int>? _expiryBox;

  final Duration defaultExpiration;
  bool _initialized = false;

  CacheService({this.defaultExpiration = const Duration(minutes: 5)});

  /// Initialize Hive storage
  Future<void> init() async {
    if (_initialized) return;

    try {
      await Hive.initFlutter();
      _box = await Hive.openBox<dynamic>(_boxName);
      _expiryBox = await Hive.openBox<int>(_expiryBoxName);
      _initialized = true;
      talker.info('CacheService initialized with Hive');
    } catch (e) {
      talker.error('Failed to initialize CacheService: $e');
      _initialized = false;
    }
  }

  /// Get value from cache
  T? get<T>(String key) {
    if (!_initialized || _box == null) return null;

    try {
      // Check if expired
      final expiryTime = _expiryBox?.get(key);
      if (expiryTime != null) {
        if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
          // Expired - remove and return null
          remove(key);
          return null;
        }
      }

      return _box?.get(key) as T?;
    } catch (e) {
      talker.error('Cache get error: $e');
      return null;
    }
  }

  /// Set value in cache
  Future<void> set<T>(String key, T value, {Duration? expiration}) async {
    if (!_initialized || _box == null) return;

    try {
      await _box?.put(key, value);

      // Set expiry time
      final expiryTime = DateTime.now()
          .add(expiration ?? defaultExpiration)
          .millisecondsSinceEpoch;
      await _expiryBox?.put(key, expiryTime);
    } catch (e) {
      talker.error('Cache set error: $e');
    }
  }

  /// Check if key exists and is not expired
  bool has(String key) {
    if (!_initialized || _box == null) return false;

    if (!_box!.containsKey(key)) return false;

    // Check expiry
    final expiryTime = _expiryBox?.get(key);
    if (expiryTime != null) {
      if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
        remove(key);
        return false;
      }
    }

    return true;
  }

  /// Remove specific key
  Future<void> remove(String key) async {
    if (!_initialized) return;

    try {
      await _box?.delete(key);
      await _expiryBox?.delete(key);
    } catch (e) {
      talker.error('Cache remove error: $e');
    }
  }

  /// Clear all cache
  Future<void> clear() async {
    if (!_initialized) return;

    try {
      await _box?.clear();
      await _expiryBox?.clear();
      talker.info('Cache cleared');
    } catch (e) {
      talker.error('Cache clear error: $e');
    }
  }

  /// Remove expired entries
  Future<void> cleanExpired() async {
    if (!_initialized || _expiryBox == null) return;

    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final expiredKeys = <String>[];

      for (final key in _expiryBox!.keys) {
        final expiryTime = _expiryBox!.get(key);
        if (expiryTime != null && now > expiryTime) {
          expiredKeys.add(key.toString());
        }
      }

      for (final key in expiredKeys) {
        await remove(key);
      }

      if (expiredKeys.isNotEmpty) {
        talker.info('Cleaned ${expiredKeys.length} expired cache entries');
      }
    } catch (e) {
      talker.error('Cache cleanExpired error: $e');
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    if (!_initialized || _box == null) {
      return {'totalEntries': 0, 'keys': <String>[]};
    }

    return {
      'totalEntries': _box!.length,
      'keys': _box!.keys.map((k) => k.toString()).toList(),
    };
  }

  /// Close cache (call on app dispose)
  Future<void> close() async {
    try {
      await _box?.close();
      await _expiryBox?.close();
      _initialized = false;
    } catch (e) {
      talker.error('Cache close error: $e');
    }
  }
}
