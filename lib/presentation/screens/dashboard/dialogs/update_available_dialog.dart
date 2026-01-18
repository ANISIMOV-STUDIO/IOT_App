/// Update Available Dialog - Notify user about new version
library;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../widgets/breez/breez_card.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../generated/l10n/app_localizations.dart';

// Conditional import для web-специфичных функций
import 'update_available_dialog_stub.dart'
    if (dart.library.html) 'update_available_dialog_web.dart';

class UpdateAvailableDialog extends StatefulWidget {
  final String? version;
  final String? changelog;

  const UpdateAvailableDialog({
    super.key,
    this.version,
    this.changelog,
  });

  static Future<void> show(
    BuildContext context, {
    String? version,
    String? changelog,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateAvailableDialog(
        version: version,
        changelog: changelog,
      ),
    );
  }

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
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: BreezCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.system_update,
                  size: 32,
                  color: AppColors.accent,
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
                    backgroundColor: Colors.transparent,
                    hoverColor: AppColors.accent.withValues(alpha: 0.1),
                    showBorder: false,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.whatsNew,
                          style: const TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: AppColors.accent,
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
                    backgroundColor: Colors.transparent,
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
                          size: 20,
                          color: colors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              const SizedBox(height: AppSpacing.lg),

              // Buttons - ИСПРАВЛЕНО
              Row(
                children: [
                  // Кнопка "Позже"
                  Expanded(
                    child: BreezButton(
                      onTap: () => Navigator.of(context).pop(),
                      backgroundColor: colors.buttonBg,
                      hoverColor: colors.card,
                      height: 48,
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
                      backgroundColor: AppColors.accent,
                      hoverColor: AppColors.accentLight,
                      height: 48,
                      child: Center(
                        child: Text(
                          l10n.updateNow,
                          style: const TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
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
