/// Schedule screen app bar with save functionality and web-friendly hover states
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';

class ScheduleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HvacUnit unit;
  final bool hasChanges;
  final bool isSaving;
  final VoidCallback? onSave;
  final VoidCallback? onBack;

  const ScheduleAppBar({
    super.key,
    required this.unit,
    required this.hasChanges,
    required this.isSaving,
    this.onSave,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return HvacAppBar(
      backgroundColor: HvacColors.backgroundCard,
      centerTitle: false,
      leading: _buildBackButton(context),
      title: _buildTitle(),
      actions: [_buildSaveButton()],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return _WebBackButton(onPressed: onBack ?? () => Navigator.pop(context));
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Расписание',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
        Text(
          unit.name,
          style: const TextStyle(
            fontSize: 12.0,
            color: HvacColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    if (!hasChanges) return const SizedBox.shrink();

    return AnimatedScale(
      scale: hasChanges ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: _SaveButton(
        isSaving: isSaving,
        onSave: onSave,
      ),
    );
  }
}

/// Back button with web-friendly hover state
class _WebBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _WebBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Navigate back',
      child: HvacIconButton(
        icon: Icons.arrow_back,
        onPressed: onPressed,
        tooltip: 'Назад',
      ),
    );
  }
}

/// Save button with hover state and loading animation
class _SaveButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback? onSave;

  const _SaveButton({
    required this.isSaving,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    if (isSaving) {
      return const SizedBox(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(HvacColors.primaryOrange),
        ),
      );
    }

    return HvacTextButton(
      label: 'Сохранить',
      onPressed: onSave,
    );
  }
}
