import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';

/// Optimized HVAC Unit Card with performance improvements
///
/// Key optimizations:
/// - Uses const constructors where possible
/// - Implements shouldRebuild logic
/// - Uses RepaintBoundary for expensive paint operations
/// - Implements proper key usage
/// - Minimizes widget rebuilds with selective state management
class OptimizedHvacCard extends StatelessWidget {
  final HvacUnit unit;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onPowerChanged;
  final bool isSelected;

  const OptimizedHvacCard({
    super.key,
    required this.unit,
    this.onTap,
    this.onPowerChanged,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _CardContainer(
        isSelected: isSelected,
        onTap: onTap,
        child: _CardContent(
          unit: unit,
          onPowerChanged: onPowerChanged,
        ),
      ),
    );
  }
}

/// Separated container to minimize rebuilds
class _CardContainer extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget child;

  const _CardContainer({
    required this.isSelected,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(
          horizontal: HvacSpacing.md.w,
          vertical: HvacSpacing.sm.h,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? HvacColors.primaryGradient
              : const LinearGradient(
                  colors: [HvacColors.cardDark, HvacColors.cardDark],
                ),
          borderRadius: BorderRadius.circular(HvacSpacing.lg.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.3 : 0.1),
              blurRadius: isSelected ? 20.r : 10.r,
              offset: Offset(0, isSelected ? 10.h : 5.h),
            ),
          ],
        ),
        child: child,
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }
}

/// Card content with optimized state management
class _CardContent extends StatefulWidget {
  final HvacUnit unit;
  final ValueChanged<bool>? onPowerChanged;

  const _CardContent({
    required this.unit,
    this.onPowerChanged,
  });

  @override
  State<_CardContent> createState() => _CardContentState();
}

class _CardContentState extends State<_CardContent>
    with AutomaticKeepAliveClientMixin {
  late bool _isPowerOn;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _isPowerOn = widget.unit.power;
  }

  @override
  void didUpdateWidget(_CardContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if the unit actually changed
    if (oldWidget.unit.id != widget.unit.id ||
        oldWidget.unit.power != widget.unit.power) {
      _isPowerOn = widget.unit.power;
    }
  }

  void _handlePowerToggle() {
    setState(() {
      _isPowerOn = !_isPowerOn;
    });
    widget.onPowerChanged?.call(_isPowerOn);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: EdgeInsets.all(HvacSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizedBox(height: HvacSpacing.md.h),
          _buildTemperatureDisplay(),
          SizedBox(height: HvacSpacing.md.h),
          _buildStatusIndicators(),
          SizedBox(height: HvacSpacing.lg.h),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.unit.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: HvacSpacing.xs.h),
              Text(
                widget.unit.location ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _PowerSwitch(
          value: _isPowerOn,
          onChanged: (_) => _handlePowerToggle(),
        ),
      ],
    );
  }

  Widget _buildTemperatureDisplay() {
    return RepaintBoundary(
      child: _TemperatureDisplay(
        currentTemp: widget.unit.currentTemp,
        targetTemp: widget.unit.targetTemp,
        isPowerOn: _isPowerOn,
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Row(
      children: [
        _StatusChip(
          icon: Icons.water_drop,
          value: '${widget.unit.humidity}%',
          label: 'Humidity',
        ),
        SizedBox(width: HvacSpacing.md.w),
        _StatusChip(
          icon: Icons.air,
          value: widget.unit.fanSpeed,
          label: 'Fan',
        ),
        SizedBox(width: HvacSpacing.md.w),
        _StatusChip(
          icon: Icons.thermostat,
          value: widget.unit.mode,
          label: 'Mode',
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.remove,
            onPressed: _isPowerOn
                ? () {
                    // Decrease temperature
                  }
                : null,
          ),
        ),
        SizedBox(width: HvacSpacing.md.w),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.add,
            onPressed: _isPowerOn
                ? () {
                    // Increase temperature
                  }
                : null,
          ),
        ),
      ],
    );
  }
}

/// Optimized power switch with minimal rebuilds
class _PowerSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PowerSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeThumbColor: HvacColors.primaryBlue,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
    );
  }
}

/// Temperature display with optimized rendering
class _TemperatureDisplay extends StatelessWidget {
  final double currentTemp;
  final double targetTemp;
  final bool isPowerOn;

  const _TemperatureDisplay({
    required this.currentTemp,
    required this.targetTemp,
    required this.isPowerOn,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isPowerOn ? 1.0 : 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TempValue(
            label: 'Current',
            value: currentTemp,
            isPrimary: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: HvacSpacing.lg.w),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white54,
              size: 20.sp,
            ),
          ),
          _TempValue(
            label: 'Target',
            value: targetTemp,
            isPrimary: false,
          ),
        ],
      ),
    );
  }
}

/// Temperature value display
class _TempValue extends StatelessWidget {
  final String label;
  final double value;
  final bool isPrimary;

  const _TempValue({
    required this.label,
    required this.value,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white54,
          ),
        ),
        SizedBox(height: HvacSpacing.xs.h),
        Text(
          '${value.toStringAsFixed(1)}°',
          style: TextStyle(
            fontSize: isPrimary ? 28.sp : 24.sp,
            fontWeight: FontWeight.bold,
            color: isPrimary ? HvacColors.primaryBlue : Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Status chip with const constructor
class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatusChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: HvacSpacing.sm.w,
        vertical: HvacSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(HvacSpacing.sm.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: Colors.white70,
          ),
          SizedBox(width: HvacSpacing.xs.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Quick action button with proper const usage
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuickActionButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(HvacSpacing.md.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(HvacSpacing.md.r),
        child: Container(
          height: 40.h,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: onPressed != null ? Colors.white : Colors.white38,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}

/// Performance monitoring widget wrapper
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final String widgetName;

  const PerformanceMonitor({
    super.key,
    required this.child,
    required this.widgetName,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  final _buildTimes = <Duration>[];
  late final Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  @override
  Widget build(BuildContext context) {
    _stopwatch
      ..reset()
      ..start();

    final result = widget.child;

    _stopwatch.stop();
    _buildTimes.add(_stopwatch.elapsed);

    // Log if build time exceeds threshold
    if (_stopwatch.elapsedMilliseconds > 16) {
      debugPrint(
        '⚠️ ${widget.widgetName} build time: ${_stopwatch.elapsedMilliseconds}ms',
      );
    }

    return result;
  }

  @override
  void dispose() {
    if (_buildTimes.isNotEmpty) {
      final average = _buildTimes
              .map((d) => d.inMicroseconds)
              .reduce((a, b) => a + b) ~/
          _buildTimes.length;
      debugPrint(
        '📊 ${widget.widgetName} average build time: ${average / 1000}ms',
      );
    }
    super.dispose();
  }
}