/// Rate limiting service for API requests
library;

import '../../constants/security_constants.dart';

class RateLimiter {
  final Map<String, List<DateTime>> _requestHistory = {};
  final Map<String, DateTime> _rateLimitExpiryMap = {};

  /// Check rate limit for an endpoint
  void checkRateLimit(String endpoint) {
    final now = DateTime.now();

    // Check if rate limited
    if (_rateLimitExpiryMap.containsKey(endpoint)) {
      final expiry = _rateLimitExpiryMap[endpoint]!;
      if (now.isBefore(expiry)) {
        throw RateLimitException(
          'Rate limit exceeded for endpoint: $endpoint. Try again after $expiry',
        );
      } else {
        _rateLimitExpiryMap.remove(endpoint);
        _requestHistory.remove(endpoint);
      }
    }

    // Initialize request history if needed
    _requestHistory[endpoint] ??= [];

    // Clean old requests (older than 1 minute)
    _requestHistory[endpoint]!.removeWhere(
      (time) => now.difference(time).inMinutes > 1,
    );

    // Add current request
    _requestHistory[endpoint]!.add(now);

    // Check if limit exceeded
    if (_requestHistory[endpoint]!.length >
        SecurityConstants.maxApiRequestsPerMinute) {
      _rateLimitExpiryMap[endpoint] = now.add(const Duration(minutes: 1));
      throw RateLimitException(
        'Rate limit exceeded for endpoint: $endpoint',
      );
    }
  }

  /// Clear rate limit history for an endpoint
  void clearEndpointHistory(String endpoint) {
    _requestHistory.remove(endpoint);
    _rateLimitExpiryMap.remove(endpoint);
  }

  /// Clear all rate limit history
  void clearAllHistory() {
    _requestHistory.clear();
    _rateLimitExpiryMap.clear();
  }
}

/// Rate limit exception
class RateLimitException implements Exception {
  final String message;
  const RateLimitException(this.message);

  @override
  String toString() => 'RateLimitException: $message';
}
