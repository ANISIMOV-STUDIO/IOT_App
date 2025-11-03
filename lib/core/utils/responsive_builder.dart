import 'package:flutter/material.dart';

/// Responsive builder for adaptive layouts
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
  ) builder;
  final BreakpointConfig? breakpoints;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final info = ResponsiveInfo(
          deviceType: _getDeviceType(constraints.maxWidth),
          screenSize: Size(constraints.maxWidth, constraints.maxHeight),
          orientation: MediaQuery.of(context).orientation,
          breakpoints: breakpoints ?? BreakpointConfig.defaultConfig,
        );
        return builder(context, info);
      },
    );
  }

  DeviceType _getDeviceType(double width) {
    final config = breakpoints ?? BreakpointConfig.defaultConfig;

    if (width < config.mobile) {
      return DeviceType.mobile;
    } else if (width < config.tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }
}

/// Responsive layout widget with different layouts for each breakpoint
/// Mobile and tablet only - no desktop support
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final BreakpointConfig? breakpoints;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        switch (info.deviceType) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.desktop:
            return tablet ?? mobile;
        }
      },
    );
  }
}

/// Responsive value widget that returns different values based on screen size
/// Mobile and tablet only - no desktop support
class ResponsiveValue<T> extends StatelessWidget {
  final T mobile;
  final T? tablet;
  final Widget Function(BuildContext context, T value) builder;
  final BreakpointConfig? breakpoints;

  const ResponsiveValue({
    super.key,
    required this.mobile,
    this.tablet,
    required this.builder,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final value = _getValue(info.deviceType);
        return builder(context, value);
      },
    );
  }

  T _getValue(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return tablet ?? mobile;
    }
  }
}

/// Responsive grid widget with adaptive column count
/// Mobile and tablet only - no desktop support
class ResponsiveGrid extends StatelessWidget {
  final int mobileColumns;
  final int? tabletColumns;
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final BreakpointConfig? breakpoints;

  const ResponsiveGrid({
    super.key,
    required this.mobileColumns,
    this.tabletColumns,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final columns = _getColumnCount(info.deviceType);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: 1.0,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }

  int _getColumnCount(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return mobileColumns;
      case DeviceType.tablet:
        return tabletColumns ?? mobileColumns + 1;
      case DeviceType.desktop:
        return tabletColumns ?? mobileColumns + 2;
    }
  }
}

/// Responsive padding with different values for each breakpoint
/// Mobile and tablet only - no desktop support
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets mobile;
  final EdgeInsets? tablet;
  final BreakpointConfig? breakpoints;

  const ResponsivePadding({
    super.key,
    required this.child,
    required this.mobile,
    this.tablet,
    this.breakpoints,
  });

  factory ResponsivePadding.all({
    required Widget child,
    required double mobile,
    double? tablet,
    BreakpointConfig? breakpoints,
  }) {
    return ResponsivePadding(
      mobile: EdgeInsets.all(mobile),
      tablet: tablet != null ? EdgeInsets.all(tablet) : null,
      breakpoints: breakpoints,
      child: child,
    );
  }

  factory ResponsivePadding.symmetric({
    required Widget child,
    double? mobileHorizontal,
    double? mobileVertical,
    double? tabletHorizontal,
    double? tabletVertical,
    BreakpointConfig? breakpoints,
  }) {
    return ResponsivePadding(
      mobile: EdgeInsets.symmetric(
        horizontal: mobileHorizontal ?? 0,
        vertical: mobileVertical ?? 0,
      ),
      tablet: (tabletHorizontal != null || tabletVertical != null)
          ? EdgeInsets.symmetric(
              horizontal: tabletHorizontal ?? 0,
              vertical: tabletVertical ?? 0,
            )
          : null,
      breakpoints: breakpoints,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final padding = _getPadding(info.deviceType);
        return Padding(
          padding: padding,
          child: child,
        );
      },
    );
  }

  EdgeInsets _getPadding(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return tablet ?? mobile;
    }
  }
}

/// Responsive visibility widget that shows/hides based on screen size
/// Mobile and tablet only - no desktop support
class ResponsiveVisibility extends StatelessWidget {
  final Widget child;
  final bool visibleOnMobile;
  final bool visibleOnTablet;
  final Widget? replacement;
  final BreakpointConfig? breakpoints;

  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.visibleOnMobile = true,
    this.visibleOnTablet = true,
    this.replacement,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final isVisible = _isVisible(info.deviceType);
        if (isVisible) {
          return child;
        }
        return replacement ?? const SizedBox.shrink();
      },
    );
  }

  bool _isVisible(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return visibleOnMobile;
      case DeviceType.tablet:
        return visibleOnTablet;
      case DeviceType.desktop:
        return visibleOnTablet;
    }
  }
}

/// Responsive text with different styles for each breakpoint
/// Mobile and tablet only - no desktop support
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? mobileStyle;
  final TextStyle? tabletStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final BreakpointConfig? breakpoints;

  const ResponsiveText(
    this.text, {
    super.key,
    this.mobileStyle,
    this.tabletStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final style = _getTextStyle(info.deviceType);
        return Text(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }

  TextStyle? _getTextStyle(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return mobileStyle;
      case DeviceType.tablet:
        return tabletStyle ?? mobileStyle;
      case DeviceType.desktop:
        return tabletStyle ?? mobileStyle;
    }
  }
}

/// Information about the current responsive state
class ResponsiveInfo {
  final DeviceType deviceType;
  final Size screenSize;
  final Orientation orientation;
  final BreakpointConfig breakpoints;

  const ResponsiveInfo({
    required this.deviceType,
    required this.screenSize,
    required this.orientation,
    required this.breakpoints,
  });

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  double get width => screenSize.width;
  double get height => screenSize.height;
  double get aspectRatio => width / height;
}

/// Device type enumeration
/// Full responsive support: mobile, tablet, and desktop
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Breakpoint configuration
class BreakpointConfig {
  final double mobile;
  final double tablet;
  final double desktop;

  const BreakpointConfig({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  static const BreakpointConfig defaultConfig = BreakpointConfig(
    mobile: 600,
    tablet: 1024,
    desktop: 1440,
  );

  static const BreakpointConfig material3 = BreakpointConfig(
    mobile: 600,
    tablet: 840,
    desktop: 1240,
  );

  static const BreakpointConfig bootstrap = BreakpointConfig(
    mobile: 576,
    tablet: 768,
    desktop: 1200,
  );
}

/// Responsive extensions for BuildContext
extension ResponsiveExtensions on BuildContext {
  ResponsiveInfo get responsive {
    final size = MediaQuery.of(this).size;
    final orientation = MediaQuery.of(this).orientation;
    const config = BreakpointConfig.defaultConfig;

    DeviceType type;
    if (size.width < config.mobile) {
      type = DeviceType.mobile;
    } else if (size.width < config.tablet) {
      type = DeviceType.tablet;
    } else {
      type = DeviceType.desktop;
    }

    return ResponsiveInfo(
      deviceType: type,
      screenSize: size,
      orientation: orientation,
      breakpoints: config,
    );
  }

  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;
  bool get isPortrait => responsive.isPortrait;
  bool get isLandscape => responsive.isLandscape;
}