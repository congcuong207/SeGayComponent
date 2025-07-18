// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class SGDropdownInputButton<T> extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
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
  final EdgeInsetsGeometry? contentPadding;
  final T? value;
  final T? defaultValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final TextInputType? inputType;
  final bool enableSearch;

  const SGDropdownInputButton({
    super.key,
    required this.controller,
    this.label,
    this.width,
    this.height,
    this.sizeBorderLine,
    this.sizeBorderMenuItemLine,
    this.colorBorder,
    this.sizeBorderCircular,
    this.colorBorderMenuItem,
    this.sizeBorderCircularItem,
    this.colorSelectedText,
    this.colorBorderFocus,
    this.colorBorderHover,
    this.colorHoverItem,
    this.isShowSuffixIcon = true,
    this.textAlign,
    this.contentPadding,
    required this.value,
    this.defaultValue,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.inputType,
    this.enableSearch = true,
  });

  @override
  State<SGDropdownInputButton<T>> createState() => _SGDropdownInputButtonState<T>();
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
      // Không tự động show overlay ở đây!
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
    });
    // Không gọi _showOverlay ở đây!
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
            borderRadius:
                BorderRadius.circular(widget.sizeBorderCircularItem ?? 12),
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
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          readOnly: !widget.enableSearch,
          keyboardType: widget.inputType ?? TextInputType.text,
          inputFormatters: widget.inputType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          textAlign: widget.textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(widget.sizeBorderCircular ?? 12),
              borderSide: BorderSide(
                color: widget.colorBorder ?? SGAppColors.colorBorderGray,
                width: widget.sizeBorderLine ?? 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.sizeBorderCircular ?? 12),
              borderSide: BorderSide(
                color: widget.colorBorderFocus ?? SGAppColors.info500, // <-- màu tím ở đây
                width: widget.sizeBorderLine ?? 1,
              ),
            ),
            suffixIcon: (widget.isShowSuffixIcon ?? false)
                ? (widget.enableSearch && widget.controller.text.isNotEmpty)
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              widget.controller.clear();
                              if (!_isOpen) _showOverlay();
                            },
                            child: const Center(
                              child: Icon(Icons.clear,
                                  color: Colors.grey, size: 18),
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.arrow_drop_down)
                : null,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          onTap: () {
            if (_justSelected) {
              return;
            }
            _focusNode.requestFocus();
            if (!_isOpen) _showOverlay();
            if (widget.enableSearch && widget.controller.text.isNotEmpty) {
              widget.controller.clear();
            }
          },
          onEditingComplete: () {
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
          },
        ),
      ),
    );
  }
}
