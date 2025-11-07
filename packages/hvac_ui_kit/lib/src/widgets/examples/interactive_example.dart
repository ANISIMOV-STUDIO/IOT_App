/// Example usage of HvacInteractive widgets
library;

import 'package:flutter/material.dart';
import '../hvac_interactive.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

class InteractiveExample extends StatefulWidget {
  const InteractiveExample({super.key});

  @override
  State<InteractiveExample> createState() => _InteractiveExampleState();
}

class _InteractiveExampleState extends State<InteractiveExample> {
  bool _shakeError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(title: const Text('Interactive Animations')),
      body: ListView(
        padding: const EdgeInsets.all(HvacSpacing.md),
        children: [
          const Text('Tap to see micro-interactions:',
               style: TextStyle(color: HvacColors.textSecondary)),
          const SizedBox(height: HvacSpacing.lg),

          // Scale animation
          const Text('Scale on Press:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: HvacSpacing.sm),
          HvacInteractiveScale(
            onTap: () => _showMessage('Scale pressed'),
            child: _buildCard('Tap me - I scale down!'),
          ),
          const SizedBox(height: HvacSpacing.lg),

          // Opacity animation
          const Text('Opacity on Press:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: HvacSpacing.sm),
          HvacInteractiveOpacity(
            onTap: () => _showMessage('Opacity pressed'),
            child: _buildCard('Tap me - I fade!'),
          ),
          const SizedBox(height: HvacSpacing.lg),

          // Ripple effect
          const Text('Ripple Effect:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: HvacSpacing.sm),
          HvacInteractiveRipple(
            onTap: () => _showMessage('Ripple pressed'),
            child: _buildCard('Tap me - I ripple!'),
          ),
          const SizedBox(height: HvacSpacing.lg),

          // Bouncy button
          const Text('Bouncy Animation:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: HvacSpacing.sm),
          HvacBouncyButton(
            onTap: () => _showMessage('Bouncy pressed'),
            child: _buildButton('Tap me - I bounce!'),
          ),
          const SizedBox(height: HvacSpacing.lg),

          // Shake animation
          const Text('Shake on Error:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: HvacSpacing.sm),
          HvacShakeAnimation(
            trigger: _shakeError,
            child: _buildCard('Shake animation (press button below)'),
          ),
          const SizedBox(height: HvacSpacing.sm),
          ElevatedButton(
            onPressed: () {
              setState(() => _shakeError = true);
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() => _shakeError = false);
              });
            },
            child: const Text('Trigger Shake'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String text) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.lg),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder),
      ),
      child: Center(child: Text(text, style: const TextStyle(fontSize: 16))),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HvacSpacing.xl,
        vertical: HvacSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [HvacColors.primaryOrange, HvacColors.primaryOrangeDark],
        ),
        borderRadius: HvacRadius.mdRadius,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}
