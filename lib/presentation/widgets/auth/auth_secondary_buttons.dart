/// Authentication Secondary Button Components
///
/// Outline and text buttons with hover states
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import 'responsive_utils.dart';

class AuthOutlineButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AuthOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  State<AuthOutlineButton> createState() => _AuthOutlineButtonState();
}

class _AuthOutlineButtonState extends State<AuthOutlineButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final responsive = AuthResponsive(context);

    return MouseRegion(
      cursor: widget.onPressed == null
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: responsive.buttonHeight,
        decoration: BoxDecoration(
          color: _isHovered
              ? HvacColors.primaryOrange.withAlpha(13)
              : Colors.transparent,
          borderRadius: HvacRadius.mdRadius,
          border: Border.all(
            color: _isHovered ? HvacColors.primaryOrange : HvacColors.backgroundCardBorder,
            width: (_isHovered ? 2 : 1).rw(context),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: HvacRadius.mdRadius,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: (20 * responsive.fontMultiplier).rsp(context),
                      color: _isHovered
                          ? HvacColors.primaryOrange
                          : HvacColors.textSecondary,
                    ),
                    SizedBox(width: 8.rw(context)),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: _isHovered
                          ? HvacColors.primaryOrange
                          : HvacColors.textPrimary,
                      fontSize: (15 * responsive.fontMultiplier).rsp(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthTextButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AuthTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  State<AuthTextButton> createState() => _AuthTextButtonState();
}

class _AuthTextButtonState extends State<AuthTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final responsive = AuthResponsive(context);

    return MouseRegion(
      cursor: widget.onPressed == null
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: HvacColors.primaryOrange,
          padding: EdgeInsets.symmetric(
            horizontal: 16.rw(context),
            vertical: 12.rh(context),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: HvacRadius.smRadius,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                size: (18 * responsive.fontMultiplier).rsp(context),
                color: _isHovered
                    ? HvacColors.primaryOrange
                    : HvacColors.textSecondary,
              ),
              SizedBox(width: 8.rw(context)),
            ],
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: _isHovered
                    ? HvacColors.primaryOrange
                    : HvacColors.textSecondary,
                fontSize: (14 * responsive.fontMultiplier).rsp(context),
                decoration: _isHovered ? TextDecoration.underline : null,
              ),
              child: Text(widget.text),
            ),
          ],
        ),
      ),
    );
  }
}