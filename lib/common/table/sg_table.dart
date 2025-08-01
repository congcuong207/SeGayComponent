// Import các thư viện cần thiết
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'dart:async'; // Import Timer

// Enum để định nghĩa hướng sắp xếp
enum SortDirection { none, ascending, descending }

// Widget chính SgTable - Bảng dữ liệu có thể tùy chỉnh với nhiều tính năng
class SgTable<T> extends StatefulWidget {
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
  final TextStyle? titleStyleHeader;

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

  // Checkbox selection

  //---------------------------
  // NHÓM CHECKBOX
  //---------------------------
  /// Hiển thị cột checkbox chọn nhiều
  final bool showCheckboxes;

  /// Callback khi thay đổi lựa chọn checkbox
  final Function(List<T>)? onSelectionChanged;

  /// Chiều rộng của cột checkbox
  final double checkboxColumnWidth;

  // Action column options

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
  // Row hover options
  final Color? rowHoverColor;
  final Duration rowHoverDuration;
  final double widthScreen;

  // Constructor với nhiều tham số có giá trị mặc định
  const SgTable(
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
      this.actionColumnTitle = "Hành động",
      this.titleStyleHeader,
      this.rowHoverColor,
      required this.rowHoverDuration,
      required this.widthScreen});

  @override
  State<SgTable<T>> createState() => _SgTableState<T>();
}

// State class để quản lý trạng thái của bảng
class _SgTableState<T> extends State<SgTable<T>> {
  //---------------------------
  // BIẾN TRẠNG THÁI
  //---------------------------
  // Trạng thái sắp xếp
  int? _sortColumnIndex;
  SortDirection _sortDirection = SortDirection.none;

  // Trạng thái dữ liệu
  late List<T> _sortedData;
  late List<T> _filteredData;
  int? _selectedRowIndex;
  late List<SgTableColumn<T>> _effectiveColumns;
  String? _lastSearchTerm;

  // Checkbox selection state

  // Trạng thái checkbox selection
  final Set<T> _selectedItems = {};
  bool _allSelected = false;

  // Trạng thái kích thước cột
  Map<int, double> _columnWidths = {};
  Map<int, double> _originalColumnWidths = {};
  int? _resizingColumnIndex;
  double? _resizeStartX;
  double? _resizeStartWidth;

  // Row hover state
  int? _hoveredRowIndex;

  // Trạng thái cuộn và tối ưu hiệu suất
  bool _isScrolling = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollEndTimer;
  Timer? _resizeDebounceTimer; // Debounce timer cho resize

  // QUẢN LÝ VÒNG ĐỜI WIDGET
  //---------------------------
  @override
  void initState() {
    super.initState();
    _processData();

    // Đăng ký listener sau khi build frame đầu tiên
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
    _scrollEndTimer?.cancel();
    _resizeDebounceTimer?.cancel(); // Hủy timer resize
    _backgroundColorCache.clear(); // Xóa cache màu nền
    super.dispose();
  }

  @override
  void didUpdateWidget(SgTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _sortedData = List.from(widget.data);
      _filterAndSortData();

      // Update selected items when data changes
      if (widget.showCheckboxes) {
        _selectedItems.removeWhere((item) => !widget.data.contains(item));
        _updateAllSelectedState();
      }
    }

    if (widget.columns != oldWidget.columns ||
        widget.showActions != oldWidget.showActions ||
        widget.showCheckboxes != oldWidget.showCheckboxes ||
        widget.actionColumnTitle != oldWidget.actionColumnTitle) {
      _buildEffectiveColumns();
      _initColumnWidths();
    }

    // Kiểm tra các thay đổi quan trọng để cập nhật bảng
    final bool dataChanged = widget.data != oldWidget.data;
    final bool columnsChanged = widget.columns != oldWidget.columns ||
        widget.showActions != oldWidget.showActions ||
        widget.showCheckboxes != oldWidget.showCheckboxes ||
        widget.actionColumnTitle != oldWidget.actionColumnTitle;
    final bool searchChanged = widget.searchTerm != _lastSearchTerm;

    if (dataChanged || columnsChanged || searchChanged) {
      if (dataChanged) {
        _sortedData = List.from(widget.data);
        _filterAndSortData();

        // Cập nhật danh sách item đã chọn khi dữ liệu thay đổi
        if (widget.showCheckboxes) {
          _selectedItems.removeWhere((item) => !widget.data.contains(item));
          _updateAllSelectedState();
        }
      }

      if (columnsChanged) {
        _buildEffectiveColumns();
        _initColumnWidths();
      }

      if (widget.searchTerm != _lastSearchTerm) {
        _lastSearchTerm = widget.searchTerm;
        _filterAndSortData();
      }
    }
  }

  //---------------------------
  // XỬ LÝ DỮ LIỆU BAN ĐẦU
  //---------------------------
  // Xử lý dữ liệu ban đầu
  void _processData() {
    _sortedData = List.from(widget.data);
    _filteredData = List.from(_sortedData);
    _buildEffectiveColumns();
    _initColumnWidths();
    _lastSearchTerm = widget.searchTerm;
    _filterData();
  }

  //---------------------------
  // QUẢN LÝ CUỘN
  //---------------------------
  // Lắng nghe sự kiện cuộn để tối ưu hiệu suất
  void _scrollListener() {
    // Kiểm tra nếu controller không có client
    if (!_scrollController.hasClients) return;

    // Đánh dấu đang cuộn khi có bất kỳ thay đổi nào về vị trí cuộn
    if (_scrollController.position.isScrollingNotifier.value && !_isScrolling) {
      // Không gọi setState liên tục khi đang cuộn
      _isScrolling = true;

      // Reset timer mỗi khi nhận sự kiện cuộn
      _scrollEndTimer?.cancel();
      _scrollEndTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted) {
          _isScrolling = false;
        }
      });
    }
  }

  // Cuộn đến một hàng cụ thể với animation
  void _animateToIndex(int index) {
    if (!_scrollController.hasClients) return;

    final itemPosition = index * widget.rowHeight;
    _scrollController.animateTo(
      itemPosition.toDouble(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //---------------------------
  // QUẢN LÝ CỘT
  //---------------------------
  // Xây dựng danh sách cột hiệu quả, bao gồm cột checkbox và hành động nếu cần
  void _buildEffectiveColumns() {
    _effectiveColumns = [];

    // Thêm cột checkbox nếu cần
    if (widget.showCheckboxes) {
      _effectiveColumns.add(
        SgTableColumn<T>(
          title: '',
          width: widget.checkboxColumnWidth,
          cellBuilder: (item) => Transform.scale(
            scale: widget.scaleCheckbox,
            child: Checkbox(
              value: _selectedItems.contains(item),
              onChanged: (selected) => _toggleSelectItem(item, selected),
              activeColor: widget.activeColor,
              checkColor: widget.checkColor,
              side: widget.side,
              shape: widget.shape,
            ),
          ),
          cellAlignment: TextAlign.center,
          titleAlignment: TextAlign.center,
        ),
      );
    }

    // Add regular columns

    // Thêm các cột thông thường
    _effectiveColumns.addAll(widget.columns);

    // Add action column if enabled

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

  // Khởi tạo chiều rộng các cột
  void _initColumnWidths() {
    _columnWidths = {};
    for (int i = 0; i < _effectiveColumns.length; i++) {
      if (_effectiveColumns[i].width != null) {
        _columnWidths[i] = _effectiveColumns[i].width!;
      } else {
        // Default width if not specified
        _columnWidths[i] = 120.0;
        if (_effectiveColumns[i].isFullWidth) {
          if (widget.showCheckboxes && widget.showActions) {
            _columnWidths[i] = (widget.widthScreen - widget.checkboxColumnWidth - widget.actionColumnWidth!) /
                (_effectiveColumns.length - 2);
          } else if (widget.showCheckboxes) {
            _columnWidths[i] = (widget.widthScreen - widget.checkboxColumnWidth) / (_effectiveColumns.length - 1);
          } else if (widget.showActions) {
            _columnWidths[i] = (widget.widthScreen - widget.actionColumnWidth!) / (_effectiveColumns.length - 1);
          } else {
            _columnWidths[i] = widget.widthScreen / _effectiveColumns.length;
          }
        }
      }
    }
    _originalColumnWidths = Map.from(_columnWidths);
  }

  //---------------------------
  // QUẢN LÝ RESIZE CỘT
  //---------------------------
  // Bắt đầu quá trình resize cột
  void _startResize(int columnIndex, double startX) {
    setState(() {
      _resizingColumnIndex = columnIndex;
      _resizeStartX = startX;
      _resizeStartWidth = _columnWidths[columnIndex];
    });
  }

  // Cập nhật kích thước cột khi đang resize
  void _updateResize(double currentX) {
    if (_resizingColumnIndex == null || _resizeStartX == null || _resizeStartWidth == null) {
      return;
    }

    final delta = currentX - _resizeStartX!;
    final originalWidth = _originalColumnWidths[_resizingColumnIndex] ?? 120.0;
    final newWidth = _resizeStartWidth! + delta;

    if (newWidth >= originalWidth) {
      // Debounce resize updates để tránh rebuild quá nhiều
      _resizeDebounceTimer?.cancel();
      _resizeDebounceTimer = Timer(const Duration(milliseconds: 16), () {
        if (mounted) {
          setState(() {
            _columnWidths[_resizingColumnIndex!] = newWidth;
          });
        }
      });
    }
  }

  // Kết thúc quá trình resize cột
  void _endResize() {
    _resizeDebounceTimer?.cancel(); // Hủy bất kỳ resize updates nào đang chờ xử lý
    setState(() {
      _resizingColumnIndex = null;
      _resizeStartX = null;
      _resizeStartWidth = null;
    });
  }

  //---------------------------
  // XỬ LÝ LỌC & SẮP XẾP
  //---------------------------
  // Lọc và sắp xếp dữ liệu
  void _filterAndSortData() {
    _filterData();
    _sortData();
  }

  // Lọc dữ liệu dựa trên searchTerm và customFilter
  void _filterData() {
    if ((widget.searchTerm == null || widget.searchTerm!.isEmpty) && widget.customFilter == null) {
      _filteredData = List.from(widget.data);
    } else {
      _filteredData = widget.data.where((item) {
        if (widget.customFilter != null && !widget.customFilter!(item)) {
          return false;
        }

        if (widget.searchTerm != null && widget.searchTerm!.isNotEmpty) {
          final term = widget.caseSensitiveSearch ? widget.searchTerm! : widget.searchTerm!.toLowerCase();

          for (var column in widget.columns) {
            if (column.searchable && column.searchValueGetter != null) {
              final value = column.searchValueGetter!(item);
              final stringValue = widget.caseSensitiveSearch ? value : value.toLowerCase();
              if (stringValue.contains(term)) {
                return true;
              }
            }
          }
          return false;
        }
        return true;
      }).toList();
    }

    setState(() {
      _sortedData = List.from(_filteredData);
    });
  }

  // Sắp xếp dữ liệu dựa trên cột được chọn
  void _sortData() {
    if (_sortColumnIndex == null ||
        _sortDirection == SortDirection.none ||
        _sortColumnIndex! >= widget.columns.length ||
        widget.columns[_sortColumnIndex!].sortValueGetter == null) {
      return;
    }

    final sortValueGetter = widget.columns[_sortColumnIndex!].sortValueGetter!;

    // Sử dụng compute để đưa việc sắp xếp vào thread riêng nếu danh sách lớn
    if (_sortedData.length > 1000) {
      compute<_SortParams<T>, List<T>>(
          _sortCompute,
          _SortParams(
            data: _sortedData,
            getter: sortValueGetter,
            direction: _sortDirection,
          )).then((result) {
        setState(() {
          _sortedData = result;
        });
      });
    } else {
      setState(() {
        _sortedData.sort((a, b) {
          return _compareItems(a, b, sortValueGetter, _sortDirection);
        });
      });
    }
  }

  // Phương thức so sánh để sử dụng trong cả sắp xếp thường và compute
  static int _compareItems<T>(T a, T b, dynamic Function(T) getter, SortDirection direction) {
    final aValue = getter(a);
    final bValue = getter(b);

    if (aValue == null && bValue == null) return 0;
    if (aValue == null) {
      return direction == SortDirection.ascending ? -1 : 1;
    }
    if (bValue == null) {
      return direction == SortDirection.ascending ? 1 : -1;
    }

    int comparison;
    if (aValue is String && bValue is String) {
      comparison = aValue.toLowerCase().compareTo(bValue.toLowerCase());
    } else if (aValue is num && bValue is num) {
      comparison = aValue.compareTo(bValue);
    } else if (aValue is DateTime && bValue is DateTime) {
      comparison = aValue.compareTo(bValue);
    } else if (aValue is bool && bValue is bool) {
      comparison = aValue ? (bValue ? 0 : 1) : (bValue ? -1 : 0);
    } else {
      comparison = aValue.toString().compareTo(bValue.toString());
    }

    return direction == SortDirection.ascending ? comparison : -comparison;
  }

  // Phương thức sắp xếp cho compute
  static List<T> _sortCompute<T>(_SortParams<T> params) {
    final result = List<T>.from(params.data);
    result.sort((a, b) => _compareItems(a, b, params.getter, params.direction));
    return result;
  }

  // Xử lý sự kiện sắp xếp khi nhấp vào tiêu đề cột
  void _onSortColumn(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        if (_sortDirection == SortDirection.none) {
          _sortDirection = SortDirection.ascending;
        } else if (_sortDirection == SortDirection.ascending) {
          _sortDirection = SortDirection.descending;
        } else {
          _sortDirection = SortDirection.none;
        }
      } else {
        _sortColumnIndex = columnIndex;
        _sortDirection = SortDirection.ascending;
      }

      if (_sortDirection == SortDirection.none) {
        _sortedData = List.from(_filteredData);
      } else {
        _sortData();
      }
    });
  }

  //---------------------------
  // QUẢN LÝ CHECKBOX
  //---------------------------
  // Xử lý chọn tất cả các hàng
  void _toggleSelectAll(bool? selected) {
    if (selected == null) return;

    setState(() {
      _allSelected = selected;

      if (_allSelected) {
        _selectedItems.addAll(_sortedData);
      } else {
        _selectedItems.clear();
      }

      _notifySelectionChanged();
    });
  }

  // Xử lý chọn một hàng cụ thể
  void _toggleSelectItem(T item, bool? selected) {
    if (selected == null) return;

    setState(() {
      if (selected) {
        _selectedItems.add(item);
      } else {
        _selectedItems.remove(item);
      }

      _updateAllSelectedState();
      _notifySelectionChanged();
    });
  }

  // Cập nhật trạng thái chọn tất cả dựa trên các mục đã chọn
  void _updateAllSelectedState() {
    if (_sortedData.isEmpty) {
      _allSelected = false;
      return;
    }

    _allSelected = _sortedData.every((item) => _selectedItems.contains(item));
  }

  // Thông báo thay đổi lựa chọn qua callback
  void _notifySelectionChanged() {
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(_selectedItems.toList());
    }
  }

  //---------------------------
  // XỬ LÝ CHỌN HÀNG
  //---------------------------
  // Xử lý sự kiện khi chọn hàng với hiệu ứng animation
  void _onRowSelected(int index) {
    if (!widget.allowRowSelection) return;

    setState(() {
      if (_selectedRowIndex == index) {
        _selectedRowIndex = null;
      } else {
        _selectedRowIndex = index;
      }
    });

    // Đảm bảo hàng được chọn nằm trong tầm nhìn
    _animateToIndex(index);

    if (widget.onRowTap != null) {
      widget.onRowTap!(_sortedData[index]);
    }
  }

  //---------------------------
  // TÍNH TOÁN CHIỀU RỘNG
  //---------------------------
  // Tính tổng chiều rộng của bảng với caching để tối ưu
  double _calculateTotalWidth() {
    double totalWidth = 0;
    for (int i = 0; i < _effectiveColumns.length; i++) {
      totalWidth += _columnWidths[i] ?? (_effectiveColumns[i].width ?? 120.0);
    }
    return totalWidth;
  }

  //---------------------------
  // XỬ LÝ MÀU NỀN
  //---------------------------
  // Cache màu nền để tối ưu hiệu suất
  static const Map<bool, Map<bool, Map<bool, String>>> _backgroundColorKeys = {
    true: {
      true: {true: 'selected_checked_even', false: 'selected_checked_odd'},
      false: {true: 'selected_even', false: 'selected_odd'}
    },
    false: {
      true: {true: 'checked_even', false: 'checked_odd'},
      false: {true: 'even', false: 'odd'}
    }
  };

  // Cache cho màu nền
  final Map<String, Color> _backgroundColorCache = {};

  // Lấy màu nền cho hàng dựa trên trạng thái
  Color _getBackgroundColor(int index, bool isSelected, bool isChecked) {
    final isEven = index % 2 == 0;
    final key = _backgroundColorKeys[isSelected]![isChecked]![isEven]!;

    return _backgroundColorCache[key] ??= (() {
      if (isSelected) {
        return widget.selectedRowColor;
      } else if (isChecked) {
        return widget.checkedRowColor;
      } else {
        return isEven ? widget.evenRowBackgroundColor : widget.oddRowBackgroundColor;
      }
    })();
  }

  //---------------------------
  // XÂY DỰNG GIAO DIỆN
  //---------------------------
  @override
  Widget build(BuildContext context) {
    final totalWidth = _calculateTotalWidth();
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveWidth = totalWidth > screenWidth ? totalWidth : screenWidth;
    final exactHeight = widget.rowHeight + (_sortedData.length * widget.rowHeight);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: effectiveWidth,
            height: exactHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hàng tiêu đề - tối ưu với const và memoization
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.headerBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: widget.gridLineColor,
                        width: widget.gridLineWidth,
                      ),
                      top: BorderSide(
                        color: widget.gridLineColor,
                        width: widget.gridLineWidth,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: totalWidth,
                    height: widget.rowHeight,
                    child: Row(
                      children: _buildHeaderCells(false, effectiveWidth, totalWidth),
                    ),
                  ),
                ),
                // Phần thân bảng - với ListView.builder được tối ưu
                Expanded(
                  child: ListView.builder(
                    controller: widget.verticalController ?? _scrollController,
                    physics: const ClampingScrollPhysics(),
                    cacheExtent: widget.rowHeight * 100,
                    itemCount: _sortedData.length,
                    itemExtent: widget.rowHeight,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: true,
                    itemBuilder: (context, index) {
                      return _buildTableRow(index, effectiveWidth, totalWidth);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Xây dựng hàng dữ liệu
  Widget _buildTableRow(int index, double effectiveWidth, double totalWidth) {
    final isLast = index == _sortedData.length - 1;
    final isChecked = _selectedItems.contains(_sortedData[index]);
    final isSelected = _selectedRowIndex == index;

    // Sử dụng màu nền đã cache
    final backgroundColor = _getBackgroundColor(index, isSelected, isChecked);

    return AnimatedContainer(
      duration: widget.rowHoverDuration,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: widget.showHorizontalLines && !isLast
            ? Border(
                bottom: BorderSide(
                  color: widget.gridLineColor,
                  width: widget.gridLineWidth,
                ),
              )
            : null,
      ),
      child: SizedBox(
        width: effectiveWidth,
        height: widget.rowHeight,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoveredRowIndex = index),
          onExit: (_) => _onRowHoverExit(),
          child: InkWell(
            onTap: () => _onRowSelected(index),
            child: Row(
              children: _buildRowCells(
                _sortedData[index],
                false,
                effectiveWidth,
                totalWidth,
                index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Xây dựng các ô tiêu đề cho bảng
  List<Widget> _buildHeaderCells(bool shouldExpand, double screenWidth, double totalWidth) {
    return List.generate(_effectiveColumns.length, (index) {
      final column = _effectiveColumns[index];
      final hasSort = column.sortValueGetter != null;
      final isLast = index == _effectiveColumns.length - 1;

      // Special case for checkbox column

      // Trường hợp đặc biệt cho cột checkbox
      if (widget.showCheckboxes && index == 0) {
        return _buildCell(
          child: Center(
            child: Transform.scale(
              scale: widget.scaleCheckbox,
              child: Checkbox(
                value: _allSelected,
                onChanged: _toggleSelectAll,
                activeColor: widget.activeColor,
                checkColor: widget.checkColor,
                side: widget.side,
                shape: widget.shape,
              ),
            ),
          ),
          width: column.width,
          isLast: isLast,
          columnIndex: index,
          shouldExpand: shouldExpand,
          screenWidth: screenWidth,
          totalWidth: totalWidth,
        );
      }

      return _buildCell(
        child: InkWell(
          onTap: hasSort ? () => _onSortColumn(index) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: column.titleAlignment == TextAlign.center
                  ? MainAxisAlignment.center
                  : column.titleAlignment == TextAlign.right
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SGText(
                    text: column.title,
                    textAlign: column.titleAlignment,
                    color: widget.textHeaderColor ?? Colors.white,
                    style: widget.titleStyleHeader ??
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                    maxLines: column.maxLinesTitle,
                    overflow: column.maxLinesTitle == 1 ? TextOverflow.ellipsis : null,
                  ),
                ),
                // Only add the icon when it should actually be visible
                if (hasSort && _sortColumnIndex == index && _sortDirection != SortDirection.none) _buildSortIcon(index),
                // Chỉ thêm biểu tượng sắp xếp khi cần thiết
                if (hasSort && _sortColumnIndex == index && _sortDirection != SortDirection.none) _buildSortIcon(index),
              ],
            ),
          ),
        ),
        width: column.width,
        isLast: isLast,
        columnIndex: index,
        shouldExpand: shouldExpand,
        screenWidth: screenWidth,
        totalWidth: totalWidth,
      );
    });
  }

  // Tạo biểu tượng sắp xếp cho tiêu đề cột
  Widget _buildSortIcon(int columnIndex) {
    if (_sortColumnIndex != columnIndex || _sortDirection == SortDirection.none) {
      return const SizedBox.shrink(); // Return no space at all
    }

    return Icon(
      _sortDirection == SortDirection.ascending ? Icons.arrow_upward : Icons.arrow_downward,
      size: 16,
      color: SGAppColors.neutral700,
    );
  }

  // Xây dựng các ô dữ liệu cho hàng
  List<Widget> _buildRowCells(T item, bool shouldExpand, double screenWidth, double totalWidth, int rowIndex) {
    final cells = List.generate(_effectiveColumns.length, (index) {
      final column = _effectiveColumns[index];
      final isLast = index == _effectiveColumns.length - 1;

      // Special handling for checkbox column

      // Xử lý đặc biệt cho cột checkbox
      if (widget.showCheckboxes && index == 0) {
        return _buildCell(
          child: Center(
            child: column.cellBuilder(item),
          ),
          width: column.width,
          isLast: isLast,
          columnIndex: index,
          shouldExpand: shouldExpand,
          screenWidth: screenWidth,
          totalWidth: totalWidth,
        );
      }

      // Cho các cột dữ liệu thông thường
      return _buildCell(
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          alignment: column.cellAlignment == TextAlign.center
              ? Alignment.center
              : column.cellAlignment == TextAlign.right
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          child: column.cellBuilder(item),
        ),
        width: column.width,
        isLast: isLast,
        columnIndex: index,
        shouldExpand: shouldExpand,
        screenWidth: screenWidth,
        totalWidth: totalWidth,
      );
    });

    return cells;
  }

  // Xây dựng một ô (cell) cho bảng
  Widget _buildCell(
      {required Widget child,
      double? width,
      bool isLast = false,
      int? columnIndex,
      bool shouldExpand = false,
      double? screenWidth,
      double? totalWidth}) {
    final baseWidth = columnIndex != null ? (_columnWidths[columnIndex] ?? (width ?? 120.0)) : (width ?? 120.0);

    final adjustedWidth = baseWidth;

    if (isLast) {
      return SizedBox(
        width: adjustedWidth,
        height: widget.rowHeight,
        child: child,
      );
    }

    return Stack(
      children: [
        Container(
          width: adjustedWidth,
          height: widget.rowHeight,
          decoration: BoxDecoration(
            border: widget.showVerticalLines && !isLast
                ? Border(
                    right: BorderSide(
                      color: widget.gridLineColor,
                      width: widget.gridLineWidth,
                    ),
                  )
                : null,
          ),
          child: child,
        ),
        // Thêm handler để có thể resize cột
        if (columnIndex != null && !isLast)
          Positioned(
            right: -5,
            top: 0,
            bottom: 0,
            width: 10,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: GestureDetector(
                onHorizontalDragStart: (details) => _startResize(columnIndex, details.globalPosition.dx),
                onHorizontalDragUpdate: (details) => _updateResize(details.globalPosition.dx),
                onHorizontalDragEnd: (_) => _endResize(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _onRowHoverExit() {
    setState(() {
      _hoveredRowIndex = null;
    });
  }
}

// Lớp helper cho hàm compute
class _SortParams<T> {
  final List<T> data;
  final dynamic Function(T) getter;
  final SortDirection direction;

  _SortParams({
    required this.data,
    required this.getter,
    required this.direction,
  });
}
