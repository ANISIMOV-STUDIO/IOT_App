/// Update Available Dialog - Notify user about new version
library;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../widgets/breez/breez_card.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/spacing.dart';

// Conditional import для web-специфичных функций
import 'update_available_dialog_stub.dart'
    if (dart.library.html) 'update_available_dialog_web.dart';

class UpdateAvailableDialog extends StatelessWidget {
  const UpdateAvailableDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UpdateAvailableDialog(),
    );
  }

  void _reloadPage() {
    if (kIsWeb) {
      reloadWebPage();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Доступна новая версия',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Message
              Text(
                'Вышло обновление приложения. Перезагрузите страницу, чтобы получить новые функции и исправления.',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: BreezButton(
                      onTap: () => Navigator.of(context).pop(),
                      backgroundColor: colors.buttonBg,
                      hoverColor: colors.card,
                      child: Text(
                        'Позже',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: BreezButton(
                      onTap: _reloadPage,
                      backgroundColor: AppColors.accent,
                      hoverColor: AppColors.accentLight,
                      child: const Text(
                        'Обновить сейчас',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
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
