/// Add Unit Dialog - Dialog for creating new HVAC unit
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../widgets/common/hover_builder.dart';

/// Dialog for adding a new HVAC unit
class AddUnitDialog extends StatefulWidget {
  const AddUnitDialog({super.key});

  /// Shows the dialog and returns the unit name if created
  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => const AddUnitDialog(),
    );
  }

  @override
  State<AddUnitDialog> createState() => _AddUnitDialogState();
}

class _AddUnitDialogState extends State<AddUnitDialog> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_nameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildNameField(),
              const SizedBox(height: 24),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Новая установка',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        HoverBuilder(
          onTap: () => Navigator.of(context).pop(),
          builder: (context, isHovered) {
            return Icon(
              Icons.close,
              size: 20,
              color: isHovered ? Colors.white : AppColors.darkTextMuted,
            );
          },
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Название',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextMuted,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Например: ПВ-3',
            hintStyle: const TextStyle(color: AppColors.darkTextMuted),
            filled: true,
            fillColor: AppColors.darkBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: const BorderSide(color: AppColors.darkBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: const BorderSide(color: AppColors.darkBorder),
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

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Cancel button
        _DialogButton(
          label: 'Отмена',
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 12),
        // Create button
        _DialogButton(
          label: 'Создать',
          isPrimary: true,
          onTap: _submit,
        ),
      ],
    );
  }
}

/// Dialog action button
class _DialogButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;

  const _DialogButton({
    required this.label,
    this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      onTap: onTap,
      builder: (context, isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isPrimary
                ? (isHovered ? AppColors.accentLight : AppColors.accent)
                : (isHovered ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: isPrimary ? null : Border.all(color: AppColors.darkBorder),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
              color: isPrimary ? Colors.white : AppColors.darkTextMuted,
            ),
          ),
        );
      },
    );
  }
}
