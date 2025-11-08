/// Enhanced Home Screen State Widgets with Accessibility
///
/// Comprehensive state widgets with loading, error, and empty states
/// Fully accessible with WCAG AA compliance
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart' as ui_kit;
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/utils/accessibility_utils.dart';
import '../../../core/utils/responsive_builder.dart' as core_resp;
import '../../../core/utils/responsive_builder.dart' show ResponsiveInfo;
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/hvac_list/hvac_list_bloc.dart';
import '../../bloc/hvac_list/hvac_list_event.dart';
import '../common/error_widget.dart' as app_error;

/// Enhanced loading state with shimmer effect
class EnhancedHomeLoadingState extends StatelessWidget {
  const EnhancedHomeLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return core_resp.ResponsiveBuilder(
      builder: (context, info) {
        return Padding(
          padding: const EdgeInsets.all(ui_kit.HvacSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header skeleton
              _buildHeaderSkeleton(context),
              const SizedBox(height: ui_kit.HvacSpacing.xl),

              // Room cards skeleton
              _buildRoomCardsSkeleton(context, info),
              const SizedBox(height: ui_kit.HvacSpacing.lg),

              // Quick controls skeleton
              _buildQuickControlsSkeleton(context),

              // Loading indicator
              Expanded(
                child: ui_kit.HvacLoadingState(
                  message: l10n.loadingDevices,
                  style: ui_kit.LoadingStyle.spinner,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(HvacSpacing.xs),
            ),
          ),
          const SizedBox(height: HvacSpacing.xs),
          Container(
            width: 200.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(HvacSpacing.xs),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCardsSkeleton(BuildContext context, ResponsiveInfo info) {
    final cardCount = info.isMobile
        ? 2
        : info.isTablet
            ? 3
            : 4;

    return SizedBox(
      height: 180.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cardCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: HvacSpacing.md),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade800,
              highlightColor: Colors.grey.shade700,
              child: Container(
                width: 150.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(HvacSpacing.md),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickControlsSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return Container(
            width: 60.0,
            height: 60.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}

/// Enhanced error state with better accessibility
class EnhancedHomeErrorState extends StatelessWidget {
  final String message;
  final String? errorCode;

  const EnhancedHomeErrorState({
    super.key,
    required this.message,
    this.errorCode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return app_error.HvacErrorState(
      title: l10n.connectionError,
      message: message,
      errorCode: errorCode,
      errorType: app_error.ErrorType.network,
      onRetry: () {
        AccessibilityUtils.announce('Retrying connection');
        context.read<HvacListBloc>().add(const LoadHvacUnitsEvent());
      },
      additionalActions: [
        app_error.ErrorAction(
          label: l10n.settings,
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
          icon: Icons.settings,
        ),
      ],
      retryLabel: l10n.retry,
    );
  }
}

/// Enhanced empty state with illustrations
class EnhancedHomeEmptyState extends StatelessWidget {
  const EnhancedHomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return core_resp.ResponsiveBuilder(
      builder: (context, info) {
        return HvacEmptyState.noDevices(
          message: 'Start by adding your first HVAC device to control it remotely',
          onAddDevice: () {
            AccessibilityUtils.announce('Opening device addition screen');
            // Navigate to add device screen
            Navigator.pushNamed(context, '/add-device');
          },
        );
      },
    );
  }
}

/// Quick loading indicator for refresh operations
class QuickLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const QuickLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ui_kit.HvacLoadingOverlay(
      isLoading: isLoading,
      message: l10n.refreshing,
      child: child,
    );
  }
}

/// Accessible refresh button
class AccessibleRefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;
  final bool isLoading;

  const AccessibleRefreshButton({
    super.key,
    required this.onRefresh,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return HvacIconButton(
      icon: Icons.refresh,
      onPressed: isLoading ? null : onRefresh,
      tooltip: l10n.refreshDevices,
    );
  }
}

/// State wrapper widget that handles all states
class HomeStateWrapper extends StatelessWidget {
  final Widget Function() buildContent;
  final bool isLoading;
  final bool isEmpty;
  final String? error;
  final String? errorCode;
  final VoidCallback? onRetry;

  const HomeStateWrapper({
    super.key,
    required this.buildContent,
    required this.isLoading,
    required this.isEmpty,
    this.error,
    this.errorCode,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Handle loading state
    if (isLoading) {
      return const EnhancedHomeLoadingState();
    }

    // Handle error state
    if (error != null) {
      return EnhancedHomeErrorState(
        message: error!,
        errorCode: errorCode,
      );
    }

    // Handle empty state
    if (isEmpty) {
      return const EnhancedHomeEmptyState();
    }

    // Show content with animations
    return buildContent().animate().fadeIn(duration: 300.ms);
  }
}
