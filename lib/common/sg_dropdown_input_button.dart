// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'dart:math' as math;

class SGDropdownInputButton<T> extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? textDataNullSearch;
  final double? width;
  final double? height;
  final double? sizeBorderLine;
  final double? sizeBorderCircular;
  final double? sizeBorderMenuItemLine;
  final double? sizeBorderCircularItem;
  final Color? colorBorder;
  final Color? colorBorderMenuItem;
  final Color? colorSelectedText;
  final Color? colorBorderFocus;
  final Color? colorBorderHover;
  final Color? colorHoverItem;
  final bool? isShowSuffixIcon;
  final TextAlign? textAlign;
  final TextAlign? textAlignItem;
  final EdgeInsetsGeometry? contentPadding;
  final T? value;
  final T? defaultValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final TextInputType? inputType;
  final bool enableSearch;
  final TextStyle? textStyle;
  final double? fontSize;
  final FontWeight? fontWeight;

  const SGDropdownInputButton({
    super.key,
    required this.controller,
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.textDataNullSearch,
    this.width,
    this.height,
    this.sizeBorderLine,
    this.sizeBorderCircular,
    this.sizeBorderMenuItemLine,
    this.sizeBorderCircularItem,
    this.colorBorder,
    this.colorBorderMenuItem,
    this.colorSelectedText,
    this.colorBorderFocus,
    this.colorBorderHover,
    this.colorHoverItem,
    this.isShowSuffixIcon = true,
    this.textAlign,
    this.textAlignItem,
    this.contentPadding,
    this.defaultValue,
    this.hintText,
    this.inputType,
    this.enableSearch = true,
    this.textStyle,
    this.fontSize,
    this.fontWeight,
  });

  @override
  State<SGDropdownInputButton<T>> createState() =>
      _SGDropdownInputButtonState<T>();
}

class _SGDropdownInputButtonState<T> extends State<SGDropdownInputButton<T>> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  late List<DropdownMenuItem<T>> _filteredItems;
  bool _isOpen = false;
  T? _hoveredItem;
  bool _justSelected = false;
  bool _isProgrammaticChange = false;
  T? _lastSelectedValue;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _setInitialValue();
    _focusNode.addListener(_handleFocus);
    widget.controller.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialized = true;
    });
  }

  void _setInitialValue() {
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
    }
    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
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
    if (!_initialized) return;
    if (_focusNode.hasFocus) {
      if (_justSelected) {
        _justSelected = false;
        return;
      }
    } else {
      final currentText = widget.controller.text;
      final match = widget.items.firstWhere(
        (item) =>
            (item.child is Text
                ? ((item.child as Text).data ?? '')
                : item.value.toString()) ==
            currentText,
        orElse: () => DropdownMenuItem<T>(value: null, child: const SizedBox()),
      );
      if (match.value == null && _lastSelectedValue != null) {
        if (widget.value != _lastSelectedValue) {
          _setControllerTextByValue(_lastSelectedValue);
          widget.onChanged(_lastSelectedValue);
        } else {
          _setControllerTextByValue(_lastSelectedValue);
        }
      }
      _removeOverlay();
    }
  }

  void _onTextChanged() {
    if (_isProgrammaticChange) return;
    if (!widget.enableSearch) return;
    final searchValue = widget.controller.text.toLowerCase();
    setState(() {
      if (searchValue.isEmpty) {
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
    _isProgrammaticChange = true;
    widget.controller.text = _getTextFromValue(item.value);
    _isProgrammaticChange = false;
    _lastSelectedValue = item.value;
    widget.onChanged(item.value);
    if (mounted) _focusNode.unfocus();
    _removeOverlay();
    setState(() {
      _filteredItems = widget.items;
      _justSelected = true;
    });
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
    // 获取组件尺寸和位置
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final RenderObject? overlay = Overlay.of(context).context.findRenderObject();
    final RenderBox box = renderBox;
    final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

    // 计算弹出菜单的显示方向和空间
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceAbove = position.dy;
    final spaceBelow = screenHeight - (position.dy + size.height);
    
    // 估计弹出菜单高度
    final itemHeight = 44.0; // 每个选项的估计高度
    final double estimatedPopupHeight = _filteredItems.isEmpty 
        ? 60 // "No Data"的最小高度
        : math.min(300, _filteredItems.length * itemHeight);
    
    // 决定显示方向
    final showAbove = spaceBelow < estimatedPopupHeight && spaceAbove > spaceBelow;
    
    // 设置菜单样式和内容
    return OverlayEntry(
      builder: (context) => Positioned(
        width: widget.width ?? size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: showAbove ? Alignment.topCenter : Alignment.bottomCenter,
          followerAnchor: showAbove ? Alignment.bottomCenter : Alignment.topCenter,
          offset: Offset(0.0, showAbove ? -4 : 4), // 4px间距
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(
              widget.sizeBorderCircularItem ?? widget.sizeBorderCircular ?? 12
            ),
            child: _buildDropdownList(),
          ),
        ),
      ),
    );
  }
  
  // 构建下拉列表
  Widget _buildDropdownList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: _filteredItems.isNotEmpty
            ? _filteredItems.map(_buildDropdownItem).toList()
            : [_buildEmptyView()],
      ),
    );
  }

  // 构建下拉项
  Widget _buildDropdownItem(DropdownMenuItem<T> item) {
    final isSelected = item.value == (widget.value ?? widget.defaultValue);
    
    // 处理项目中的文本样式
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
      onEnter: (_) => setState(() => _hoveredItem = item.value),
      onExit: (_) => setState(() => _hoveredItem = null),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          hoverColor: widget.colorHoverItem ??
              SGAppColors.colorBorderGray.withOpacity(0.15),
          onTapDown: (_) => _onItemSelected(item),
          child: Container(
            padding: widget.width != null && widget.width! <= 30
                ? const EdgeInsets.only(top: 5, bottom: 5)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: child,
          ),
        ),
      ),
    );
  }
  
  // 无数据时的视图
  Widget _buildEmptyView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SGText(
        text: widget.textDataNullSearch ?? 'No Data',
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    widget.controller.removeListener(_onTextChanged);
    widget.controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          readOnly: !widget.enableSearch,
          enableInteractiveSelection: widget.enableSearch,
          keyboardType: widget.inputType ?? TextInputType.text,
          inputFormatters: _buildInputFormatters(),
          textAlign: widget.textAlign ?? TextAlign.center,
          style: _buildTextStyle(),
          decoration: _buildInputDecoration(),
          onTap: _handleTap,
          onEditingComplete: _handleEditingComplete,
        ),
      ),
    );
  }

  List<TextInputFormatter>? _buildInputFormatters() {
    return widget.inputType == TextInputType.number
        ? [FilteringTextInputFormatter.digitsOnly]
        : null;
  }

  TextStyle _buildTextStyle() {
    return widget.textStyle?.copyWith(
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
    ) ??
    TextStyle(
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
    );
  }

  InputDecoration _buildInputDecoration() {
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

  Widget? _buildSuffixIcon() {
    if (!(widget.isShowSuffixIcon ?? false)) {
      return null;
    }
    
    if (widget.enableSearch && widget.controller.text.isNotEmpty) {
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
    if (_justSelected) return;
    _focusNode.requestFocus();
    if (widget.enableSearch) {
      widget.controller.clear();
    }
    if (!_isOpen) _showOverlay();
  }

  void _handleEditingComplete() {
    if (widget.enableSearch) {
      final match = widget.items.firstWhere(
        (item) =>
            (item.child is Text
                ? ((item.child as Text).data ?? '')
                : item.value.toString()) ==
            widget.controller.text,
        orElse: () =>
            DropdownMenuItem<T>(value: null, child: const SizedBox()),
      );
      if (match.value == null) {
        _setControllerTextByValue(_lastSelectedValue);
      }
    }
    _removeOverlay();
  }
}
