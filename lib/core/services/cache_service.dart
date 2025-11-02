/// Cache Service
///
/// Simple in-memory cache with expiration
library;

class CacheService {
  final Map<String, _CacheEntry> _cache = {};
  final Duration defaultExpiration;

  CacheService({this.defaultExpiration = const Duration(minutes: 5)});

  /// Get value from cache
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    // Check if expired
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    return entry.value as T?;
  }

  /// Set value in cache
  void set<T>(String key, T value, {Duration? expiration}) {
    _cache[key] = _CacheEntry(
      value: value,
      expiresAt: DateTime.now().add(expiration ?? defaultExpiration),
    );
  }

  /// Check if key exists and is not expired
  bool has(String key) {
    final entry = _cache[key];
    if (entry == null) return false;

    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }

    return true;
  }

  /// Remove specific key
  void remove(String key) {
    _cache.remove(key);
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
  }

  /// Remove expired entries
  void cleanExpired() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    cleanExpired();
    return {
      'totalEntries': _cache.length,
      'keys': _cache.keys.toList(),
    };
  }
}

class _CacheEntry {
  final dynamic value;
  final DateTime expiresAt;

  _CacheEntry({
    required this.value,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
