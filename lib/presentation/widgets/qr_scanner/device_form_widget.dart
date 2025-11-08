/// Device Form Widget
///
/// Handles manual device entry with MAC address, name, and location
/// Supports both mobile and web responsive layouts
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'qr_scanner_responsive.dart';

class DeviceFormWidget extends StatefulWidget {
  final Function(String macAddress, String deviceName, String location)
      onSubmit;
  final String? initialMacAddress;
  final String? initialDeviceName;
  final bool isWebMode;
  final VoidCallback? onCancel;

  const DeviceFormWidget({
    super.key,
    required this.onSubmit,
    this.initialMacAddress,
    this.initialDeviceName,
    this.isWebMode = false,
    this.onCancel,
  });

  @override
  State<DeviceFormWidget> createState() => _DeviceFormWidgetState();
}

class _DeviceFormWidgetState extends State<DeviceFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _macController;
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _macController = TextEditingController(text: widget.initialMacAddress);
    _nameController = TextEditingController(text: widget.initialDeviceName);
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _macController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String? _validateMacAddress(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.fillRequiredFields;
    }
    final macRegex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
    if (!macRegex.hasMatch(value)) {
      return 'Invalid MAC address format (e.g., AA:BB:CC:DD:EE:FF)';
    }
    return null;
  }

  String? _validateDeviceName(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.fillRequiredFields;
    }
    if (value.length < 3) {
      return 'Device name must be at least 3 characters';
    }
    return null;
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      widget.onSubmit(
        _macController.text.trim(),
        _nameController.text.trim(),
        _locationController.text.trim(),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final responsive = QrScannerResponsive(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // MAC Address Field
          HvacTextField(
            controller: _macController,
            labelText: l10n.macAddress,
            hintText: 'XX:XX:XX:XX:XX:XX',
            prefixIcon: Icons.router,
            enabled: !(widget.initialMacAddress != null && !widget.isWebMode),
            validator: (value) => _validateMacAddress(value, l10n),
            textCapitalization: TextCapitalization.characters,
          ),
          SizedBox(height: responsive.verticalSpacing),

          // Device Name Field
          HvacTextField(
            controller: _nameController,
            labelText: l10n.deviceName,
            hintText: l10n.livingRoom,
            prefixIcon: Icons.label,
            validator: (value) => _validateDeviceName(value, l10n),
          ),
          SizedBox(height: responsive.verticalSpacing),

          // Location Field (Optional)
          HvacTextField(
            controller: _locationController,
            labelText: l10n.location,
            hintText: l10n.optional,
            prefixIcon: Icons.location_on,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Submit Button
          if (widget.isWebMode) ...[
            HvacPrimaryButton(
              label: _isSubmitting ? 'Adding...' : l10n.addDevice,
              icon: _isSubmitting ? null : Icons.add,
              isExpanded: true,
              isLoading: _isSubmitting,
              onPressed: _isSubmitting ? null : _handleSubmit,
            ),
          ] else ...[
            // For dialog mode, buttons are handled by the dialog
            if (_isSubmitting)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
