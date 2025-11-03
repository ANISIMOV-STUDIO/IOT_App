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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() => _rememberMe = !_rememberMe);
          widget.onRememberMeChanged(_rememberMe);
        },
        child: Row(
          children: [
            SizedBox(
              width: 24.rw(context),
              height: 24.rh(context),
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() => _rememberMe = value ?? false);
                  widget.onRememberMeChanged(_rememberMe);
                },
                activeColor: HvacColors.primaryOrange,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: 8.rw(context)),
            Text(
              'Remember me',
              style: TextStyle(
                fontSize: (14 * responsive.fontMultiplier).rsp(context),
                color: HvacColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptTerms(
    BuildContext context,
    AuthResponsive responsive,
    ThemeData theme,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() => _acceptTerms = !_acceptTerms);
          widget.onAcceptTermsChanged(_acceptTerms);
        },
        child: Row(
          children: [
            SizedBox(
              width: 24.rw(context),
              height: 24.rh(context),
              child: Checkbox(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() => _acceptTerms = value ?? false);
                  widget.onAcceptTermsChanged(_acceptTerms);
                },
                activeColor: HvacColors.primaryOrange,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: 8.rw(context)),
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
        ),
      ),
    );
  }

  bool get acceptTerms => _acceptTerms;
  bool get rememberMe => _rememberMe;
}