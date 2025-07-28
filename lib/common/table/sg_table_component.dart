import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';

class SgTableColumn<T> {
  final String title;
  final Widget Function(T item) cellBuilder;
  final dynamic Function(T item)? sortValueGetter;
  final String Function(T item)? searchValueGetter;
  final TextAlign titleAlignment;
  final TextAlign cellAlignment;
  final double? width;
  final bool isNumeric;
  final bool searchable;
  final bool fixedWidth;

  SgTableColumn({
    required this.title,
    required this.cellBuilder,
    this.sortValueGetter,
    this.searchValueGetter,
    this.titleAlignment = TextAlign.left,
    this.cellAlignment = TextAlign.left,
    this.width,
    this.isNumeric = false,
    this.searchable = true,
    this.fixedWidth = false,
  });
}

class SgTableActionColumn<T> extends SgTableColumn<T> {
  final Function(T)? onViewAction;
  final Function(T)? onEditAction;
  final Function(T)? onDeleteAction;
  final Color? colorItemView;
  final Color? colorItemEdit;
  final Color? colorItemDelete;
  final double? sizeIcon;

  SgTableActionColumn({
    this.colorItemView,
    this.colorItemEdit,
    this.colorItemDelete,
    this.sizeIcon,
    super.title = "Hành động",
    super.width = 120,
    super.fixedWidth = true,
    this.onViewAction,
    this.onEditAction,
    this.onDeleteAction,
  }) : super(
          cellBuilder: (item) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onViewAction != null)
                IconButton(
                  icon: Icon(Icons.visibility, size: sizeIcon ?? 20),
                  tooltip: 'Xem',
                  color: colorItemView ?? Colors.green,
                  onPressed: () => onViewAction(item),
                  constraints: const BoxConstraints(minWidth: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              if (onEditAction != null)
                IconButton(
                  icon: Icon(Icons.edit, size: sizeIcon ?? 20),
                  tooltip: 'Sửa',
                  color: colorItemEdit ?? Colors.blue,
                  onPressed: () => onEditAction(item),
                  constraints: const BoxConstraints(minWidth: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              if (onDeleteAction != null)
                IconButton(
                  icon: Icon(Icons.delete, size: sizeIcon ?? 20),
                  tooltip: 'Xóa',
                  color: colorItemDelete ?? Colors.red,
                  onPressed: () => onDeleteAction(item),
                  constraints: const BoxConstraints(minWidth: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
            ],
          ),
          titleAlignment: TextAlign.center,
          cellAlignment: TextAlign.center,
        );
}

class TableColumnBuilder {
  static SgTableColumn<T> createTextColumn<T>({
    required String title,
    required String Function(T) getValue,
    dynamic Function(T)? sortValue,
    String Function(T)? searchValue,
    TextAlign align = TextAlign.center,
    double? width,
    bool fixedWidth = false,
    double? fontSize,
    int? maxLines,
    bool isNumeric = false,
    Color? textColor,
    bool searchable = true,
  }) {
    return SgTableColumn<T>(
      title: title,
      cellBuilder: (item) => SGText(
        text: getValue(item),
        size: fontSize ?? 14,
        color: textColor ?? SGAppColors.dark,
        textAlign: align,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines ?? 2,
      ),
      sortValueGetter: sortValue ?? ((item) => getValue(item)),
      searchValueGetter: searchValue ?? ((item) => getValue(item)),
      cellAlignment: align,
      titleAlignment: align,
      width: width,
      fixedWidth: fixedWidth,
      isNumeric: isNumeric,
      searchable: searchable,
    );
  }
  
  /// Tạo cột với tên và ID bên dưới
  static SgTableColumn<T> createNameWithIdColumn<T>({
    required String title,
    required String Function(T) getName,
    required String Function(T) getId,
    dynamic Function(T)? sortValue,
    String Function(T)? searchValue,
    TextAlign align = TextAlign.left,
    double? width = 180,
    bool fixedWidth = false,
    bool searchable = true,
  }) {
    return SgTableColumn<T>(
      title: title,
      cellBuilder: (item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getName(item),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            getId(item),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      sortValueGetter: sortValue ?? ((item) => getName(item)),
      searchValueGetter: searchValue ?? ((item) => getName(item) + ' ' + getId(item)),
      cellAlignment: align,
      titleAlignment: align,
      width: width,
      fixedWidth: fixedWidth,
      searchable: searchable,
    );
  }

  /// Tạo cột trạng thái với badge màu
  static SgTableColumn<T> createStatusColumn<T>({
    required String title,
    required String Function(T) getStatus,
    Map<String, Color>? statusColors,
    dynamic Function(T)? sortValue,
    TextAlign align = TextAlign.center,
    double? width = 100,
    bool fixedWidth = false,
    bool searchable = true,
  }) {
    final defaultStatusColors = {
      'open': const Color(0xFF4573D2),
      'paid': const Color(0xFF12B76A),
      'inactive': const Color(0xFF667085),
      'due': const Color(0xFFF04438),
      'pending': const Color(0xFFF79009),
      'completed': const Color(0xFF12B76A),
      'approved': const Color(0xFF12B76A),
      'rejected': const Color(0xFFF04438),
      'cancelled': const Color(0xFF667085),
    };
    
    final mergedStatusColors = {...defaultStatusColors, ...?statusColors};

    return SgTableColumn<T>(
      title: title,
      cellBuilder: (item) {
        final status = getStatus(item);
        final statusLower = status.toLowerCase();
        final backgroundColor = mergedStatusColors[statusLower] ?? const Color(0xFF667085);
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
      sortValueGetter: sortValue ?? ((item) => getStatus(item)),
      searchValueGetter: (item) => getStatus(item),
      cellAlignment: align,
      titleAlignment: align,
      width: width,
      fixedWidth: fixedWidth,
      searchable: searchable,
    );
  }
  
  /// Tạo cột tiền tệ với đơn vị tiền tệ bên dưới
  static SgTableColumn<T> createCurrencyColumn<T>({
    required String title,
    required double Function(T) getValue,
    String currency = 'CAD',
    String prefix = '\$',
    bool colorByValue = false,
    dynamic Function(T)? sortValue,
    TextAlign align = TextAlign.right,
    double? width = 100,
    bool fixedWidth = false,
    bool searchable = true,
  }) {
    return SgTableColumn<T>(
      title: title,
      cellBuilder: (item) {
        final value = getValue(item);
        final isNegative = value < 0;
        final color = colorByValue
            ? (isNegative ? const Color(0xFFF04438) : const Color(0xFF12B76A))
            : Colors.black;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              isNegative
                  ? '-$prefix${(-value).toStringAsFixed(2)}'
                  : '$prefix${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              currency,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      },
      sortValueGetter: sortValue ?? ((item) => getValue(item)),
      searchValueGetter: (item) => getValue(item).toString(),
      cellAlignment: align,
      titleAlignment: TextAlign.center,
      width: width,
      fixedWidth: fixedWidth,
      isNumeric: true,
      searchable: searchable,
    );
  }

  static SgTableColumn<T> createDateColumn<T>({
    required String title,
    required DateTime Function(T) getValue,
    DateFormat? format,
    TextAlign align = TextAlign.center,
    double? width = 180,
    bool fixedWidth = false,
    bool searchable = true,
  }) {
    final dateFormat = format ?? DateFormat('dd/MM/yyyy HH:mm:ss');
    return SgTableColumn<T>(
      title: title,
      cellBuilder: (item) => SGText(
        text: dateFormat.format(getValue(item)),
        size: 14,
        textAlign: align,
      ),
      sortValueGetter: getValue,
      searchValueGetter: (item) => dateFormat.format(getValue(item)),
      cellAlignment: align,
      titleAlignment: align,
      width: width,
      fixedWidth: fixedWidth,
      searchable: searchable,
    );
  }

  static SgTableActionColumn<T> createActionColumn<T>({
    String title = "Hành động",
    double? width = 120,
    bool fixedWidth = true,
    Function(T)? onViewAction,
    Function(T)? onEditAction,
    Function(T)? onDeleteAction,
    Color? colorItemView,
    Color? colorItemEdit,
    Color? colorItemDelete,
    double? sizeIcon,
  }) {
    return SgTableActionColumn<T>(
      colorItemView: colorItemView,
      colorItemEdit: colorItemEdit,
      colorItemDelete: colorItemDelete,
      sizeIcon: sizeIcon,
      title: title,
      width: width,
      fixedWidth: fixedWidth,
      onViewAction: onViewAction,
      onEditAction: onEditAction,
      onDeleteAction: onDeleteAction,
    );
  }
}
