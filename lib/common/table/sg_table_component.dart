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
  final bool isFullWidth;
  final TextStyle? titleStyle;
  final int? maxLinesTitle;

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
    this.isFullWidth = false,
    this.titleStyle,
    this.maxLinesTitle,
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
    double? fontSize,
    int? maxLines,
    int? maxLinesTitle,
    bool isNumeric = false,
    Color? textColor,
    bool searchable = true,
    TextStyle? styleTextValue,
    TextStyle? titleStyle,
    bool isFullWidth = false,
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
        style: styleTextValue,
      ),
      sortValueGetter: sortValue ?? ((item) => getValue(item)),
      searchValueGetter: searchValue ?? ((item) => getValue(item)),
      cellAlignment: align,
      titleAlignment: align,
      width: width,
      isNumeric: isNumeric,
      searchable: searchable,
      titleStyle: titleStyle,
      maxLinesTitle: maxLinesTitle ?? 1,
      isFullWidth: isFullWidth,
    );
  }

  static SgTableColumn<T> createDateColumn<T>({
    required String title,
    required DateTime Function(T) getValue,
    DateFormat? format,
    TextAlign align = TextAlign.center,
    double? width = 180,
    bool searchable = true,
    TextStyle? titleStyle,
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
      searchable: searchable,
      titleStyle: titleStyle,
    );
  }

  static SgTableActionColumn<T> createActionColumn<T>({
    String title = "Hành động",
    double? width = 120,
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
      onViewAction: onViewAction,
      onEditAction: onEditAction,
      onDeleteAction: onDeleteAction,
    );
  }
}
