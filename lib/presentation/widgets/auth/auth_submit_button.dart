/// Authentication Submit Button Component
///
/// Primary submit button with loading state and hover effects
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import 'responsive_utils.dart';

class AuthSubmitButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthSubmitButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<AuthSubmitButton> createState() => _AuthSubmitButtonState();
}

class _AuthSubmitButtonState extends State<AuthSubmitButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final responsive = AuthResponsive(context);
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return MouseRegion(
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: responsive.buttonHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDisabled
                  ? [Colors.grey.shade400, Colors.grey.shade500]
                  : _isPressed
                      ? [
                          HvacColors.primaryOrange.withAlpha(204),
                          HvacColors.primaryOrangeLight.withAlpha(204),
                        ]
                      : _isHovered
                          ? [
                              HvacColors.primaryOrange,
                              HvacColors.primaryOrangeLight,
                            ]
                          : [
                              HvacColors.primaryOrangeLight,
                              HvacColors.primaryOrange,
                            ],
            ),
            borderRadius: HvacRadius.mdRadius,
            boxShadow: [
              if (!isDisabled && (_isHovered || _isPressed))
                BoxShadow(
                  color: HvacColors.primaryOrange.withAlpha(76),
                  blurRadius: _isPressed ? 12.rw(context) : 16.rw(context),
                  offset: Offset(0, _isPressed ? 2.rh(context) : 4.rh(context)),
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : widget.onPressed,
              borderRadius: HvacRadius.mdRadius,
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 24.rw(context),
                        height: 24.rh(context),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (16 * responsive.fontMultiplier).rsp(context),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    ).animate().scale(
          duration: 100.ms,
          begin: const Offset(1.0, 1.0),
          end: _isPressed ? const Offset(0.98, 0.98) : const Offset(1.0, 1.0),
        );
  }
}