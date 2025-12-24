/// Dashboard Screen - Main BREEZ HVAC control interface
library;

import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/services/theme_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock/mock_data.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../domain/repositories/graph_data_repository.dart';
import '../../../domain/repositories/notification_repository.dart';
import '../../../domain/repositories/schedule_repository.dart';
import '../../widgets/breez/breez.dart';
import 'dialogs/add_unit_dialog.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'widgets/mobile_header.dart';

/// Main dashboard screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeUnitIndex = 0;
  int _sidebarIndex = 0;
  late List<UnitState> _units;
  late ThemeService _themeService;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Repositories
  late ScheduleRepository _scheduleRepository;
  late NotificationRepository _notificationRepository;
  late GraphDataRepository _graphDataRepository;

  // Data from repositories
  List<ScheduleEntry> _schedule = [];
  List<UnitNotification> _notifications = [];
  List<GraphDataPoint> _graphData = [];
  GraphMetric _selectedGraphMetric = GraphMetric.temperature;

  @override
  void initState() {
    super.initState();
    _units = MockData.units.map((u) => UnitState.fromJson(u)).toList();
    _themeService = di.sl<ThemeService>();
    _scheduleRepository = di.sl<ScheduleRepository>();
    _notificationRepository = di.sl<NotificationRepository>();
    _graphDataRepository = di.sl<GraphDataRepository>();
    _loadData();
  }

  Future<void> _loadData() async {
    final deviceId = _units[_activeUnitIndex].id;
    try {
      final results = await Future.wait([
        _scheduleRepository.getSchedule(deviceId),
        _notificationRepository.getNotifications(deviceId: deviceId),
        _graphDataRepository.getGraphData(
          deviceId: deviceId,
          metric: _selectedGraphMetric,
          from: DateTime.now().subtract(const Duration(days: 7)),
          to: DateTime.now(),
        ),
      ]);
      setState(() {
        _schedule = results[0] as List<ScheduleEntry>;
        _notifications = results[1] as List<UnitNotification>;
        _graphData = results[2] as List<GraphDataPoint>;
      });
    } catch (_) {
      // Silently handle errors - data will remain empty
    }
  }

  void _onGraphMetricChanged(GraphMetric? metric) {
    if (metric == null) return;
    setState(() => _selectedGraphMetric = metric);
    _loadGraphData();
  }

  Future<void> _loadGraphData() async {
    final deviceId = _units[_activeUnitIndex].id;
    try {
      final data = await _graphDataRepository.getGraphData(
        deviceId: deviceId,
        metric: _selectedGraphMetric,
        from: DateTime.now().subtract(const Duration(days: 7)),
        to: DateTime.now(),
      );
      setState(() => _graphData = data);
    } catch (_) {}
  }

  UnitState get _currentUnit => _units[_activeUnitIndex];

  void _updateUnit(UnitState Function(UnitState) update) {
    setState(() {
      _units[_activeUnitIndex] = update(_currentUnit);
    });
  }

  void _masterPowerOff() {
    setState(() {
      for (var i = 0; i < _units.length; i++) {
        _units[i] = _units[i].copyWith(power: false);
      }
    });
  }

  Future<void> _showAddUnitDialog() async {
    final name = await AddUnitDialog.show(context);
    if (name != null && name.isNotEmpty) {
      setState(() {
        _units.add(UnitState.create(name: name));
        _activeUnitIndex = _units.length - 1;
      });
    }
  }

  void _toggleTheme() {
    _themeService.toggleTheme();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeService.isDark;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            isDesktop ? _buildDesktopLayout(isDark) : _buildMobileLayout(isDark, width),

            // Compact side panel (mobile/tablet only)
            if (!isDesktop)
              _CompactSidePanel(
                selectedIndex: _sidebarIndex,
                onItemSelected: (index) => setState(() => _sidebarIndex = index),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isDark) {
    return DesktopLayout(
      unit: _currentUnit,
      allUnits: _units,
      selectedUnitIndex: _activeUnitIndex,
      isDark: isDark,
      userName: 'Алексей Б.',
      userRole: 'Админ',
      onTemperatureIncrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
      onTemperatureDecrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
      onSupplyFanChanged: (v) => _updateUnit((u) => u.copyWith(supplyFan: v)),
      onExhaustFanChanged: (v) => _updateUnit((u) => u.copyWith(exhaustFan: v)),
      onModeChanged: (m) => _updateUnit((u) => u.copyWith(mode: m)),
      onPowerToggle: () => _updateUnit((u) => u.copyWith(power: !u.power)),
      onMasterOff: _masterPowerOff,
      onUnitSelected: (index) {
        setState(() => _activeUnitIndex = index);
        _loadData();
      },
      onThemeToggle: _toggleTheme,
      onAddUnit: _showAddUnitDialog,
      schedule: _schedule,
      notifications: _notifications,
      graphData: _graphData,
      selectedGraphMetric: _selectedGraphMetric,
      onGraphMetricChanged: _onGraphMetricChanged,
    );
  }

  Widget _buildMobileLayout(bool isDark, double width) {
    return Column(
      children: [
        // Header with unit tabs
        MobileHeader(
          units: _units,
          selectedUnitIndex: _activeUnitIndex,
          onUnitSelected: (index) {
            setState(() => _activeUnitIndex = index);
            _loadData();
          },
          onAddUnit: _showAddUnitDialog,
          isDark: isDark,
          onThemeToggle: _toggleTheme,
        ),

        // Content
        Expanded(
          child: MobileLayout(
            unit: _currentUnit,
            onTemperatureIncrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
            onTemperatureDecrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
            onSupplyFanChanged: (v) => _updateUnit((u) => u.copyWith(supplyFan: v)),
            onExhaustFanChanged: (v) => _updateUnit((u) => u.copyWith(exhaustFan: v)),
            onModeChanged: (m) => _updateUnit((u) => u.copyWith(mode: m)),
            onPowerToggle: () => _updateUnit((u) => u.copyWith(power: !u.power)),
            compact: width <= 600,
          ),
        ),
      ],
    );
  }
}

/// Compact side panel with blinking handle
class _CompactSidePanel extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;

  const _CompactSidePanel({
    required this.selectedIndex,
    this.onItemSelected,
  });

  @override
  State<_CompactSidePanel> createState() => _CompactSidePanelState();
}

class _CompactSidePanelState extends State<_CompactSidePanel>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _blinkController;

  // Menu items (icons only)
  static const _menuItems = [
    (Icons.dashboard_outlined, 'Панель'),
    (Icons.devices_outlined, 'Устройства'),
    (Icons.schedule_outlined, 'Расписание'),
    (Icons.analytics_outlined, 'Аналитика'),
    (Icons.notifications_outlined, 'Уведомления'),
    (Icons.settings_outlined, 'Настройки'),
  ];

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isPortrait = size.height > size.width;

    // Portrait tablet: bottom panel, Landscape/phone: side panel
    if (isPortrait && size.width > 600) {
      return _buildBottomPanel(size);
    }
    return _buildSidePanel(size);
  }

  Widget _buildSidePanel(Size screenSize) {
    final panelHeight = screenSize.height * 0.5;
    const panelWidth = 56.0;
    const handleWidth = 6.0;

    return Positioned(
      left: 0,
      top: (screenSize.height - panelHeight) / 2,
      child: GestureDetector(
        onTap: () => setState(() => _isOpen = !_isOpen),
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            setState(() => _isOpen = details.primaryVelocity! > 0);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
            _isOpen ? 0 : -panelWidth,
            0,
            0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPanelContainer(
                width: panelWidth,
                height: panelHeight,
                isVertical: true,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              _buildHandle(handleWidth, panelHeight * 0.4, isVertical: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(Size screenSize) {
    final panelWidth = screenSize.width * 0.6;
    const panelHeight = 56.0;
    const handleHeight = 6.0;

    return Positioned(
      bottom: 0,
      left: (screenSize.width - panelWidth) / 2,
      child: GestureDetector(
        onTap: () => setState(() => _isOpen = !_isOpen),
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            setState(() => _isOpen = details.primaryVelocity! < 0);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
            0,
            _isOpen ? 0 : panelHeight,
            0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(panelWidth * 0.3, handleHeight, isVertical: false),
              _buildPanelContainer(
                width: panelWidth,
                height: panelHeight,
                isVertical: false,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanelContainer({
    required double width,
    required double height,
    required bool isVertical,
    required BorderRadius borderRadius,
  }) {
    final colors = BreezColors.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: borderRadius,
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: isVertical ? const Offset(2, 0) : const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: isVertical ? 12 : 8,
        horizontal: isVertical ? 8 : 12,
      ),
      child: isVertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildMenuItems(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildMenuItems(),
            ),
    );
  }

  List<Widget> _buildMenuItems() {
    final colors = BreezColors.of(context);
    return _menuItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == widget.selectedIndex;
      return Tooltip(
        message: item.$2,
        preferBelow: false,
        child: GestureDetector(
          onTap: () {
            widget.onItemSelected?.call(index);
            setState(() => _isOpen = false);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.$1,
              size: 20,
              color: isSelected ? AppColors.accent : colors.textMuted,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildHandle(double width, double height, {required bool isVertical}) {
    return AnimatedBuilder(
      animation: _blinkController,
      builder: (context, child) {
        final opacity = _isOpen ? 0.6 : (0.15 + _blinkController.value * 0.25);
        return CustomPaint(
          size: Size(width, height),
          painter: _BracketPainter(
            color: AppColors.accent.withValues(alpha: opacity),
            isVertical: isVertical,
          ),
        );
      },
    );
  }
}

/// Paints a curly bracket shape
class _BracketPainter extends CustomPainter {
  final Color color;
  final bool isVertical;

  _BracketPainter({required this.color, required this.isVertical});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    if (isVertical) {
      // Vertical bracket pointing right }
      final midY = h / 2;
      path.moveTo(0, 0);
      path.quadraticBezierTo(w * 0.8, 0, w * 0.8, h * 0.15);
      path.quadraticBezierTo(w * 0.8, h * 0.35, w * 0.3, h * 0.4);
      path.quadraticBezierTo(0, midY * 0.95, 0, midY);
      path.quadraticBezierTo(0, midY * 1.05, w * 0.3, h * 0.6);
      path.quadraticBezierTo(w * 0.8, h * 0.65, w * 0.8, h * 0.85);
      path.quadraticBezierTo(w * 0.8, h, 0, h);
    } else {
      // Horizontal bracket pointing up ⌢
      final midX = w / 2;
      path.moveTo(0, h);
      path.quadraticBezierTo(0, h * 0.2, w * 0.15, h * 0.2);
      path.quadraticBezierTo(w * 0.35, h * 0.2, w * 0.4, h * 0.7);
      path.quadraticBezierTo(midX * 0.95, h, midX, h);
      path.quadraticBezierTo(midX * 1.05, h, w * 0.6, h * 0.7);
      path.quadraticBezierTo(w * 0.65, h * 0.2, w * 0.85, h * 0.2);
      path.quadraticBezierTo(w, h * 0.2, w, h);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BracketPainter oldDelegate) =>
      color != oldDelegate.color || isVertical != oldDelegate.isVertical;
}
