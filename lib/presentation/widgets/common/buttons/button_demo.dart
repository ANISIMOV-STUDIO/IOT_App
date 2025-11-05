/// Button Components Demo
/// Showcase of all animated button variants with web interactions
library;

import 'package:flutter/material.dart';
import 'animated_button.dart';

class ButtonDemo extends StatelessWidget {
  const ButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Animated Button Components'),
        backgroundColor: HvacColors.backgroundCard,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Primary Buttons',
              [
                AnimatedPrimaryButton(
                  label: 'Get Started',
                  onPressed: () {},
                  icon: Icons.arrow_forward,
                ),
                const SizedBox(height: HvacSpacing.mdR),
                const AnimatedPrimaryButton(
                  label: 'Loading State',
                  onPressed: null,
                  isLoading: true,
                ),
                const SizedBox(height: HvacSpacing.mdR),
                const AnimatedPrimaryButton(
                  label: 'Disabled',
                  onPressed: null,
                ),
                const SizedBox(height: HvacSpacing.mdR),
                AnimatedPrimaryButton(
                  label: 'Full Width',
                  onPressed: () {},
                  isExpanded: true,
                  icon: Icons.check,
                ),
                const SizedBox(height: HvacSpacing.mdR),
                Row(
                  children: [
                    AnimatedPrimaryButton(
                      label: 'Small',
                      onPressed: () {},
                      size: ButtonSize.small,
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    AnimatedPrimaryButton(
                      label: 'Medium',
                      onPressed: () {},
                      size: ButtonSize.medium,
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    AnimatedPrimaryButton(
                      label: 'Large',
                      onPressed: () {},
                      size: ButtonSize.large,
                    ),
                  ],
                ),
              ],
            ),
            _buildSection(
              'Outline Buttons',
              [
                AnimatedOutlineButton(
                  label: 'Learn More',
                  onPressed: () {},
                  icon: Icons.info_outline,
                ),
                const SizedBox(height: HvacSpacing.mdR),
                AnimatedOutlineButton(
                  label: 'Custom Colors',
                  onPressed: () {},
                  borderColor: Colors.green,
                  textColor: Colors.green,
                  icon: Icons.palette,
                ),
                const SizedBox(height: HvacSpacing.mdR),
                const AnimatedOutlineButton(
                  label: 'Loading',
                  onPressed: null,
                  isLoading: true,
                ),
                const SizedBox(height: HvacSpacing.mdR),
                AnimatedOutlineButton(
                  label: 'Full Width Outline',
                  onPressed: () {},
                  isExpanded: true,
                ),
              ],
            ),
            _buildSection(
              'Text Buttons',
              [
                AnimatedTextButton(
                  label: 'Simple Link',
                  onPressed: () {},
                ),
                const SizedBox(height: HvacSpacing.mdR),
                AnimatedTextButton(
                  label: 'With Icon',
                  onPressed: () {},
                  icon: Icons.open_in_new,
                ),
                const SizedBox(height: HvacSpacing.mdR),
                AnimatedTextButton(
                  label: 'No Underline',
                  onPressed: () {},
                  showUnderline: false,
                ),
                const SizedBox(height: HvacSpacing.mdR),
                AnimatedTextButton(
                  label: 'Custom Color',
                  onPressed: () {},
                  textColor: Colors.purple,
                  icon: Icons.color_lens,
                ),
                const SizedBox(height: HvacSpacing.mdR),
                const AnimatedTextButton(
                  label: 'Loading Text Button',
                  onPressed: null,
                  isLoading: true,
                ),
              ],
            ),
            _buildSection(
              'Icon Buttons',
              [
                Row(
                  children: [
                    AnimatedIconButton(
                      icon: Icons.favorite,
                      onPressed: () {},
                      iconColor: Colors.red,
                      tooltip: 'Like',
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    AnimatedIconButton(
                      icon: Icons.share,
                      onPressed: () {},
                      iconColor: Colors.blue,
                      tooltip: 'Share',
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    AnimatedIconButton(
                      icon: Icons.bookmark,
                      onPressed: () {},
                      iconColor: Colors.orange,
                      tooltip: 'Bookmark',
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    AnimatedIconButton(
                      icon: Icons.more_vert,
                      onPressed: () {},
                      backgroundColor: HvacColors.backgroundCardBorder,
                      tooltip: 'More Options',
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    const AnimatedIconButton(
                      icon: Icons.settings,
                      onPressed: null,
                      tooltip: 'Disabled',
                    ),
                  ],
                ),
                const SizedBox(height: HvacSpacing.mdR),
                Row(
                  children: [
                    AnimatedIconButton(
                      icon: Icons.add,
                      onPressed: () {},
                      size: 32.0,
                      tooltip: 'Small',
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    AnimatedIconButton(
                      icon: Icons.add,
                      onPressed: () {},
                      size: 48.0,
                      tooltip: 'Medium',
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    AnimatedIconButton(
                      icon: Icons.add,
                      onPressed: () {},
                      size: 64.0,
                      tooltip: 'Large',
                    ),
                  ],
                ),
              ],
            ),
            _buildSection(
              'Floating Action Buttons',
              [
                Row(
                  children: [
                    AnimatedFAB(
                      icon: Icons.add,
                      onPressed: () {},
                      mini: true,
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    AnimatedFAB(
                      icon: Icons.edit,
                      onPressed: () {},
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    AnimatedFAB(
                      icon: Icons.message,
                      onPressed: () {},
                      label: 'Message',
                      extended: true,
                    ),
                  ],
                ),
                const SizedBox(height: HvacSpacing.mdR),
                Row(
                  children: [
                    AnimatedFAB(
                      icon: Icons.phone,
                      onPressed: () {},
                      backgroundColor: Colors.green,
                      label: 'Call',
                    ),
                    const SizedBox(width: HvacSpacing.mdR),
                    AnimatedFAB(
                      icon: Icons.video_call,
                      onPressed: () {},
                      backgroundColor: Colors.blue,
                      label: 'Video',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HvacSpacing.xlR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: HvacTypography.headlineMedium.copyWith(
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: HvacSpacing.mdR),
          ...children,
        ],
      ),
    );
  }
}