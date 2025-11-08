/// Authentication Checkbox Section Widget
///
/// Handles Remember Me and Terms acceptance checkboxes
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import 'responsive_utils.dart';

class AuthCheckboxSection extends StatefulWidget {
  final bool isLoginMode;
  final ValueChanged<bool> onRememberMeChanged;
  final ValueChanged<bool> onAcceptTermsChanged;

  const AuthCheckboxSection({
    super.key,
    required this.isLoginMode,
    required this.onRememberMeChanged,
    required this.onAcceptTermsChanged,
  });

  @override
  State<AuthCheckboxSection> createState() => AuthCheckboxSectionState();
}

class AuthCheckboxSectionState extends State<AuthCheckboxSection> {
  bool _rememberMe = false;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    final responsive = AuthResponsive(context);
    final theme = Theme.of(context);

    if (widget.isLoginMode) {
      return _buildRememberMe(context, responsive);
    } else {
      return _buildAcceptTerms(context, responsive, theme);
    }
  }

  Widget _buildRememberMe(BuildContext context, AuthResponsive responsive) {
    return HvacCheckbox(
      value: _rememberMe,
      onChanged: (value) {
        setState(() => _rememberMe = value ?? false);
        widget.onRememberMeChanged(_rememberMe);
      },
      label: 'Remember me',
    );
  }

  Widget _buildAcceptTerms(
    BuildContext context,
    AuthResponsive responsive,
    ThemeData theme,
  ) {
    return Row(
      children: [
        HvacCheckbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() => _acceptTerms = value ?? false);
            widget.onAcceptTermsChanged(_acceptTerms);
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: (14 * responsive.fontMultiplier).rsp(context),
              ),
              children: [
                const TextSpan(text: 'I accept the '),
                TextSpan(
                  text: 'Terms and Conditions',
                  style: TextStyle(
                    color: HvacColors.primaryOrange,
                    decoration: TextDecoration.underline,
                    fontSize: (14 * responsive.fontMultiplier).rsp(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool get acceptTerms => _acceptTerms;
  bool get rememberMe => _rememberMe;
}
