import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_button_v2.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'sg_popup_controller.dart';
import 'sg_popup_menu.dart';

class SGButtonIconWithPopup extends StatefulWidget {
  final List<SGPopupMenuItem> popupItems;
  final double? width;
  final double? height;
  final Color? colorBackground;
  final double? iconSize;
  final double? borderRadius;
  final Widget? iconChild;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double popupWidth;
  final Color? popupBackgroundColor;
  final double popupBorderRadius;
  final EdgeInsetsGeometry popupPadding;
  final Offset popupOffset;
  final bool preferBelow;
  final String? popupId;
  final VoidCallback? onPopupOpened;
  final VoidCallback? onPopupClosed;
  final Duration animationDuration;
  final double? popupMaxHeight;
  final bool popupEnableScroll;
  final bool highlightButtonWhenPopupOpen;
  final Color? highlightColor;

  const SGButtonIconWithPopup({
    super.key,
    required this.popupItems,
    this.width,
    this.height,
    this.colorBackground,
    this.iconSize,
    this.borderRadius,
    this.iconChild,
    this.padding,
    this.margin,
    this.popupWidth = 200,
    this.popupBackgroundColor,
    this.popupBorderRadius = 8.0,
    this.popupPadding = const EdgeInsets.symmetric(vertical: 8.0),
    this.popupOffset = const Offset(0, 5),
    this.preferBelow = true,
    this.popupId,
    this.onPopupOpened,
    this.onPopupClosed,
    this.animationDuration = const Duration(milliseconds: 150),
    this.popupMaxHeight,
    this.popupEnableScroll = true,
    this.highlightButtonWhenPopupOpen = true,
    this.highlightColor,
  });

  @override
  State<SGButtonIconWithPopup> createState() => _SGButtonIconWithPopupState();
}

class _SGButtonIconWithPopupState extends State<SGButtonIconWithPopup> {
  late final SGPopupController _popupController;
  final ScrollController _scrollController = ScrollController();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    String popupId = widget.popupId ?? 'popup_${widget.iconChild?.toString()}_${widget.hashCode}';
    _popupController = SGPopupController(
      id: popupId,
      animationDuration: widget.animationDuration,
      onPopupStateChanged: _handlePopupStateChanged,
    );
    SGLog.debug("SGButtonIconWithPopup", ' Initialized controller with ID: $popupId');
  }

  void _handlePopupStateChanged(bool isOpen) {
    if (mounted && _isOpen != isOpen) {
      setState(() {
        _isOpen = isOpen;
      });
      if (isOpen) {
        widget.onPopupOpened?.call();
      } else {
        widget.onPopupClosed?.call();
      }
    }
  }

  void _handleButtonClick(BuildContext context) {
    String popupId = widget.popupId ?? 'popup_${widget.iconChild?.toString()}_${widget.hashCode}';
    SGLog.debug("SGButtonIconWithPopup", ' Button clicked: $popupId');
    SGLog.debug("SGButtonIconWithPopup", ' isShowing before action: ${_popupController.isShowing}');

    // Create the popup widget with the enhanced features
    final popupWidget = SGPopupMenu(
      items: widget.popupItems,
      width: widget.popupWidth,
      backgroundColor: widget.popupBackgroundColor,
      borderRadius: widget.popupBorderRadius,
      padding: widget.popupPadding,
      maxHeight: widget.popupMaxHeight,
      enableScroll: widget.popupEnableScroll,
      scrollController: _scrollController,
    );

    // Show the popup
    SGLog.debug("SGButtonIconWithPopup", ' Calling showPopup: $popupId');
    _popupController.showPopup(
      context,
      popupWidget,
      offset: widget.popupOffset,
      preferBelow: widget.preferBelow,
    );

    // Check the status after showing
    SGLog.debug("SGButtonIconWithPopup", ' isShowing after action: ${_popupController.isShowing}');
  }

  @override
  void didUpdateWidget(SGButtonIconWithPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If any popup-related properties changed, close the popup
    if (oldWidget.popupWidth != widget.popupWidth ||
        oldWidget.popupBackgroundColor != widget.popupBackgroundColor ||
        oldWidget.popupBorderRadius != widget.popupBorderRadius ||
        oldWidget.popupPadding != widget.popupPadding ||
        oldWidget.popupOffset != widget.popupOffset ||
        oldWidget.preferBelow != widget.preferBelow ||
        oldWidget.popupId != widget.popupId) {
      if (_popupController.isShowing) {
        _popupController.hidePopup();
      }
    }
  }

  @override
  void dispose() {
    String popupId = widget.popupId ?? 'popup_${widget.iconChild?.toString()}_${widget.hashCode}';
    SGLog.debug("SGButtonIconWithPopup", ' Disposing controller: $popupId');
    _popupController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _popupController.layerLink,
      child: SGButtonV2(
        onclick: _handleButtonClick,
        width: widget.width,
        height: widget.height,
        colorBackground: _isOpen && widget.highlightButtonWhenPopupOpen
            ? widget.highlightColor ?? Theme.of(context).primaryColorLight
            : widget.colorBackground,
        iconSize: widget.iconSize,
        borderRadius: widget.borderRadius,
        iconChild: widget.iconChild,
        padding: widget.padding,
        margin: widget.margin,
      ),
    );
  }
}
