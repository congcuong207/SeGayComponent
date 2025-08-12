import 'package:flutter/material.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class SgTableProps<T> {
  // Cài đặt dữ liệu & cột
  final List<T> data;
  final List<SgTableColumn<T>> columns;
  final bool showActions;
  final String? actionColumnTitle;
  final double? actionColumnWidth;
  final Color? actionViewColor;
  final Color? actionEditColor;
  final Color? actionDeleteColor;
  final double? actionIconSize;

  // Cài đặt Checkbox
  final bool showCheckboxes;
  final double checkboxColumnWidth;
  final Color? activeColor;
  final Color? checkColor;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final double scaleCheckbox;

  // Tìm kiếm & Lọc
  final String? searchTerm;
  final bool Function(T)? customFilter;
  final bool caseSensitiveSearch;

  // Chiều cao hàng
  final double rowHeight;

  // Màu sắc
  final Color headerBackgroundColor;
  final Color evenRowBackgroundColor;
  final Color oddRowBackgroundColor;
  final Color? textHeaderColor;
  final Color selectedRowColor;
  final Color checkedRowColor;
  final Color hoverRowColor;
  final Color pressedRowColor;
  final Color gridLineColor;

  // Tùy chọn lưới
  final bool showHorizontalLines;
  final bool showVerticalLines;
  final double gridLineWidth;

  // Lựa chọn hàng & Hover
  final bool allowRowSelection;
  final Duration? rowHoverDuration;

  // Sự kiện & Callbacks
  final Function(T)? onRowTap;
  final Function(List<T>)? onSelectionChanged;
  final Function(T)? onViewAction;
  final Function(T)? onEditAction;
  final Function(T)? onDeleteAction;

  // Bố cục
  final double widthScreen;
  final TextStyle? titleStyleHeader;

  // Cuộn
  final ScrollController? horizontalController;
  final ScrollController? verticalController;

  SgTableProps({
    required this.data,
    required this.columns,
    this.showActions = false,
    this.actionColumnTitle,
    this.actionColumnWidth = 120.0,
    this.actionViewColor,
    this.actionEditColor,
    this.actionDeleteColor,
    this.actionIconSize,
    this.showCheckboxes = false,
    this.checkboxColumnWidth = 50.0,
    this.scaleCheckbox = 1.0,
    this.activeColor,
    this.checkColor,
    this.side,
    this.shape,
    this.searchTerm,
    this.customFilter,
    this.caseSensitiveSearch = false,
    this.rowHeight = 50.0,
    this.headerBackgroundColor = const Color(0xFF78909C),
    this.evenRowBackgroundColor = Colors.white,
    this.oddRowBackgroundColor = const Color(0xFFF5F5F5),
    this.textHeaderColor,
    this.selectedRowColor = const Color(0xFFBBDEFB),
    this.checkedRowColor = const Color(0xFFE1F5FE),
    this.hoverRowColor = const Color(0xFFE3F2FD),
    this.pressedRowColor = const Color(0xFFB3E5FC),
    this.gridLineColor = const Color(0xFFE0E0E0),
    this.showHorizontalLines = true,
    this.showVerticalLines = true,
    this.gridLineWidth = 1.0,
    this.allowRowSelection = true,
    this.rowHoverDuration,
    this.onRowTap,
    this.onSelectionChanged,
    this.onViewAction,
    this.onEditAction,
    this.onDeleteAction,
    this.titleStyleHeader,
    this.widthScreen = 800.0,
    this.horizontalController,
    this.verticalController,
  });
}