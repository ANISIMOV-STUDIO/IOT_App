/// App Footer with consistent styling
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';

/// App footer with status info
class AppFooter extends StatelessWidget {
  final String? time;
  final int? outsideTemp;
  final bool isOnline;
  final String version;

  const AppFooter({
    super.key,
    this.time,
    this.outsideTemp,
    this.isOnline = true,
    this.version = 'v2.4.0',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: const Border(
          top: BorderSide(color: AppColors.darkBorder),
        ),
      ),
      child: Row(
        children: [
          // Left side - time & weather
          Row(
            children: [
              const Icon(
                Icons.refresh,
                size: 12,
                color: AppColors.accentGreen,
              ),
              const SizedBox(width: 6),
              Text(
                time ?? _getCurrentTime(),
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkTextMuted,
                ),
              ),
              if (outsideTemp != null) ...[
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.only(left: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: AppColors.darkBorder),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cloud_outlined,
                        size: 12,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '+$outsideTemp°C',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const Spacer(),

          // Right side - status & version
          Row(
            children: [
              // Online status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isOnline
                      ? AppColors.accentGreen.withValues(alpha: 0.1)
                      : AppColors.accentRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  border: Border.all(
                    color: isOnline
                        ? AppColors.accentGreen.withValues(alpha: 0.2)
                        : AppColors.accentRed.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOnline ? Icons.check_circle : Icons.error,
                      size: 10,
                      color: isOnline ? AppColors.accentGreen : AppColors.accentRed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOnline ? 'ONLINE' : 'OFFLINE',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: isOnline ? AppColors.accentGreen : AppColors.accentRed,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                version,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: AppColors.darkTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }
}
