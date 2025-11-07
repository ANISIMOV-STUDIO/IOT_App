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
        padding: EdgeInsets.all(HvacSpacing.md),
        children: [
          Text('Tap to see micro-interactions:',
               style: TextStyle(color: HvacColors.textSecondary)),
          SizedBox(height: HvacSpacing.lg),

          // Scale animation
          Text('Scale on Press:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: HvacSpacing.sm),
          HvacInteractiveScale(
            onTap: () => _showMessage('Scale pressed'),
            child: _buildCard('Tap me - I scale down!'),
          ),
          SizedBox(height: HvacSpacing.lg),

          // Opacity animation
          Text('Opacity on Press:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: HvacSpacing.sm),
          HvacInteractiveOpacity(
            onTap: () => _showMessage('Opacity pressed'),
            child: _buildCard('Tap me - I fade!'),
          ),
          SizedBox(height: HvacSpacing.lg),

          // Ripple effect
          Text('Ripple Effect:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: HvacSpacing.sm),
          HvacInteractiveRipple(
            onTap: () => _showMessage('Ripple pressed'),
            child: _buildCard('Tap me - I ripple!'),
          ),
          SizedBox(height: HvacSpacing.lg),

          // Bouncy button
          Text('Bouncy Animation:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: HvacSpacing.sm),
          HvacBouncyButton(
            onTap: () => _showMessage('Bouncy pressed'),
            child: _buildButton('Tap me - I bounce!'),
          ),
          SizedBox(height: HvacSpacing.lg),

          // Shake animation
          Text('Shake on Error:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: HvacSpacing.sm),
          HvacShakeAnimation(
            trigger: _shakeError,
            child: _buildCard('Shake animation (press button below)'),
          ),
          SizedBox(height: HvacSpacing.sm),
          ElevatedButton(
            onPressed: () {
              setState(() => _shakeError = true);
              Future.delayed(Duration(milliseconds: 100), () {
                setState(() => _shakeError = false);
              });
            },
            child: Text('Trigger Shake'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String text) {
    return Container(
      padding: EdgeInsets.all(HvacSpacing.lg),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder),
      ),
      child: Center(child: Text(text, style: TextStyle(fontSize: 16))),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: HvacSpacing.xl,
        vertical: HvacSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [HvacColors.primaryOrange, HvacColors.primaryOrangeDark],
        ),
        borderRadius: HvacRadius.mdRadius,
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }
}
