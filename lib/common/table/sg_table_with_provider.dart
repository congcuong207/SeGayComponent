import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'sg_table_header.dart';
import 'sg_table_row.dart';
import 'sg_table_state_provider.dart';

/// Phiên bản SgTable sử dụng Provider để tối ưu hiệu năng
class SgTableWithProvider<T> extends StatefulWidget {
  //---------------------------
  // NHÓM DỮ LIỆU CHÍNH
  //---------------------------
  /// Danh sách các cột của bảng
  final List<SgTableColumn<T>> columns;

  /// Dữ liệu hiển thị trong bảng
  final List<T> data;

  //---------------------------
  // NHÓM KÍCH THƯỚC & GIAO DIỆN
  //---------------------------
  /// Chiều cao của mỗi hàng
  final double rowHeight;

  /// Bo tròn viền của bảng
  final BorderRadius? borderRadius;

  /// Controller để điều khiển cuộn dọc
  final ScrollController? verticalController;

  //---------------------------
  // NHÓM MÀU SẮC
  //---------------------------
  /// Màu chữ trong header
  final Color? textHeaderColor;

  /// Màu nền của header
  final Color headerBackgroundColor;

  /// Màu nền cho hàng lẻ
  final Color oddRowBackgroundColor;

  /// Màu nền cho hàng chẵn
  final Color evenRowBackgroundColor;

  /// Màu khi hàng được chọn (hover hoặc click)
  final Color selectedRowColor;

  /// Màu khi hàng được đánh dấu với checkbox
  final Color checkedRowColor;

  //---------------------------
  // NHÓM ĐƯỜNG KẺ LƯỚI
  //---------------------------
  /// Màu của đường kẻ lưới
  final Color gridLineColor;

  /// Độ dày của đường kẻ lưới
  final double gridLineWidth;

  /// Hiển thị đường kẻ dọc
  final bool showVerticalLines;

  /// Hiển thị đường kẻ ngang
  final bool showHorizontalLines;

  /// Hiển thị đường kẻ cuối cùng bên trái/phải
  final bool showLastLineLeftRight;

  /// Hiển thị đường kẻ cuối cùng trên/dưới
  final bool showLastLineTopBottom;

  //---------------------------
  // NHÓM TƯƠNG TÁC & LỰA CHỌN
  //---------------------------
  /// Cho phép chọn hàng khi click
  final bool allowRowSelection;

  /// Callback khi nhấp vào một hàng
  final Function(T)? onRowTap;

  //---------------------------
  // NHÓM TÌM KIẾM & LỌC
  //---------------------------
  /// Từ khóa tìm kiếm
  final String? searchTerm;

  /// Tìm kiếm phân biệt chữ hoa/thường
  final bool caseSensitiveSearch;

  /// Hàm lọc tùy chỉnh
  final bool Function(T)? customFilter;

  //---------------------------
  // NHÓM CHECKBOX
  //---------------------------
  /// Hiển thị cột checkbox chọn nhiều
  final bool showCheckboxes;

  /// Callback khi thay đổi lựa chọn checkbox
  final Function(List<T>)? onSelectionChanged;

  /// Chiều rộng của cột checkbox
  final double checkboxColumnWidth;

  /// Tỷ lệ kích thước checkbox
  final double? scaleCheckbox;

  /// Màu khi checkbox được chọn
  final Color? activeColor;

  /// Màu dấu check
  final Color? checkColor;

  /// Viền của checkbox
  final BorderSide? side;

  /// Hình dạng của checkbox
  final BeveledRectangleBorder? shape;

  //---------------------------
  // NHÓM CỘT HÀNH ĐỘNG
  //---------------------------
  /// Hiển thị cột hành động
  final bool showActions;

  /// Callback khi nhấn nút xem chi tiết
  final Function(T)? onViewAction;

  /// Callback khi nhấn nút chỉnh sửa
  final Function(T)? onEditAction;

  /// Callback khi nhấn nút xóa
  final Function(T)? onDeleteAction;

  /// Màu nút xem chi tiết
  final Color? actionViewColor;

  /// Màu nút chỉnh sửa
  final Color? actionEditColor;

  /// Màu nút xóa
  final Color? actionDeleteColor;

  /// Kích thước icon trong cột hành động
  final double? actionIconSize;

  /// Chiều rộng của cột hành động
  final double? actionColumnWidth;

  /// Tiêu đề của cột hành động
  final String? actionColumnTitle;

  const SgTableWithProvider(
      {super.key,
      // NHÓM DỮ LIỆU CHÍNH
      required this.columns,
      required this.data,

      // NHÓM KÍCH THƯỚC & GIAO DIỆN
      this.rowHeight = 48.0,
      this.borderRadius,
      this.verticalController,

      // NHÓM MÀU SẮC
      this.textHeaderColor,
      this.headerBackgroundColor = SGAppColors.neutral100,
      this.oddRowBackgroundColor = Colors.white,
      this.evenRowBackgroundColor = SGAppColors.neutral200,
      this.selectedRowColor = SGAppColors.info100,
      this.checkedRowColor = const Color(0xFFE3F2FD),

      // NHÓM ĐƯỜNG KẺ LƯỚI
      this.gridLineColor = SGAppColors.neutral200,
      this.gridLineWidth = 1.0,
      this.showVerticalLines = true,
      this.showHorizontalLines = true,
      this.showLastLineLeftRight = false,
      this.showLastLineTopBottom = false,

      // NHÓM TƯƠNG TÁC & LỰA CHỌN
      this.allowRowSelection = true,
      this.onRowTap,

      // NHÓM TÌM KIẾM & LỌC
      this.searchTerm,
      this.caseSensitiveSearch = false,
      this.customFilter,

      // NHÓM CHECKBOX
      this.showCheckboxes = false,
      this.onSelectionChanged,
      this.checkboxColumnWidth = 50.0,
      this.scaleCheckbox = 1,
      this.activeColor = Colors.blueAccent,
      this.checkColor = Colors.white,
      this.side,
      this.shape,

      // NHÓM CỘT HÀNH ĐỘNG
      this.showActions = false,
      this.onViewAction,
      this.onEditAction,
      this.onDeleteAction,
      this.actionViewColor,
      this.actionEditColor,
      this.actionDeleteColor,
      this.actionIconSize,
      this.actionColumnWidth = 120.0,
      this.actionColumnTitle = "Hành động"});

  @override
  State<SgTableWithProvider<T>> createState() => _SgTableWithProviderState<T>();
}

class _SgTableWithProviderState<T> extends State<SgTableWithProvider<T>> {
  // Controller cuộn
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  // Danh sách cột hiệu quả (bao gồm cột checkbox và hành động nếu cần)
  late List<SgTableColumn<T>> _effectiveColumns;

  // Cache màu nền
  final Map<String, Color> _backgroundColorCache = {};

  // Cache kết quả tính toán width
  final Map<String, double> _columnWidthCache = {};

  // Lưu trữ thông tin filter để xử lý trong Provider
  String? _lastSearchTerm;
  bool _lastCaseSensitiveSearch = false;
  dynamic _lastCustomFilter;
  bool _needsFilterUpdate = false;
  bool _needsDataUpdate = false;

  @override
  void initState() {
    super.initState();
    _buildEffectiveColumns();
    _initColorCache();

    // Lưu giá trị filter ban đầu
    _lastSearchTerm = widget.searchTerm;
    _lastCaseSensitiveSearch = widget.caseSensitiveSearch;
    _lastCustomFilter = widget.customFilter;
    _needsFilterUpdate = widget.searchTerm != null || widget.customFilter != null;

    // Đăng ký listener cho scroll controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollController.addListener(_scrollListener);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _backgroundColorCache.clear();
    _columnWidthCache.clear(); // Xóa cache column width
    super.dispose();
  }

  @override
  void didUpdateWidget(SgTableWithProvider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool columnsChanged = widget.columns != oldWidget.columns ||
        widget.showActions != oldWidget.showActions ||
        widget.showCheckboxes != oldWidget.showCheckboxes ||
        widget.actionColumnTitle != oldWidget.actionColumnTitle;

    if (columnsChanged) {
      _buildEffectiveColumns();
      _columnWidthCache.clear(); // Xóa cache khi cột thay đổi
    }

    // Đánh dấu cần cập nhật filter nếu có thay đổi
    final bool searchChanged = widget.searchTerm != oldWidget.searchTerm ||
        widget.caseSensitiveSearch != oldWidget.caseSensitiveSearch ||
        widget.customFilter != oldWidget.customFilter;

    if (searchChanged) {
      _lastSearchTerm = widget.searchTerm;
      _lastCaseSensitiveSearch = widget.caseSensitiveSearch;
      _lastCustomFilter = widget.customFilter;
      _needsFilterUpdate = true;
    }

    // Đánh dấu cần cập nhật dữ liệu
    if (widget.data != oldWidget.data) {
      _needsDataUpdate = true;
    }
  }

  // Lắng nghe sự kiện cuộn để tối ưu hiệu suất - Cải tiến với throttling
  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final scrolling = _scrollController.position.isScrollingNotifier.value;
    if (scrolling != _isScrolling) {
      setState(() => _isScrolling = scrolling);
    }
  }

  // Xây dựng danh sách cột hiệu quả
  void _buildEffectiveColumns() {
    _effectiveColumns = [];

    // Thêm cột checkbox nếu cần
    if (widget.showCheckboxes) {
      _effectiveColumns.add(
        SgTableColumn<T>(
          title: '',
          width: widget.checkboxColumnWidth,
          cellBuilder: (item) => Consumer<SgTableStateProvider<T>>(
            builder: (context, provider, _) => Transform.scale(
              scale: widget.scaleCheckbox,
              child: Checkbox(
                value: provider.selectedItems.contains(item),
                onChanged: (selected) => provider.toggleSelectItem(item, selected),
                activeColor: widget.activeColor,
                checkColor: widget.checkColor,
                side: widget.side,
                shape: widget.shape,
              ),
            ),
          ),
          cellAlignment: TextAlign.center,
          titleAlignment: TextAlign.center,
        ),
      );
    }

    // Thêm các cột thông thường
    _effectiveColumns.addAll(widget.columns);

    // Thêm cột hành động nếu được bật
    if (widget.showActions) {
      _effectiveColumns.add(
        SgTableActionColumn<T>(
          colorItemView: widget.actionViewColor,
          colorItemEdit: widget.actionEditColor,
          colorItemDelete: widget.actionDeleteColor,
          sizeIcon: widget.actionIconSize,
          title: widget.actionColumnTitle ?? 'Hành động',
          width: widget.actionColumnWidth,
          onViewAction: widget.onViewAction,
          onEditAction: widget.onEditAction,
          onDeleteAction: widget.onDeleteAction,
        ),
      );
    }
  }

  // Khởi tạo cache màu sắc
  void _initColorCache() {
    // Selected & checked
    _backgroundColorCache['selected_checked_even'] = widget.selectedRowColor;
    _backgroundColorCache['selected_checked_odd'] = widget.selectedRowColor;

    // Selected only
    _backgroundColorCache['selected_even'] = widget.selectedRowColor;
    _backgroundColorCache['selected_odd'] = widget.selectedRowColor;

    // Checked only
    _backgroundColorCache['checked_even'] = widget.checkedRowColor;
    _backgroundColorCache['checked_odd'] = widget.checkedRowColor;

    // Normal rows
    _backgroundColorCache['even'] = widget.evenRowBackgroundColor;
    _backgroundColorCache['odd'] = widget.oddRowBackgroundColor;
  }

  // Lấy màu nền cho hàng dựa trên trạng thái
  Color _getBackgroundColor(int index, bool isSelected, bool isChecked) {
    final isEven = index % 2 == 0;
    String key;

    if (isSelected) {
      key = isChecked
          ? (isEven ? 'selected_checked_even' : 'selected_checked_odd')
          : (isEven ? 'selected_even' : 'selected_odd');
    } else {
      key = isChecked ? (isEven ? 'checked_even' : 'checked_odd') : (isEven ? 'even' : 'odd');
    }

    return _backgroundColorCache[key]!;
  }

  @override
  Widget build(BuildContext context) {
    return SgTableStateProvider.create<T>(
      data: widget.data,
      columns: _effectiveColumns,
      onRowTap: widget.onRowTap,
      onSelectionChanged: widget.onSelectionChanged,
      builder: (context, provider, _) {
        // Xử lý các cập nhật cần thiết
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_needsDataUpdate) {
            provider.updateData(widget.data);
            _needsDataUpdate = false;
          }

          if (_needsFilterUpdate) {
            provider.filter(
              searchTerm: _lastSearchTerm,
              caseSensitiveSearch: _lastCaseSensitiveSearch,
              customFilter: _lastCustomFilter,
              columns: widget.columns,
            );
            _needsFilterUpdate = false;
          }
        });

        final totalWidth = _calculateTotalWidth(provider.columnWidths);
        final screenWidth = MediaQuery.of(context).size.width;
        final effectiveWidth = totalWidth > screenWidth ? totalWidth : screenWidth;

        final exactHeight = widget.rowHeight + (provider.sortedData.length * widget.rowHeight);

        return SizedBox(
          width: totalWidth,
          height: exactHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header với RepaintBoundary
              RepaintBoundary(
                child: SgTableHeader<T>(
                  columns: _effectiveColumns,
                  headerBackgroundColor: widget.headerBackgroundColor,
                  gridLineColor: widget.gridLineColor,
                  gridLineWidth: widget.gridLineWidth,
                  textHeaderColor: widget.textHeaderColor,
                  showLastLineLeftRight: widget.showLastLineLeftRight,
                  showVerticalLines: widget.showVerticalLines,
                  rowHeight: widget.rowHeight,
                  totalWidth: totalWidth,
                  effectiveWidth: effectiveWidth,
                  showCheckboxes: widget.showCheckboxes,
                  columnWidths: provider.columnWidths,
                  onSortColumn: (index) => provider.toggleSort(index, _effectiveColumns),
                  onStartResize: (index, startX) => provider.startResize(index, startX),
                  onUpdateResize: (currentX) => provider.updateResize(currentX),
                  onEndResize: () => provider.endResize(),
                  onToggleSelectAll: (selected) => provider.toggleSelectAll(selected),
                  allSelected: provider.allSelected,
                  sortColumnIndex: provider.sortColumnIndex,
                  sortDirection: provider.sortDirection,
                  checkboxColumnWidth: widget.checkboxColumnWidth,
                  scaleCheckbox: widget.scaleCheckbox,
                  activeColor: widget.activeColor,
                  checkColor: widget.checkColor,
                  side: widget.side,
                  shape: widget.shape,
                ),
              ),

              // Phần thân bảng với ListView được cải tiến
              Expanded(
                child: ListView.builder(
                  controller: widget.verticalController ?? _scrollController,
                  physics: const ClampingScrollPhysics(),
                  key: PageStorageKey<String>('table_${widget.hashCode}'),
                  clipBehavior: Clip.hardEdge,
                  cacheExtent: widget.rowHeight * 600,
                  itemCount: provider.sortedData.length,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                  itemExtent: widget.rowHeight, // Thêm itemExtent cố định
                  findChildIndexCallback: (key) {
                    // Logic tìm index từ key để tái sử dụng widget
                    if (key is ValueKey<String>) {
                      final keyString = key.value;
                      final parts = keyString.split('_');
                      if (parts.length > 1) {
                        return int.tryParse(parts.last);
                      }
                    }
                    return null;
                  },
                  itemBuilder: (context, index) {
                    final item = provider.sortedData[index];

                    return Selector<SgTableStateProvider<T>, _RowState>(
                      selector: (context, provider) => _RowState(
                        isSelected: provider.selectedRowIndex == index,
                        isChecked: provider.selectedItems.contains(item),
                      ),
                      builder: (context, rowState, _) {
                        return SgTableRow<T>(
                          key: ValueKey<String>('${widget.hashCode}_row_$index'),
                          item: item,
                          index: index,
                          totalRows: provider.sortedData.length,
                          columns: _effectiveColumns,
                          rowHeight: widget.rowHeight,
                          totalWidth: totalWidth,
                          effectiveWidth: effectiveWidth,
                          isSelected: rowState.isSelected,
                          isChecked: rowState.isChecked,
                          showHorizontalLines: widget.showHorizontalLines,
                          showLastLineTopBottom: widget.showLastLineTopBottom,
                          gridLineColor: widget.gridLineColor,
                          gridLineWidth: widget.gridLineWidth,
                          backgroundColor: _getBackgroundColor(index, rowState.isSelected, rowState.isChecked),
                          onRowSelected: (idx) {
                            if (widget.allowRowSelection) {
                              provider.selectRow(idx);
                            }
                          },
                          onHover: (idx, isHovering) {
                            if (!_isScrolling && widget.allowRowSelection) {
                              if (isHovering && provider.selectedRowIndex != idx) {
                                provider.selectRow(idx);
                              } else if (!isHovering && provider.selectedRowIndex == idx) {
                                provider.selectRow(null);
                              }
                            }
                          },
                          columnWidths: provider.columnWidths,
                          showVerticalLines: widget.showVerticalLines,
                          showLastLineLeftRight: widget.showLastLineLeftRight,
                          showCheckboxes: widget.showCheckboxes,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Tính tổng chiều rộng của bảng - tối ưu với cache
  double _calculateTotalWidth(Map<int, double> columnWidths) {
    // Tạo key cho cache từ giá trị columnWidths
    final cacheKey = columnWidths.entries.map((e) => '${e.key}:${e.value}').join('_');

    // Kiểm tra cache trước khi tính toán
    if (_columnWidthCache.containsKey(cacheKey)) {
      return _columnWidthCache[cacheKey]!;
    }

    double totalWidth = 0;
    for (int i = 0; i < _effectiveColumns.length; i++) {
      totalWidth += columnWidths[i] ?? (_effectiveColumns[i].width ?? 120.0);
    }

    // Lưu kết quả vào cache
    _columnWidthCache[cacheKey] = totalWidth;
    return totalWidth;
  }
}

class _RowState {
  final bool isSelected;
  final bool isChecked;

  const _RowState({required this.isSelected, required this.isChecked});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _RowState &&
          runtimeType == other.runtimeType &&
          isSelected == other.isSelected &&
          isChecked == other.isChecked;

  @override
  int get hashCode => isSelected.hashCode ^ isChecked.hashCode;
}
