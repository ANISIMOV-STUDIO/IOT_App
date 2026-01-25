/// Update Available Dialog - Notify user about new version
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
// Conditional import для web-специфичных функций
import 'package:hvac_control/presentation/screens/dashboard/dialogs/update_available_dialog_stub.dart'
    if (dart.library.html) 'update_available_dialog_web.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _UpdateDialogConstants {
  static const double iconContainerSize = 64;
}

class UpdateAvailableDialog extends StatefulWidget {

  const UpdateAvailableDialog({
    super.key,
    this.version,
    this.changelog,
  });
  final String? version;
  final String? changelog;

  static Future<void> show(
    BuildContext context, {
    String? version,
    String? changelog,
  }) async =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => UpdateAvailableDialog(
          version: version,
          changelog: changelog,
        ),
      );

  @override
  State<UpdateAvailableDialog> createState() => _UpdateAvailableDialogState();
}

class _UpdateAvailableDialogState extends State<UpdateAvailableDialog> {
  bool _showChangelog = false;

  void _reloadPage() {
    if (kIsWeb) {
      reloadWebPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = BreezColors.of(context);

    return Dialog(
      backgroundColor: colors.card.withValues(alpha: 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: BreezCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: _UpdateDialogConstants.iconContainerSize,
                height: _UpdateDialogConstants.iconContainerSize,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: AppColors.opacitySubtle),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.system_update,
                  size: AppIconSizes.standard,
                  color: colors.accent,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Title
              Text(
                widget.version != null
                    ? l10n.updateVersionAvailable(widget.version!)
                    : l10n.updateAvailable,
                style: TextStyle(
                  fontSize: AppFontSizes.h3,
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Message
              Text(
                l10n.updateMessage,
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  color: colors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),

              // Changelog section
              if (widget.changelog?.isNotEmpty ?? false) ...[
                const SizedBox(height: AppSpacing.md),

                // Toggle changelog button
                if (!_showChangelog)
                  BreezButton(
                    onTap: () => setState(() => _showChangelog = true),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    backgroundColor: colors.card.withValues(alpha: 0),
                    hoverColor: colors.accent.withValues(alpha: AppColors.opacityLight),
                    showBorder: false,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.whatsNew,
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            color: colors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Icon(
                          Icons.arrow_drop_down,
                          size: AppIconSizes.standard,
                          color: colors.accent,
                        ),
                      ],
                    ),
                  ),

                // Changelog content
                if (_showChangelog) ...[
                  const SizedBox(height: AppSpacing.xs),
                  BreezCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: SingleChildScrollView(
                        child: Text(
                          widget.changelog ?? '',
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            color: colors.text,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  BreezButton(
                    onTap: () => setState(() => _showChangelog = false),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    backgroundColor: colors.card.withValues(alpha: 0),
                    hoverColor: colors.buttonBg,
                    showBorder: false,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.hide,
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            color: colors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Icon(
                          Icons.arrow_drop_up,
                          size: AppIconSizes.standard,
                          color: colors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              const SizedBox(height: AppSpacing.lg),

              // Buttons
              Row(
                children: [
                  // Кнопка "Позже"
                  Expanded(
                    child: BreezButton(
                      onTap: () => Navigator.of(context).pop(),
                      backgroundColor: colors.buttonBg,
                      hoverColor: colors.buttonHover,
                      height: AppSizes.buttonHeight,
                      child: Center(
                        child: Text(
                          l10n.later,
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w600,
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  // Кнопка "Обновить сейчас"
                  Expanded(
                    child: BreezButton(
                      onTap: _reloadPage,
                      backgroundColor: colors.accent,
                      hoverColor: colors.accentLight,
                      height: AppSizes.buttonHeight,
                      child: Center(
                        child: Text(
                          l10n.updateNow,
                          style: const TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
