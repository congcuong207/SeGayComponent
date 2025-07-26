import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_gay_components/common/sg_button_v2.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'sg_popup_controller.dart';
import 'sg_popup_menu.dart';

class SGButtonIconWithPopup extends StatefulWidget {
  final List<Widget> popupItems;
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

  final Function(BuildContext context)? onclick;
  final Function(BuildContext context, PointerHoverEvent event)? onHover;
  final Function(BuildContext context, PointerExitEvent event)? onExit;
  final Function(BuildContext context, PointerEnterEvent event)? onEnter;

  final double? widthButton;
  final double? heightButton;
  final Color? colorBackgroundButton;
  final Color? colorTextButton;
  final Color? colorBorderButton;
  final double? iconSizeButton;
  final double? borderRadiusButton;
  final Widget? iconChildButton;
  final String? textButton;
  final TextStyle? textStyleButton;
  final EdgeInsetsGeometry? paddingButton;
  final EdgeInsetsGeometry? marginButton;
  final bool isDisabledButton;
  final bool isLoadingButton;
  final SGButtonType buttonType;
  final SGButtonSize buttonSizeButton;
  final MainAxisAlignment contentAlignmentButton;
  final CrossAxisAlignment contentCrossAxisAlignmentButton;
  final double? borderWidthButton;

  const SGButtonIconWithPopup({
    super.key,
    required this.popupItems,
    this.popupWidth = 200,
    this.popupBackgroundColor,
    this.popupBorderRadius = 8.0,
    this.popupPadding = EdgeInsets.zero,
    this.popupOffset = const Offset(0, 5),
    this.preferBelow = true,
    this.popupId,
    this.onPopupOpened,
    this.onPopupClosed,
    this.animationDuration = const Duration(milliseconds: 150),
    this.popupMaxHeight,
    this.popupEnableScroll = true,
    this.onclick,
    this.onHover,
    this.onExit,
    this.onEnter,
    this.widthButton,
    this.heightButton,
    this.colorBackgroundButton,
    this.colorTextButton,
    this.colorBorderButton,
    this.iconSizeButton,
    this.borderRadiusButton,
    this.iconChildButton,
    this.textButton,
    this.textStyleButton,
    this.paddingButton,
    this.marginButton,
    this.isDisabledButton = false,
    this.isLoadingButton = false,
    this.buttonType = SGButtonType.primary,
    this.buttonSizeButton = SGButtonSize.medium,
    this.contentAlignmentButton = MainAxisAlignment.center,
    this.contentCrossAxisAlignmentButton = CrossAxisAlignment.center,
    this.borderWidthButton,
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
    String popupId = widget.popupId ?? 'popup_${widget.iconChildButton?.hashCode ?? widget.textButton?.hashCode}_${widget.hashCode}';
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
    widget.onclick?.call(context);
    String popupId = widget.popupId ?? 'popup_${widget.iconChildButton?.hashCode ?? widget.textButton?.hashCode}_${widget.hashCode}';
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
    String popupId = widget.popupId ?? 'popup_${widget.iconChildButton?.hashCode ?? widget.textButton?.hashCode}_${widget.hashCode}';
    SGLog.debug("SGButtonIconWithPopup", ' Disposing controller: $popupId');
    _popupController.removeOnPopupStateChangedListener();
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
        onHover: widget.onHover,
        onExit: widget.onExit,
        onEnter: widget.onEnter,
        width: widget.widthButton,
        height: widget.heightButton,
        colorBackground: widget.colorBackgroundButton,
        colorText: widget.colorTextButton,
        colorBorder: widget.colorBorderButton,
        iconSize: widget.iconSizeButton,
        borderRadius: widget.borderRadiusButton,
        iconChild: widget.iconChildButton,
        text: widget.textButton,
        textStyle: widget.textStyleButton,
        padding: widget.paddingButton,
        margin: widget.marginButton,
        isDisabled: widget.isDisabledButton,
        isLoading: widget.isLoadingButton,
        buttonType: widget.buttonType,
        buttonSize: widget.buttonSizeButton,
        contentAlignment: widget.contentAlignmentButton,
        borderWidth: widget.borderWidthButton,
        contentCrossAxisAlignment: widget.contentCrossAxisAlignmentButton,
      ),
    );
  }
}
