/// QR Scanner Controller
///
/// Manages QR scanner business logic and state
/// Separates business logic from UI components
library;

import 'package:flutter/foundation.dart';

/// QR code data model
class QrCodeData {
  final String macAddress;
  final String? deviceName;
  final String? additionalInfo;

  QrCodeData({
    required this.macAddress,
    this.deviceName,
    this.additionalInfo,
  });

  /// Parse QR code string into structured data
  /// Expected formats:
  /// - MAC_ADDRESS
  /// - MAC_ADDRESS|DEVICE_NAME
  /// - MAC_ADDRESS|DEVICE_NAME|ADDITIONAL_INFO
  factory QrCodeData.fromString(String code) {
    final parts = code.split('|');
    return QrCodeData(
      macAddress: parts.isNotEmpty ? parts[0].trim() : '',
      deviceName: parts.length > 1 ? parts[1].trim() : null,
      additionalInfo: parts.length > 2 ? parts[2].trim() : null,
    );
  }

  bool get isValid => _isValidMacAddress(macAddress);

  static bool _isValidMacAddress(String mac) {
    final macRegex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
    return macRegex.hasMatch(mac);
  }
}

/// Scanner mode enum
enum ScannerMode {
  camera,
  manual,
  web,
}

/// QR Scanner Controller
class QrScannerController extends ChangeNotifier {
  ScannerMode _mode;
  bool _isProcessing = false;
  QrCodeData? _lastScannedCode;
  String? _errorMessage;

  QrScannerController({
    ScannerMode initialMode = ScannerMode.camera,
  }) : _mode = initialMode {
    // Initialize based on platform
    if (kIsWeb) {
      _mode = ScannerMode.web;
    }
  }

  // Getters
  ScannerMode get mode => _mode;
  bool get isProcessing => _isProcessing;
  QrCodeData? get lastScannedCode => _lastScannedCode;
  String? get errorMessage => _errorMessage;
  bool get isCameraMode => _mode == ScannerMode.camera;
  bool get isManualMode => _mode == ScannerMode.manual;
  bool get isWebMode => _mode == ScannerMode.web;

  /// Switch scanner mode
  void setMode(ScannerMode mode) {
    if (_mode != mode) {
      _mode = mode;
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Toggle between camera and manual modes
  void toggleMode() {
    if (kIsWeb) {
      // On web, toggle between web and manual
      setMode(_mode == ScannerMode.web ? ScannerMode.manual : ScannerMode.web);
    } else {
      // On mobile, toggle between camera and manual
      setMode(_mode == ScannerMode.camera
          ? ScannerMode.manual
          : ScannerMode.camera);
    }
  }

  /// Process scanned QR code
  Future<bool> processQrCode(String code) async {
    if (_isProcessing) return false;

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Parse QR code data
      final qrData = QrCodeData.fromString(code);

      // Validate MAC address
      if (!qrData.isValid) {
        _errorMessage = 'Invalid QR code format. MAC address not recognized.';
        _isProcessing = false;
        notifyListeners();
        return false;
      }

      // Store last scanned code
      _lastScannedCode = qrData;

      // Simulate processing delay
      await Future.delayed(const Duration(milliseconds: 500));

      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to process QR code: ${e.toString()}';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Validate MAC address format
  bool validateMacAddress(String mac) {
    return QrCodeData._isValidMacAddress(mac);
  }

  /// Clear last scanned code
  void clearLastScannedCode() {
    _lastScannedCode = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset controller state
  void reset() {
    _isProcessing = false;
    _lastScannedCode = null;
    _errorMessage = null;
    _mode = kIsWeb ? ScannerMode.web : ScannerMode.camera;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
