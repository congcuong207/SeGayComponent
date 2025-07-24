import 'package:flutter/material.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

/// Callback được gọi khi popup thay đổi trạng thái
typedef PopupStateChangedCallback = void Function(bool isOpen);

class SGPopupManager {
  // Singleton instance
  static final SGPopupManager _instance = SGPopupManager._internal();
  factory SGPopupManager() => _instance;
  SGPopupManager._internal();

  // Currently active popup
  String? _activePopupId;
  SGPopupController? _activeController;
  bool _processingPopupChange = false;
  final List<VoidCallback> _globalListeners = [];

  // Đăng ký callback lắng nghe sự kiện thay đổi trạng thái popup toàn cục
  void addGlobalListener(VoidCallback listener) {
    _globalListeners.add(listener);
  }

  // Hủy đăng ký callback
  void removeGlobalListener(VoidCallback listener) {
    _globalListeners.remove(listener);
  }

  // Thông báo cho tất cả listeners
  void _notifyListeners() {
    for (final listener in _globalListeners) {
      listener();
    }
  }

  // Register a popup opening
  void registerPopupOpening(String popupId, SGPopupController controller) {
    SGLog.debug("SGPopupManager", 'Registering popup opening: $popupId');
    SGLog.debug("SGPopupManager", 'Active popup: $_activePopupId');

    // Prevent recursion
    if (_processingPopupChange) {
      SGLog.debug("SGPopupManager", 'Already processing a popup change, ignoring');
      return;
    }

    _processingPopupChange = true;

    try {
      // Close any active popup first
      if (_activeController != null && _activePopupId != popupId) {
        SGLog.debug("SGPopupManager", 'Closing active popup: $_activePopupId to open: $popupId');
        _activeController!.hidePopupInternal();
      }

      // Register this as the active popup
      _activePopupId = popupId;
      _activeController = controller;
      SGLog.debug("SGPopupManager", 'New active popup: $popupId');
      _notifyListeners();
    } finally {
      _processingPopupChange = false;
    }
  }

  // Register a popup closing
  void registerPopupClosing(String popupId) {
    SGLog.debug("SGPopupManager", 'Registering popup closing: $popupId');
    SGLog.debug("SGPopupManager", 'Current active popup: $_activePopupId');

    // Prevent recursion
    if (_processingPopupChange) {
      SGLog.debug("SGPopupManager", 'Already processing a popup change, ignoring');
      return;
    }

    _processingPopupChange = true;

    try {
      if (_activePopupId == popupId) {
        SGLog.debug("SGPopupManager", 'Clearing active popup reference');
        _activePopupId = null;
        _activeController = null;
        _notifyListeners();
      }
    } finally {
      _processingPopupChange = false;
    }
  }

  // Check if a specific popup is active
  bool isPopupActive(String popupId) {
    return _activePopupId == popupId;
  }

  // Close all active popups - Can be called from anywhere
  void closeAllPopups() {
    SGLog.debug("SGPopupManager", 'closeAllPopups() called');
    if (_activeController != null) {
      SGLog.debug("SGPopupManager", 'Closing active popup: $_activePopupId');
      _activeController!.hidePopup();
    }
  }

  // Check if any popup is active
  bool get hasActivePopup => _activeController != null;
}

class SGPopupController {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final String popupId;
  final SGPopupManager _manager = SGPopupManager();
  bool _isOpening = false;
  bool _forceClose = false;

  // Animation duration
  final Duration animationDuration;

  // Callback khi trạng thái popup thay đổi
  PopupStateChangedCallback? onPopupStateChanged;

  SGPopupController({
    String? id,
    this.animationDuration = const Duration(milliseconds: 150),
    this.onPopupStateChanged,
  }) : popupId = id ?? UniqueKey().toString();

  bool get isShowing => _overlayEntry != null;
  LayerLink get layerLink => _layerLink;

  /// Show a popup
  void showPopup(
    BuildContext context,
    Widget popupWidget, {
    Offset offset = const Offset(0, 5),
    bool preferBelow = true,
  }) {
    SGLog.debug("SGPopupController", '$popupId: Show popup called');
    SGLog.debug("SGPopupController", '$popupId: isShowing = $isShowing');

    // Reset force close flag
    _forceClose = false;

    // Check if we're toggling the same popup
    bool isSelfToggle = isShowing;

    // If we're already showing, hide current popup
    if (isShowing) {
      SGLog.debug("SGPopupController", '$popupId: Already showing, hiding first');
      hidePopupInternal();
    }

    // If this was a self-toggle, return now (don't show again)
    if (isSelfToggle) {
      SGLog.debug("SGPopupController", '$popupId: Self toggle detected, not showing again');
      _manager.registerPopupClosing(popupId);
      onPopupStateChanged?.call(false);
      return;
    }

    // Mark that we're in the process of opening
    _isOpening = true;
    SGLog.debug("SGPopupController", ' $popupId: Starting to open popup');

    // Register with popup manager (this may close other popups)
    _manager.registerPopupOpening(popupId, this);

    // Check if we were force closed during registration
    if (_forceClose) {
      SGLog.debug("SGPopupController", '$popupId: Force close flag set, not opening');
      _isOpening = false;
      onPopupStateChanged?.call(false);
      return;
    }

    // Calculate screen size and position to ensure popup fits on screen
    final screenSize = MediaQuery.of(context).size;
    final screenInsets = MediaQuery.of(context).viewInsets;
    final renderBox = context.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);

    // Now create and show the popup with animation
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Actual popup content with animation
          CompositedTransformFollower(
            link: _layerLink,
            offset: offset,
            targetAnchor: preferBelow ? Alignment.bottomCenter : Alignment.topCenter,
            followerAnchor: preferBelow ? Alignment.topCenter : Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: AnimatedOpacity(
                duration: animationDuration,
                opacity: 1.0,
                curve: Curves.easeOutCubic,
                child: TweenAnimationBuilder<double>(
                  duration: animationDuration,
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(begin: 0.9, end: 1.0),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: popupWidget,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    SGLog.debug("SGPopupController", '$popupId: Popup inserted into overlay');
    _isOpening = false;
    onPopupStateChanged?.call(true);
  }

  /// Internal method to hide popup without notifying manager
  void hidePopupInternal() {
    SGLog.debug("SGPopupController", '$popupId: hidePopupInternal called');
    if (_isOpening) {
      // If we're in the process of opening, set a flag to abort
      SGLog.debug("SGPopupController", '$popupId: Setting force close flag');
      _forceClose = true;
    }

    if (_overlayEntry != null) {
      SGLog.debug("SGPopupController", '$popupId: Removing from overlay (internal)');
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  /// Hide the current popup
  void hidePopup() {
    SGLog.debug("SGPopupController", '$popupId: Hide popup called');
    SGLog.debug("SGPopupController", '$popupId: isShowing = $isShowing');

    hidePopupInternal();
    _manager.registerPopupClosing(popupId);
    onPopupStateChanged?.call(false);
    SGLog.debug("SGPopupController", '$popupId: Popup removed');
  }

  /// Dispose the controller
  void dispose() {
    SGLog.debug("SGPopupController", '$popupId: Dispose called');
    hidePopup();
  }
}
