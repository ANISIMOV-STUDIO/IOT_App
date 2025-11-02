/// Settings Screen
///
/// App settings including theme, language, units, and preferences
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _celsius = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _language = 'Русский';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundCard,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Настройки',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: ResponsiveUtils.isMobile(context)
              ? _buildMobileLayout()
              : _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildAppearanceSection(),
        SizedBox(height: 20.h),
        _buildUnitsSection(),
        SizedBox(height: 20.h),
        _buildNotificationsSection(),
        SizedBox(height: 20.h),
        _buildLanguageSection(),
        SizedBox(height: 20.h),
        _buildAboutSection(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildAppearanceSection()),
            SizedBox(width: 20.w),
            Expanded(child: _buildUnitsSection()),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildNotificationsSection()),
            SizedBox(width: 20.w),
            Expanded(child: _buildLanguageSection()),
          ],
        ),
        SizedBox(height: 20.h),
        _buildAboutSection(),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return _buildSection(
      title: 'Внешний вид',
      icon: Icons.palette_outlined,
      children: [
        _buildSwitchTile(
          title: 'Темная тема',
          subtitle: 'Использовать темную цветовую схему',
          value: _darkMode,
          onChanged: (value) {
            setState(() => _darkMode = value);
            _showSnackBar('Смена темы будет доступна в следующей версии');
          },
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildUnitsSection() {
    return _buildSection(
      title: 'Единицы измерения',
      icon: Icons.straighten_outlined,
      children: [
        _buildSwitchTile(
          title: 'Температура',
          subtitle: _celsius ? 'Цельсий (°C)' : 'Фаренгейт (°F)',
          value: _celsius,
          onChanged: (value) {
            setState(() => _celsius = value);
            _showSnackBar(
                'Единицы изменены на ${value ? "Цельсий" : "Фаренгейт"}');
          },
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildNotificationsSection() {
    return _buildSection(
      title: 'Уведомления',
      icon: Icons.notifications_outlined,
      children: [
        _buildSwitchTile(
          title: 'Push-уведомления',
          subtitle: 'Получать мгновенные уведомления',
          value: _pushNotifications,
          onChanged: (value) {
            setState(() => _pushNotifications = value);
            _showSnackBar(
                'Push-уведомления ${value ? "включены" : "выключены"}');
          },
        ),
        SizedBox(height: 12.h),
        _buildSwitchTile(
          title: 'Email-уведомления',
          subtitle: 'Получать отчеты на email',
          value: _emailNotifications,
          onChanged: (value) {
            setState(() => _emailNotifications = value);
            _showSnackBar(
                'Email-уведомления ${value ? "включены" : "выключены"}');
          },
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildLanguageSection() {
    return _buildSection(
      title: 'Язык',
      icon: Icons.language_outlined,
      children: [
        _buildLanguageTile('Русский'),
        SizedBox(height: 8.h),
        _buildLanguageTile('English'),
        SizedBox(height: 8.h),
        _buildLanguageTile('Deutsch'),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'О приложении',
      icon: Icons.info_outline,
      children: [
        _buildInfoRow('Версия', '1.0.0'),
        SizedBox(height: 12.h),
        _buildInfoRow('Разработчик', 'HVAC Control Team'),
        SizedBox(height: 12.h),
        _buildInfoRow('Лицензия', 'MIT License'),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _showSnackBar('Проверка обновлений...');
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.primaryOrange),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Проверить обновления',
              style: TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryOrange, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppTheme.primaryOrange,
          activeTrackColor: AppTheme.primaryOrange.withValues(alpha: 0.5),
          inactiveThumbColor: AppTheme.textSecondary,
          inactiveTrackColor: AppTheme.backgroundCardBorder,
        ),
      ],
    );
  }

  Widget _buildLanguageTile(String language) {
    final isSelected = _language == language;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() => _language = language);
          _showSnackBar('Язык изменен на $language');
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                : AppTheme.backgroundDark,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryOrange
                  : AppTheme.backgroundCardBorder,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? AppTheme.primaryOrange : AppTheme.textSecondary,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                language,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppTheme.primaryOrange : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
