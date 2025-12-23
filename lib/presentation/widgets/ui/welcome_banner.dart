/// Welcome Banner - Gradient hero card with user greeting
library;

import 'package:flutter/material.dart';

import 'app_card.dart';

/// Welcome banner with gradient background
class WelcomeBanner extends StatelessWidget {
  final String userName;
  final String? subtitle;
  final Widget? trailing;

  const WelcomeBanner({
    super.key,
    required this.userName,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Добро пожаловать,',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$userName!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 16),
            trailing!,
          ] else ...[
            const SizedBox(width: 16),
            _DefaultAvatar(userName: userName),
          ],
        ],
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  final String userName;

  const _DefaultAvatar({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: 32,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
