import 'package:flutter/material.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/language_service.dart';
import '../pages/settings/settings_controller.dart';

class ZilonSettingsScreen extends StatefulWidget {
  const ZilonSettingsScreen({super.key});

  @override
  State<ZilonSettingsScreen> createState() => _ZilonSettingsScreenState();
}

class _ZilonSettingsScreenState extends State<ZilonSettingsScreen> {
  SettingsController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _controller = SettingsController(
        onSettingChanged: () => setState(() {}),
        prefs: prefs,
        languageService: sl<LanguageService>(),
      );
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.v24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: AppTypography.displayMedium.copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 24),
              
              // Profile Section
              _buildSection(
                context,
                'Profile',
                _buildProfileCard(context),
              ),
              const SizedBox(height: 24),

              // Appearance
              _buildSection(
                context,
                'Appearance',
                Column(
                  children: [
                    _buildSwitchTile(
                      context,
                      'Dark Mode',
                      'Use dark theme for the interface',
                      Icons.dark_mode,
                      _controller!.darkMode,
                      (v) => _controller!.setDarkMode(v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Preferences
              _buildSection(
                context,
                'Preferences',
                Column(
                  children: [
                    _buildSwitchTile(
                      context,
                      'Use Celsius',
                      'Show temperature in Celsius',
                      Icons.thermostat,
                      _controller!.celsius,
                      (v) => _controller!.setCelsius(v),
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      context,
                      'Push Notifications',
                      'Receive alerts on mobile',
                      Icons.notifications,
                      _controller!.pushNotifications,
                      (v) => _controller!.setPushNotifications(v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

               // Language
              _buildSection(
                context,
                'Language',
                 _buildLanguageSelector(context),
              ),
              
              const SizedBox(height: 48),
              Center(
                child: Text(
                  'Version 2.0.1 (ZILON Build)',
                  style: AppTypography.labelSmall.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.titleMedium.copyWith(color: colorScheme.primary)),
        const SizedBox(height: 12),
        SmartCard(
          padding: EdgeInsets.zero,
          child: child,
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: theme.colorScheme.primary,
            child: Text('A', style: TextStyle(fontSize: 24, color: theme.colorScheme.onPrimary)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin User', style: AppTypography.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
              Text('admin@zilon.com', style: AppTypography.bodyMedium.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
            ],
          ),
          const Spacer(),
          SmartButton(
            label: 'Edit',
             onPressed: () {},
             type: SmartButtonType.secondary,
          )
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, 
    String title, 
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(title, style: AppTypography.titleSmall.copyWith(color: theme.colorScheme.onSurface)),
      subtitle: Text(subtitle, style: AppTypography.bodySmall.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
     return Column(
       children: [
         // System Default Option
         RadioListTile<AppLanguage?>(
           value: null,
           groupValue: _controller!.usingSystemLanguage ? null : _controller!.currentLanguage,
           onChanged: (v) => _controller!.useSystemLanguage(),
           title: Text('System (Auto)'),
           activeColor: Theme.of(context).colorScheme.primary,
         ),
         // Explicit Languages
         ...AppLanguage.values.map((lang) {
           return RadioListTile<AppLanguage?>(
             value: lang,
             groupValue: _controller!.usingSystemLanguage ? null : _controller!.currentLanguage,
             onChanged: (v) {
               if (v != null) _controller!.setLanguage(v);
             },
             title: Text(lang.nativeName),
             activeColor: Theme.of(context).colorScheme.primary,
           );
         }),
       ],
     );
  }
}
