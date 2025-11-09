/// Security Helper Functions
///
/// Common security validation helpers for XSS, SQL injection, etc.
library;

/// Check for suspicious patterns (XSS, injection attempts)
bool containsSuspiciousPatterns(String value) {
  final suspiciousPatterns = [
    RegExp(r'<script', caseSensitive: false),
    RegExp(r'javascript:', caseSensitive: false),
    RegExp(r'on\w+\s*=', caseSensitive: false), // Event handlers
    RegExp(r'data:text/html', caseSensitive: false),
    RegExp(r'vbscript:', caseSensitive: false),
    RegExp(r'<iframe', caseSensitive: false),
    RegExp(r'<embed', caseSensitive: false),
    RegExp(r'<object', caseSensitive: false),
  ];

  for (final pattern in suspiciousPatterns) {
    if (pattern.hasMatch(value)) {
      return true;
    }
  }

  return false;
}

/// Check for SQL injection patterns
bool containsSQLInjection(String value) {
  final sqlPatterns = [
    RegExp(
        r"('|(')|(--)|(/\*)|(\*/)|(\bor\b)|(\band\b)|(\bunion\b)|(\bselect\b)|(\binsert\b)|(\bupdate\b)|(\bdelete\b)|(\bdrop\b))",
        caseSensitive: false),
  ];

  for (final pattern in sqlPatterns) {
    if (pattern.hasMatch(value)) {
      return true;
    }
  }

  return false;
}
