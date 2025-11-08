/// Web Keyboard Shortcuts - Keyboard navigation and shortcuts for web platform
///
/// Provides comprehensive keyboard navigation support optimized for web
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keyboard shortcuts manager for web platform
class HvacKeyboardShortcuts extends StatelessWidget {
  final Widget child;
  final Map<LogicalKeySet, VoidCallback>? customShortcuts;
  final bool enableDefaultShortcuts;

  const HvacKeyboardShortcuts({
    super.key,
    required this.child,
    this.customShortcuts,
    this.enableDefaultShortcuts = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    final shortcuts = <LogicalKeySet, Intent>{
      if (enableDefaultShortcuts) ..._getDefaultShortcuts(context),
      if (customShortcuts != null)
        ...customShortcuts!.map(
          (key, value) => MapEntry(key, CallbackIntent(value)),
        ),
    };

    final actions = <Type, Action<Intent>>{
      CallbackIntent: CallbackAction(onInvoke: (intent) {
        (intent as CallbackIntent).callback();
        return null;
      }),
    };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }

  Map<LogicalKeySet, Intent> _getDefaultShortcuts(BuildContext context) {
    return {
      // Navigation
      LogicalKeySet(LogicalKeyboardKey.escape):
          CallbackIntent(() => Navigator.maybePop(context)),

      // Search
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
          CallbackIntent(() => _triggerSearch(context)),

      // Refresh
      LogicalKeySet(LogicalKeyboardKey.f5):
          CallbackIntent(() => _refresh(context)),

      // Settings
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.comma):
          CallbackIntent(() => _openSettings(context)),
    };
  }

  void _triggerSearch(BuildContext context) {
    // Implement search functionality
    debugPrint('Search triggered (Ctrl+F)');
  }

  void _refresh(BuildContext context) {
    // Implement refresh functionality
    debugPrint('Refresh triggered (F5)');
  }

  void _openSettings(BuildContext context) {
    // Navigate to settings
    debugPrint('Settings triggered (Ctrl+,)');
  }
}

/// Custom intent for callback-based shortcuts
class CallbackIntent extends Intent {
  final VoidCallback callback;

  const CallbackIntent(this.callback);
}

/// Focusable container with keyboard navigation
class HvacFocusableContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onEnter;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool autofocus;
  final FocusNode? focusNode;

  const HvacFocusableContainer({
    super.key,
    required this.child,
    this.onEnter,
    this.onTap,
    this.semanticLabel,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<HvacFocusableContainer> createState() => _HvacFocusableContainerState();
}

class _HvacFocusableContainerState extends State<HvacFocusableContainer> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        if (widget.onEnter != null) {
          widget.onEnter!();
        } else if (widget.onTap != null) {
          widget.onTap!();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        child: GestureDetector(
          onTap: () {
            _focusNode.requestFocus();
            widget.onTap?.call();
          },
          child: Semantics(
            label: widget.semanticLabel,
            button: widget.onTap != null || widget.onEnter != null,
            focused: _isFocused,
            child: Container(
              decoration: _isFocused
                  ? BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    )
                  : null,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Arrow key scrolling for web
class HvacArrowKeyScrolling extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final double scrollSpeed;

  const HvacArrowKeyScrolling({
    super.key,
    required this.child,
    this.scrollController,
    this.scrollSpeed = 50.0,
  });

  @override
  State<HvacArrowKeyScrolling> createState() => _HvacArrowKeyScrollingState();
}

class _HvacArrowKeyScrollingState extends State<HvacArrowKeyScrolling> {
  late ScrollController _scrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final currentOffset = _scrollController.offset;
      double? newOffset;

      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        newOffset = currentOffset + widget.scrollSpeed;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        newOffset = currentOffset - widget.scrollSpeed;
      } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
        newOffset = currentOffset + (widget.scrollSpeed * 10);
      } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
        newOffset = currentOffset - (widget.scrollSpeed * 10);
      } else if (event.logicalKey == LogicalKeyboardKey.home) {
        newOffset = 0;
      } else if (event.logicalKey == LogicalKeyboardKey.end) {
        newOffset = _scrollController.position.maxScrollExtent;
      }

      if (newOffset != null) {
        _scrollController.animateTo(
          newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return widget.child;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        _handleKeyEvent(event);
        return KeyEventResult.handled;
      },
      child: widget.child,
    );
  }
}

/// Tab traversal group for organized keyboard navigation
class HvacTabTraversalGroup extends StatelessWidget {
  final Widget child;
  final FocusTraversalPolicy? policy;

  const HvacTabTraversalGroup({
    super.key,
    required this.child,
    this.policy,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return FocusTraversalGroup(
      policy: policy ?? OrderedTraversalPolicy(),
      child: child,
    );
  }
}
