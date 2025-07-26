// ignore_for_file: unused_field, deprecated_member_use
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'dart:math' as math;

class SGDropdownInputButton<T> extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? textDataNullSearch;
  final int? maxLines;
  final double? width;
  final double? height;
  final double? sizeBorderLine;
  final double? sizeBorderCircular;
  final double? sizeBorderMenuItemLine;
  final double? sizeBorderCircularItem;
  final Color? colorBorder;
  final Color? colorBorderMenuItem;
  final Color? colorSelectedText;
  final Color? colorBackgroundPopup;
  final Color? colorBorderFocus;
  final Color? colorBorderHover;
  final Color? colorHoverItem;
  final bool? isShowSuffixIcon;
  final bool enableSearch;
  final bool isClearController;
  final TextAlign? textAlign;
  final TextAlign? textAlignItem;
  final TextOverflow? textOverflow;
  final EdgeInsetsGeometry? contentPadding;
  final T? value;
  final T? defaultValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final TextInputType? inputType;
  final TextStyle? textStyle;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FocusNode? focusNode;
  final bool showUnderlineBorderOnly; // Thêm tùy chọn mới

  const SGDropdownInputButton({
    super.key,
    required this.controller,
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.textDataNullSearch,
    this.maxLines,
    this.width,
    this.height,
    this.sizeBorderLine,
    this.sizeBorderCircular,
    this.sizeBorderMenuItemLine,
    this.sizeBorderCircularItem,
    this.colorBorder,
    this.colorBorderMenuItem,
    this.colorSelectedText,
    this.colorBackgroundPopup,
    this.colorBorderFocus,
    this.colorBorderHover,
    this.colorHoverItem,
    this.isShowSuffixIcon = true,
    this.textAlign,
    this.textAlignItem,
    this.textOverflow,
    this.contentPadding,
    this.defaultValue,
    this.hintText,
    this.inputType,
    this.enableSearch = true,
    this.isClearController = true,
    this.textStyle,
    this.fontSize,
    this.fontWeight,
    this.focusNode,
    this.showUnderlineBorderOnly = false, // Mặc định là false
  });

  @override
  State<SGDropdownInputButton<T>> createState() =>
      _SGDropdownInputButtonState<T>();
}

class _SGDropdownInputButtonState<T> extends State<SGDropdownInputButton<T>> {
  final LayerLink _layerLink = LayerLink();
  late final FocusNode _focusNode;
  OverlayEntry? _overlayEntry;
  late List<DropdownMenuItem<T>> _filteredItems;
  bool _isOpen = false;
  T? _hoveredItem;
  bool _justSelected = false;
  bool _isProgrammaticChange = false;
  T? _lastSelectedValue;
  bool _initialized = false;
  bool _needsOnChanged = false;
  T? _pendingValue;
  bool _ownsFocusNode = false;
  bool _isHovering = false; // Thêm trạng thái hover

  bool _preventOverlayClose = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _filteredItems = widget.items;
    _setInitialValue();
    _focusNode.addListener(_handleFocus);

    widget.controller.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialized = true;
    });
  }

  void _setInitialValue() {
    log('setInitialValue: ${widget.value} - ${widget.defaultValue} - ${widget.items}');
    if (widget.value != null) {
      _setControllerTextByValue(widget.value);
      _lastSelectedValue = widget.value;
    } else if (widget.defaultValue != null &&
        widget.items.any((item) => item.value == widget.defaultValue)) {
      _setControllerTextByValue(widget.defaultValue);
      _lastSelectedValue = widget.defaultValue;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(widget.defaultValue);
      });
    } else if (widget.items.isNotEmpty) {
      _setControllerTextByValue(widget.items.first.value);
      _lastSelectedValue = widget.items.first.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(widget.items.first.value);
      });
    }
  }

  @override
  void didUpdateWidget(covariant SGDropdownInputButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _setControllerTextByValue(widget.value);
      _lastSelectedValue = widget.value;
      log('didUpdateWidget: ${widget.value} - ${_lastSelectedValue}');
      _onTextChanged();
    }

    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
      log('didUpdateWidget3: ${widget.items} - ${_filteredItems}');
      _onTextChanged();
    }
  }

  void _setControllerTextByValue(T? value) {
    final text = _getTextFromValue(value);
    
    _isProgrammaticChange = true;
    widget.controller.text = text;
    _isProgrammaticChange = false;
  }

  String _getTextFromValue(T? value) {
    final item = widget.items.firstWhere(
      (item) => item.value == value,
      orElse: () => DropdownMenuItem<T>(value: null, child: const SizedBox()),
    );
    if (item.value != null && item.child is Text) {
      return (item.child as Text).data ?? '';
    } else if (item.value != null) {
      return item.value.toString();
    }
    return '';
  }

  void _handleFocus() {
    if (!_initialized) {
      return;
    }
    if (_focusNode.hasFocus) {
      if (_justSelected) {
        _justSelected = false;
        return;
      }

      if (!_isOpen) {
        _preventOverlayClose = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showOverlay();

            Future.delayed(const Duration(milliseconds: 300), () {
              _preventOverlayClose = false;
            });
          }
        });
      }
    } else {
      if (_preventOverlayClose) {
        return;
      }

      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus && !_preventOverlayClose) {
          final currentText = widget.controller.text;
          _handleTextAndCloseOverlay(currentText);
        }
      });
    }
  }

  void _handleTextAndCloseOverlay(String currentText) {
    final match = widget.items.firstWhere(
      (item) {
        final itemText = item.child is Text
            ? ((item.child as Text).data ?? '')
            : item.value.toString();
        final result = itemText == currentText;
        return result;
      },
      orElse: () {
        return DropdownMenuItem<T>(value: null, child: const SizedBox());
      },
    );

    if (match.value == null && _lastSelectedValue != null) {
      if (widget.value != _lastSelectedValue) {
        _setControllerTextByValue(_lastSelectedValue);
        _needsOnChanged = true;
        _pendingValue = _lastSelectedValue;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_needsOnChanged && _pendingValue != null && mounted) {
            widget.onChanged(_pendingValue);
            _needsOnChanged = false;
            _pendingValue = null;
          }
        });
      } else {
        _setControllerTextByValue(_lastSelectedValue);
      }
    }

    _removeOverlay();
  }

  void _onTextChanged() {
    if (_isProgrammaticChange) return;
    final searchValue = widget.controller.text.toLowerCase();
    setState(() {
      if (!widget.isClearController) {
        _filteredItems = widget.items;
      } else if (searchValue.isEmpty || widget.enableSearch) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final itemText = item.child is Text
              ? ((item.child as Text).data ?? '')
              : item.value.toString();
          return itemText.toLowerCase().contains(searchValue);
        }).toList();
      }
      if (_isOpen && _overlayEntry != null) {
        _overlayEntry!.markNeedsBuild();
      }
    });
  }

  void _onItemSelected(DropdownMenuItem<T> item) {
    log('onItemSelected: ${item.value}');
    _preventOverlayClose = true;

    _isProgrammaticChange = true;
    widget.controller.text = _getTextFromValue(item.value);
    _isProgrammaticChange = false;
    _lastSelectedValue = item.value;

    _removeOverlay();

    setState(() {
      _filteredItems = widget.items;
      _justSelected = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onChanged(item.value);

        Future.delayed(const Duration(milliseconds: 300), () {
          _preventOverlayClose = false;
        });
      }
    });

    if (mounted) _focusNode.unfocus();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _justSelected = false);
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
      return;
    }
    _overlayEntry = _createOverlayEntry();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_overlayEntry!);
      _isOpen = true;
    });
  }

  void _removeOverlay() {
    if (_isOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isOpen = false;
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    final RenderBox box = renderBox;
    final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

    final screenHeight = MediaQuery.of(context).size.height;
    final spaceAbove = position.dy;
    final spaceBelow = screenHeight - (position.dy + size.height);

    const itemHeight = 44.0;
    final double estimatedPopupHeight = _filteredItems.isEmpty
        ? 60
        : math.min(300, _filteredItems.length * itemHeight);

    final showAbove =
        spaceBelow < estimatedPopupHeight && spaceAbove > spaceBelow;

    final popupWidth = math.min(widget.width ?? size.width, 400.0);
    final bool useLeftAlignment = popupWidth >= 400;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: popupWidth,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: useLeftAlignment
              ? (showAbove ? Alignment.topLeft : Alignment.bottomLeft)
              : (showAbove ? Alignment.topCenter : Alignment.bottomCenter),
          followerAnchor: useLeftAlignment
              ? (showAbove ? Alignment.bottomLeft : Alignment.topLeft)
              : (showAbove ? Alignment.bottomCenter : Alignment.topCenter),
          offset: Offset(0.0, showAbove ? -4 : 4),
          child: Material(
            elevation: 4.0,
            borderRadius: widget.showUnderlineBorderOnly
                ? null
                : BorderRadius.circular(
                    widget.sizeBorderCircularItem ??
                        widget.sizeBorderCircular ??
                        12,
                  ),
            child: _buildDropdownList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 300,
        maxWidth: 400,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: _filteredItems.isNotEmpty
            ? _filteredItems.map(_buildDropdownItem).toList()
            : [_buildEmptyView()],
      ),
    );
  }

  Widget _buildDropdownItem(DropdownMenuItem<T> item) {
    final isSelected = item.value == (widget.value ?? widget.defaultValue);
    log('isSelected: $isSelected ${item.value} - ${widget.value} - ${widget.defaultValue}');

    Widget child = item.child;
    if (child is Text) {
      child = Text(
        (child).data ?? '',
        textAlign: widget.textAlignItem ?? TextAlign.center,
        style: TextStyle(
          fontSize: widget.fontSize,
          color: isSelected
              ? (widget.colorSelectedText ?? Colors.blue)
              : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredItem = item.value;
      }),
      onExit: (_) => setState(() => _hoveredItem = null),
      child: InkWell(
        hoverColor: widget.colorHoverItem ??
            SGAppColors.colorBorderGray.withOpacity(0.15),
        onTapDown: (_) {
          log('onTapDown: ${item.value}');
          _onItemSelected(item);
        },
        child: Container(
          padding: widget.width != null && widget.width! <= 30
              ? const EdgeInsets.only(top: 5, bottom: 5)
              : const EdgeInsets.all(5),
          child: child,
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SGText(text: widget.textDataNullSearch ?? 'No Data'),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    widget.controller.removeListener(_onTextChanged);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
          });
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          // padding: const EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            readOnly: widget.enableSearch,
            enableInteractiveSelection: widget.enableSearch,
            keyboardType: widget.inputType ?? TextInputType.text,
            inputFormatters: _buildInputFormatters(),
            textAlign: widget.textAlign ??
                (widget.showUnderlineBorderOnly
                    ? TextAlign.left
                    : TextAlign.center),
            style: _buildTextStyle(),
            maxLines: widget.maxLines ?? 1,
            decoration: _buildInputDecoration(),
            onTap: _handleTap,
            onEditingComplete: _handleEditingComplete,
          ),
        ),
      ),
    );
  }

  List<TextInputFormatter>? _buildInputFormatters() {
    if (widget.inputType == TextInputType.number) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    return null;
  }

  TextStyle _buildTextStyle() {
    final baseStyle = TextStyle(
      fontSize: widget.fontSize ?? 14,
      fontWeight: widget.fontWeight ?? FontWeight.normal,
      overflow: widget.textOverflow,
      height: 1.2, // Tăng height để văn bản không bị sát dòng
      leadingDistribution:
          TextLeadingDistribution.even, // Phân phối đều khoảng cách
    );

    // Ưu tiên style từ widget nếu có
    return widget.textStyle?.copyWith(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          overflow: widget.textOverflow,
          height: 1.2,
          leadingDistribution: TextLeadingDistribution.even,
        ) ??
        baseStyle;
  }

  InputDecoration _buildInputDecoration() {
    if (widget.showUnderlineBorderOnly) {
      // Custom underline border with gap
      return InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
        isDense: false,
        border: _buildUnderlineBorder(false),
        enabledBorder: _buildUnderlineBorder(false),
        focusedBorder: _buildUnderlineBorder(true),
        suffixIcon: _buildSuffixIcon(),
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
    } else {
      // Standard outline border
      return InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.sizeBorderCircular ?? 12),
          borderSide: BorderSide(
            color: widget.colorBorder ?? SGAppColors.colorBorderGray,
            width: widget.sizeBorderLine ?? 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.sizeBorderCircular ?? 12),
          borderSide: BorderSide(
            color: widget.colorBorderFocus ?? SGAppColors.info500,
            width: widget.sizeBorderLine ?? 1,
          ),
        ),
        suffixIcon: _buildSuffixIcon(),
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      );
    }
  }

  // Tạo border dưới chỉ hiển thị khi hover
  InputBorder _buildUnderlineBorder(bool isFocused) {
    // Khi hover hoặc focus: hiển thị border
    if (_isHovering || isFocused) {
      final color = isFocused
          ? (widget.colorBorderFocus ?? SGAppColors.info500)
          : (widget.colorBorder ?? SGAppColors.colorBorderGray);

      return UnderlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: widget.sizeBorderLine ?? 1,
        ),
      );
    } else {
      // Không hover, không focus: ẩn border (độ rộng = 0)
      return const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      );
    }
  }

  Widget? _buildSuffixIcon() {
    if (widget.isShowSuffixIcon == false) {
      return null;
    }

    if (!widget.enableSearch && widget.controller.text.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
        onPressed: () {
          widget.controller.clear();
          if (!_isOpen) _showOverlay();
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.arrow_drop_down),
        onPressed: () {
          if (_isOpen) {
            _removeOverlay();
          } else {
            _focusNode.requestFocus();
            _showOverlay();
          }
        },
      );
    }
  }

  void _handleTap() {
    if (_justSelected) {
      return;
    }
    _focusNode.requestFocus();
    if (!widget.enableSearch && widget.isClearController) {
      widget.controller.clear();
    }
    if (!_isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showOverlay();

          Future.microtask(() {
            if (mounted) {
              FocusScope.of(context).requestFocus(_focusNode);
            }
          });
        }
      });
    }
  }

  void _handleEditingComplete() {
    if (!widget.enableSearch) {
      final match = widget.items.firstWhere(
        (item) =>
            (item.child is Text
                ? ((item.child as Text).data ?? '')
                : item.value.toString()) ==
            widget.controller.text,
        orElse: () => DropdownMenuItem<T>(value: null, child: const SizedBox()),
      );
      if (match.value == null) {
        _setControllerTextByValue(_lastSelectedValue);
      }
    }
    _removeOverlay();
  }
}
