/// Request signing service for API security
library;

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class RequestSigner {
  final String apiSecret;

  RequestSigner({required this.apiSecret});

  /// Sign a request
  String signRequest(String method, String path, Map<String, dynamic>? body) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final nonce = generateNonce();

    String dataToSign = '$method|$path|$timestamp|$nonce';
    if (body != null) {
      final sortedBody = Map.fromEntries(
        body.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );
      dataToSign += '|${json.encode(sortedBody)}';
    }

    final hmac = Hmac(sha256, utf8.encode(apiSecret));
    final digest = hmac.convert(utf8.encode(dataToSign));

    return base64.encode(digest.bytes);
  }

  /// Generate a nonce for request signing
  String generateNonce() {
    final random = Random.secure();
    final bytes = List.generate(32, (_) => random.nextInt(256));
    return base64.encode(bytes);
  }

  /// Validate response signature
  bool validateResponseSignature(
    String? signature,
    String responseBody,
    String apiSecret,
  ) {
    if (signature == null) {
      return true; // Accept responses without signature for now
    }

    try {
      final hmac = Hmac(sha256, utf8.encode(apiSecret));
      final digest = hmac.convert(utf8.encode(responseBody));
      final expectedSignature = base64.encode(digest.bytes);

      return signature == expectedSignature;
    } catch (e) {
      return false;
    }
  }
}