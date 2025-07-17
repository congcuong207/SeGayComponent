// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class SGDropdownComboBox<T> extends StatefulWidget {
  final String? label;
  final double? width;
  final double? height;
  final double? sizeBoder;
  final double? sizeBoderMenuItem;
  final Color? colorBoder;
  final Color? colorBoderMenuItem;
  final Color? colorSelectedText;
  final Color? colorBoderFocus;
  final Color? colorBoderHover;
  final Color? colorHoverItem;
  final T? value;
  final T? defaultValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final TextInputType? inputType;
  final bool enableSearch;

  const SGDropdownComboBox({
    super.key,
    this.label,
    this.width,
    this.height,
    this.sizeBoder,
    this.sizeBoderMenuItem,
    this.colorBoder,
    this.colorBoderMenuItem,
    this.colorSelectedText,
    this.colorBoderFocus,
    this.colorBoderHover,
    this.colorHoverItem,
    required this.value,
    this.defaultValue,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.inputType,
    this.enableSearch = true,
  });

  @override
  State<SGDropdownComboBox<T>> createState() => _SGDropdownComboBoxState<T>();
}

class _SGDropdownComboBoxState<T> extends State<SGDropdownComboBox<T>> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  late List<DropdownMenuItem<T>> _filteredItems;
  bool _isOpen = false;
  T? _hoveredItem;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _setInitialValue();
    _focusNode.addListener(_handleFocus);
    _controller.addListener(_onTextChanged);
  }

  void _setInitialValue() {
    if (widget.value != null) {
      _setControllerTextByValue(widget.value);
    } else if (widget.defaultValue != null &&
        widget.items.any((item) => item.value == widget.defaultValue)) {
      _setControllerTextByValue(widget.defaultValue);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(widget.defaultValue);
      });
    } else if (widget.items.isNotEmpty) {
      _setControllerTextByValue(widget.items.first.value);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(widget.items.first.value);
      });
    }
  }

  @override
  void didUpdateWidget(covariant SGDropdownComboBox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _setControllerTextByValue(widget.value);
    }
    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
      _onTextChanged();
    }
  }

  void _setControllerTextByValue(T? value) {
    final text = _getTextFromValue(value);
    _controller.text = text;
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
    if (_focusNode.hasFocus) {
      if (!_isOpen) _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _onTextChanged() {
    if (!widget.enableSearch) return;
    final searchValue = _controller.text.toLowerCase();
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
    });

    if (!_isOpen) {
      _showOverlay();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isOpen) _overlayEntry?.markNeedsBuild();
      });
    }
  }

  void _onItemSelected(DropdownMenuItem<T> item) {
    widget.onChanged(item.value);
    _controller.text = _getTextFromValue(item.value);
    setState(() {
      _filteredItems = widget.items;
    });
    // Đảm bảo đóng popup ngay lập tức
    _removeOverlay();
    // Sau đó mới unfocus để tránh xung đột
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.unfocus();
    });
  }

  void _showOverlay() {
    // Nếu overlay đã tồn tại, không insert lại
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
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: widget.width ?? size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 4),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: _filteredItems.isNotEmpty
                    ? _filteredItems.map((item) {
                        final isSelected =
                            item.value == (widget.value ?? widget.defaultValue);
                        Widget child = item.child;
                        if (child is Text) {
                          child = Text(
                            (child).data ?? '',
                            style: TextStyle(
                              color: isSelected
                                  ? (widget.colorSelectedText ?? Colors.blue)
                                  : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          );
                        }
                        return MouseRegion(
                          onEnter: (_) =>
                              setState(() => _hoveredItem = item.value),
                          onExit: (_) => setState(() => _hoveredItem = null),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              hoverColor: widget.colorHoverItem ??
                                  SGAppColors.colorBorderGray.withOpacity(0.15),
                              onTapDown: (_) {
                                _onItemSelected(item);
                                // _removeOverlay();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: child,
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    : [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Không có dữ liệu'),
                        ),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
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
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          readOnly: !widget.enableSearch,
          keyboardType: widget.inputType ?? TextInputType.text,
          inputFormatters: widget.inputType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.colorBoder ?? SGAppColors.colorBorderGray,
                width: widget.sizeBoder ?? 1,
              ),
            ),
            suffixIcon: (widget.enableSearch && _controller.text.isNotEmpty)
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          _controller.clear();
                          widget.onChanged(null);
                        },
                        child: const Center(
                          child:
                              Icon(Icons.clear, color: Colors.grey, size: 18),
                        ),
                      ),
                    ),
                  )
                : const Icon(Icons.arrow_drop_down),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          onTap: () {
            _focusNode.requestFocus();
            if (!_isOpen) _showOverlay();
            
            // Xóa giá trị hiện tại khi click vào dropdown có enableSearch=true
            if (widget.enableSearch && _controller.text.isNotEmpty) {
              _controller.clear();
              // Không gọi onChanged ở đây để giữ lại giá trị đã chọn
            }
          },
          onEditingComplete: () {
            if (widget.enableSearch) {
              final match = widget.items.firstWhere(
                (item) =>
                    (item.child is Text
                        ? ((item.child as Text).data ?? '')
                        : item.value.toString()) ==
                    _controller.text,
                orElse: () =>
                    DropdownMenuItem<T>(value: null, child: const SizedBox()),
              );
              if (match.value == null) {
                _setControllerTextByValue(widget.value);
              }
            }
            _removeOverlay();
          },
        ),
      ),
    );
  }
}
