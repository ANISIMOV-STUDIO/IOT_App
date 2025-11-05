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
    return AppBar(
      backgroundColor: HvacColors.backgroundCard,
      elevation: 0,
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
class _WebBackButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _WebBackButton({required this.onPressed});

  @override
  State<_WebBackButton> createState() => _WebBackButtonState();
}

class _WebBackButtonState extends State<_WebBackButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Semantics(
        button: true,
        label: 'Navigate back',
        child: Tooltip(
          message: 'Назад',
          child: IconButton(
            onPressed: widget.onPressed,
            icon: AnimatedScale(
              scale: _isHovered ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                Icons.arrow_back,
                color: _isHovered
                    ? HvacColors.primaryOrange
                    : HvacColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Save button with hover state and loading animation
class _SaveButton extends StatefulWidget {
  final bool isSaving;
  final VoidCallback? onSave;

  const _SaveButton({
    required this.isSaving,
    this.onSave,
  });

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.isSaving
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: widget.isSaving ? null : widget.onSave,
        style: TextButton.styleFrom(
          foregroundColor: HvacColors.primaryOrange,
          backgroundColor: _isHovered
              ? HvacColors.primaryOrange.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: widget.isSaving ? _buildSavingIndicator() : _buildSaveText(),
      ),
    );
  }

  Widget _buildSavingIndicator() {
    return const SizedBox(
      width: 20.0,
      height: 20.0,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(HvacColors.primaryOrange),
      ),
    );
  }

  Widget _buildSaveText() {
    return const Text(
      'Сохранить',
      style: TextStyle(
        color: HvacColors.primaryOrange,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

