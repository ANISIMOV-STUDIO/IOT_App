# Validators Module

Comprehensive input validation utilities with security focus, now refactored into modular structure.

## 📁 Module Structure

```
validators/
├── email_validator.dart       # Email validation
├── password_validator.dart    # Password validation & strength
├── text_validator.dart        # Name, alphanumeric, sanitization
├── network_validator.dart     # Phone, URL, IP, SSID, WiFi
├── device_validator.dart      # Device ID, temperature, numbers
└── security_helpers.dart      # XSS, SQL injection checks
```

## 🚀 Quick Start

### Using the main Validators class (backward compatible)

```dart
import 'package:hvac_control/core/utils/validators.dart';

// Validate email
String? emailError = Validators.validateEmail('user@example.com');

// Validate password
String? passwordError = Validators.validatePassword('SecurePass123!');

// Calculate password strength
PasswordStrength strength = Validators.calculatePasswordStrength('MyP@ss123');
```

### Using individual validator modules

```dart
import 'package:hvac_control/core/utils/validators/email_validator.dart';
import 'package:hvac_control/core/utils/validators/password_validator.dart';

// Direct module usage
String? emailError = EmailValidator.validate('user@example.com');
String? passwordError = PasswordValidator.validate('SecurePass123!');
PasswordStrength strength = PasswordValidator.calculateStrength('MyP@ss123');
```

## 📚 Module Documentation

### EmailValidator

Validates email addresses with security checks against XSS and injection attacks.

```dart
String? error = EmailValidator.validate('user@example.com');
// Returns null if valid, error message if invalid
```

**Features:**
- ✅ Format validation (RFC 5322)
- ✅ Length checks (max 254 characters)
- ✅ XSS pattern detection
- ✅ Lowercase & trim normalization

---

### PasswordValidator

Validates passwords with configurable strength requirements.

```dart
// Validate password
String? error = PasswordValidator.validate('MySecureP@ss123');

// Check password confirmation
String? confirmError = PasswordValidator.validateConfirmation(
  'MySecureP@ss123',
  'MySecureP@ss123'
);

// Calculate strength
PasswordStrength strength = PasswordValidator.calculateStrength('MyP@ss123');
// Returns: weak, medium, strong, or veryStrong
```

**Features:**
- ✅ Minimum/maximum length validation
- ✅ Uppercase, lowercase, number, special char requirements
- ✅ Weak password detection (common passwords list)
- ✅ Repeating character detection
- ✅ Sequential character detection
- ✅ Password strength calculation

**Strength Scoring:**
- **Weak** (0-3): Basic requirements not met
- **Medium** (4-5): Meets basic requirements
- **Strong** (6-7): Good length + complexity
- **Very Strong** (8+): Excellent length + complexity + patterns

---

### TextValidator

Validates text inputs with security sanitization.

```dart
// Validate name
String? error = TextValidator.validateName('John Doe', fieldName: 'First Name');

// Validate alphanumeric
String? error = TextValidator.validateAlphanumeric(
  'User123',
  fieldName: 'Username',
  minLength: 3,
  maxLength: 20,
);

// Sanitize input (remove HTML, scripts, SQL patterns)
String clean = TextValidator.sanitize('<script>alert("xss")</script>Hello');
// Returns: "Hello"
```

**Features:**
- ✅ Name validation (2-50 characters, letters/spaces/hyphens)
- ✅ Alphanumeric validation with length constraints
- ✅ SQL injection detection
- ✅ HTML/XSS sanitization

---

### NetworkValidator

Validates network-related inputs.

```dart
// Validate phone
String? error = NetworkValidator.validatePhone('+1 (555) 123-4567');

// Validate URL
String? error = NetworkValidator.validateUrl('https://example.com');

// Validate IP address (IPv4 or IPv6)
String? error = NetworkValidator.validateIpAddress('192.168.1.1');

// Validate WiFi SSID
String? error = NetworkValidator.validateSSID('MyHomeNetwork');

// Validate WiFi password
String? error = NetworkValidator.validateWiFiPassword(
  'SecureWiFiPass',
  'WPA2'  // or 'WPA', 'WEP', 'open'
);
```

**Features:**
- ✅ Phone number validation (international formats)
- ✅ URL validation (http/https)
- ✅ IPv4 and IPv6 support
- ✅ WiFi SSID validation (max 32 chars, no control chars)
- ✅ WiFi password validation (WPA/WPA2/WEP standards)

---

### DeviceValidator

Validates device-specific inputs for IoT/HVAC applications.

```dart
// Validate device ID
String? error = DeviceValidator.validateDeviceId('HVAC-12AB-34CD-56EF');

// Validate temperature
String? error = DeviceValidator.validateTemperature(
  '22.5',
  min: -20,
  max: 50,
  unit: '°C',
);

// Validate numeric input
String? error = DeviceValidator.validateNumber(
  '123.45',
  fieldName: 'Fan Speed',
  min: 0,
  max: 100,
  allowDecimal: true,
);
```

**Features:**
- ✅ Device ID format (alphanumeric + hyphens, 8-36 chars)
- ✅ Temperature validation with range checks
- ✅ Numeric validation (int or decimal) with min/max

---

### Security Helpers

Low-level security functions used by other validators.

```dart
import 'package:hvac_control/core/utils/validators/security_helpers.dart';

// Check for XSS patterns
bool hasXSS = containsSuspiciousPatterns('<script>alert("xss")</script>');

// Check for SQL injection patterns
bool hasSQL = containsSQLInjection("' OR 1=1 --");
```

**Detects:**
- ✅ `<script>` tags
- ✅ `javascript:` protocol
- ✅ Event handlers (`onclick=`, etc.)
- ✅ SQL keywords (`SELECT`, `UNION`, `DROP`, etc.)
- ✅ SQL operators (`OR`, `AND`)
- ✅ Comment sequences (`--`, `/*`)

---

## 🔒 Security Features

All validators include security checks:

1. **XSS Prevention**: Detects and blocks script injection attempts
2. **SQL Injection Prevention**: Blocks SQL keywords and patterns
3. **Input Sanitization**: Removes dangerous characters and HTML tags
4. **Length Limits**: Prevents buffer overflow attacks
5. **Pattern Validation**: Uses strict regex patterns

## 📋 Usage in Forms

### Flutter Form Example

```dart
TextFormField(
  decoration: const InputDecoration(labelText: 'Email'),
  validator: Validators.validateEmail,
  keyboardType: TextInputType.emailAddress,
),

TextFormField(
  decoration: const InputDecoration(labelText: 'Password'),
  validator: Validators.validatePassword,
  obscureText: true,
),

TextFormField(
  decoration: const InputDecformation(labelText: 'Name'),
  validator: (value) => Validators.validateName(value, fieldName: 'Full Name'),
),
```

### With Password Strength Indicator

```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String _password = '';
  PasswordStrength _strength = PasswordStrength.weak;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Password'),
          validator: Validators.validatePassword,
          obscureText: true,
          onChanged: (value) {
            setState(() {
              _password = value;
              _strength = Validators.calculatePasswordStrength(value);
            });
          },
        ),
        PasswordStrengthIndicator(password: _password, strength: _strength),
      ],
    );
  }
}
```

## 🧪 Testing

All validators are unit-tested. Run tests with:

```bash
flutter test test/core/utils/validators_test.dart
```

## 🔄 Migration from Old API

The refactored validators maintain full backward compatibility:

```dart
// Old API (still works)
Validators.validateEmail(email);
Validators.validatePassword(password);

// New API (recommended for new code)
EmailValidator.validate(email);
PasswordValidator.validate(password);
```

Both approaches work identically. The new modular structure provides:
- Better code organization
- Easier testing
- Smaller file sizes
- Clear separation of concerns

## 📦 Dependencies

- `security_constants.dart` - Regex patterns and security config
- No external packages required

## 🤝 Contributing

When adding new validators:

1. Create a new file in `validators/` directory
2. Follow the naming convention: `*_validator.dart`
3. Export from `validators.dart` barrel file
4. Add backward-compatible methods to `Validators` class
5. Update this README with examples
6. Add unit tests

## 📄 License

Part of HVAC Control application.
