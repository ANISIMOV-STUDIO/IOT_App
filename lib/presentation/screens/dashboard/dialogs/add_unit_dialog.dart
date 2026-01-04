/// Add Unit Dialog - Dialog for registering HVAC device by MAC address
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../widgets/breez/breez_card.dart';

/// Результат диалога добавления устройства
class AddUnitResult {
  final String macAddress;
  final String name;

  const AddUnitResult({
    required this.macAddress,
    required this.name,
  });
}

/// Dialog for registering a new HVAC device by MAC address
class AddUnitDialog extends StatefulWidget {
  const AddUnitDialog({super.key});

  /// Shows the dialog and returns MAC address and name if created
  static Future<AddUnitResult?> show(BuildContext context) {
    return showDialog<AddUnitResult>(
      context: context,
      builder: (context) => const AddUnitDialog(),
    );
  }

  @override
  State<AddUnitDialog> createState() => _AddUnitDialogState();
}

class _AddUnitDialogState extends State<AddUnitDialog> {
  final _macController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;

  @override
  void dispose() {
    _macController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(AddUnitResult(
        macAddress: _macController.text.trim().toUpperCase(),
        name: _nameController.text.trim(),
      ));
    }
  }

  String? _validateMacAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите MAC-адрес';
    }

    // Убираем разделители и приводим к верхнему регистру
    final cleaned = value.replaceAll(RegExp(r'[:\-\s]'), '').toUpperCase();

    // MAC-адрес должен содержать 12 hex символов
    if (cleaned.length != 12) {
      return 'MAC-адрес должен содержать 12 символов';
    }

    if (!RegExp(r'^[0-9A-F]+$').hasMatch(cleaned)) {
      return 'MAC-адрес может содержать только 0-9 и A-F';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        side: BorderSide(color: colors.border),
      ),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(colors),
              const SizedBox(height: 24),
              _buildMacField(colors),
              const SizedBox(height: 16),
              _buildNameField(colors),
              const SizedBox(height: 8),
              _buildHelpText(colors),
              const SizedBox(height: 24),
              _buildActions(colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BreezColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Добавить установку',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colors.text,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(AppRadius.button),
            hoverColor: colors.buttonBg,
            splashColor: AppColors.accent.withValues(alpha: 0.1),
            highlightColor: AppColors.accent.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 20,
                color: colors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMacField(BreezColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MAC-адрес устройства',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _macController,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f:\-\s]')),
            LengthLimitingTextInputFormatter(17), // XX:XX:XX:XX:XX:XX
          ],
          style: TextStyle(
            color: colors.text,
            fontFamily: 'monospace',
            fontSize: 16,
            letterSpacing: 1.5,
          ),
          decoration: InputDecoration(
            hintText: 'AA:BB:CC:DD:EE:FF',
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.bg,
            prefixIcon: Icon(Icons.router, color: colors.textMuted, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: const BorderSide(color: AppColors.accentRed),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: _validateMacAddress,
        ),
      ],
    );
  }

  Widget _buildNameField(BreezColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Название',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          style: TextStyle(color: colors.text),
          decoration: InputDecoration(
            hintText: 'Например: Гостиная',
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.bg,
            prefixIcon: Icon(Icons.label_outline, color: colors.textMuted, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Введите название установки';
            }
            return null;
          },
          onFieldSubmitted: (_) => _submit(),
        ),
      ],
    );
  }

  Widget _buildHelpText(BreezColors colors) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: colors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'MAC-адрес отображается на экране пульта устройства',
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BreezColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Cancel button
        BreezDialogButton(
          label: 'Отмена',
          onTap: _isLoading ? null : () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 12),
        // Create button
        BreezDialogButton(
          label: 'Добавить',
          isPrimary: true,
          isLoading: _isLoading,
          onTap: _isLoading ? null : _submit,
        ),
      ],
    );
  }
}
