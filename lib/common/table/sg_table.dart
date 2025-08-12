import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/enum/sort_direction.dart';
import 'package:se_gay_components/common/table/model/sg_table_controller.dart';
import 'package:se_gay_components/common/table/model/sg_table_props.dart';
import 'package:se_gay_components/common/table/model/sg_table_registry.dart';
import 'package:se_gay_components/common/table/provider/sg_table_provider.dart';

import 'package:se_gay_components/core/utils/sg_log.dart';

class SgTable<T> extends StatefulWidget {
  final SgTableProps<T> props;

  /// Khóa duy nhất cho bảng, được sử dụng để đăng ký controller
  final String? registryKey;

  const SgTable({
    super.key,
    required this.props,
    this.registryKey,
  });

  @override
  State<SgTable<T>> createState() => _SgTableState<T>();
}

// Lớp State để quản lý giao diện bảng
class _SgTableState<T> extends State<SgTable<T>> {
  // Key cho việc tạo lại provider
  final _providerKey = GlobalKey();

  // Trạng thái cuộn và tối ưu hóa
  late ScrollController _horizontalController;
  late ScrollController _verticalController;

  // Cache màu nền để tối ưu hiệu năng
  final Map<String, Color> _backgroundColorCache = {};

  // Tham chiếu đến controller để tránh tìm kiếm Provider trong sự kiện cuộn
  SgTableController<T>? _controller;

  // Hover & Press states
  int? _hoveredRowIndex;
  int? _pressedRowIndex;

  // QUẢN LÝ VÒNG ĐỜI WIDGET
  //---------------------------
  @override
  void initState() {
    super.initState();
    SGLog.info('SgTable', 'SgTable initState');

    _horizontalController = widget.props.horizontalController ?? ScrollController();
    _verticalController = widget.props.verticalController ?? ScrollController();

    // Tạo controller trực tiếp cho sự kiện cuộn
    _controller = SgTableController<T>(
      initialData: widget.props.data,
      columns: widget.props.columns,
      onSelectionChanged: widget.props.onSelectionChanged,
      onRowTap: widget.props.onRowTap,
      searchTerm: widget.props.searchTerm,
      showCheckboxes: widget.props.showCheckboxes,
      showActions: widget.props.showActions,
      actionColumnTitle: widget.props.actionColumnTitle,
      actionColumnWidth: widget.props.actionColumnWidth,
      checkboxColumnWidth: widget.props.checkboxColumnWidth,
      widthScreen: widget.props.widthScreen,
    );

    // Đăng ký controller với registry nếu có registryKey
    if (widget.registryKey != null && _controller != null) {
      SgTableRegistry().register<T>(widget.registryKey!, _controller!);
    }

    // Đăng ký listener sau khi tạo frame đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _verticalController.addListener(_scrollListener);
      }
    });
  }

  @override
  void dispose() {
    _verticalController.removeListener(_scrollListener);

    widget.props.horizontalController?.dispose();
    widget.props.verticalController?.dispose();

    if (_horizontalController != widget.props.horizontalController) {
      _horizontalController.dispose();
    }
    if (_verticalController != widget.props.verticalController) {
      _verticalController.dispose();
    }

    // Hủy đăng ký controller khỏi registry nếu có registryKey
    if (widget.registryKey != null) {
      SgTableRegistry().unregister(widget.registryKey!);
    }

    _controller?.dispose();
    _backgroundColorCache.clear(); // Xóa cache màu nền
    super.dispose();
  }

  @override
  void didUpdateWidget(SgTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Cập nhật tham chiếu controller cục bộ khi props thay đổi
    if (widget.props != oldWidget.props) {
      // Chỉ cập nhật props nếu cần thiết
      bool dataChanged = !listEquals(widget.props.data, oldWidget.props.data);
      bool searchTermChanged = widget.props.searchTerm != oldWidget.props.searchTerm;
      bool columnsChanged = widget.props.columns.length != oldWidget.props.columns.length;

      // Nếu chỉ có dữ liệu thay đổi, sử dụng updateData để giữ nguyên kích thước cột
      if (dataChanged && !columnsChanged && !searchTermChanged) {
        _controller?.updateData(widget.props.data);
      } else {
        // Nếu có thay đổi khác, sử dụng updateFromProps (đã được cải thiện)
        _controller?.updateFromProps(widget.props);
      }

      setState(() {
        // Gây ra việc build lại với props mới
      });
    }
  }

  //---------------------------
  // QUẢN LÝ CUỘN
  //---------------------------
  // Theo dõi sự kiện cuộn để tối ưu hiệu năng
  void _scrollListener() {
    // // Kiểm tra nếu controller không có client
    // if (!_verticalController.hasClients || _controller == null) return;

    // // Đánh dấu đang cuộn khi vị trí cuộn thay đổi
    // final bool isNowScrolling = _verticalController.position.isScrollingNotifier.value;
    // if (isNowScrolling != _isScrolling) {
    //   // Chỉ cập nhật trạng thái nếu trạng thái cuộn thực sự thay đổi
    //   setState(() {
    //     _isScrolling = isNowScrolling;
    //   });
    // }
  }

  //---------------------------
  // XỬ LÝ MÀU NỀN
  //---------------------------
  // Các khóa màu nền cho việc cache
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

  // Lấy màu nền cho hàng dựa trên trạng thái
  Color _getBackgroundColor(int index, bool isSelected, bool isChecked) {
    final isEven = index % 2 == 0;
    // Ưu tiên pressed > hover > selected/checked
    if (_pressedRowIndex == index) {
      return widget.props.pressedRowColor;
    }
    if (_hoveredRowIndex == index) {
      return widget.props.hoverRowColor;
    }
    final key = _backgroundColorKeys[isSelected]![isChecked]![isEven]!;

    return _backgroundColorCache[key] ??= (() {
      if (isSelected) {
        return widget.props.selectedRowColor;
      } else if (isChecked) {
        return widget.props.checkedRowColor;
      } else {
        return isEven ? widget.props.evenRowBackgroundColor : widget.props.oddRowBackgroundColor;
      }
    })();
  }

  //---------------------------
  // XÂY DỰNG GIAO DIỆN
  //---------------------------
  @override
  Widget build(BuildContext context) {
    return SgTableProvider.create<T>(
      key: _providerKey,
      props: widget.props,
      child: Consumer<SgTableProvider<T>>(
        builder: (context, provider, _) {
          final controller = provider.controller;

          // Cập nhật tham chiếu controller cục bộ từ provider
          _controller = controller;

          final totalWidth = controller.calculateTotalWidth();
          final screenWidth = MediaQuery.of(context).size.width;
          final effectiveWidth = totalWidth > screenWidth ? totalWidth : screenWidth;

          // Sử dụng dữ liệu đã được sắp xếp
          final displayData = controller.sortedData;
          final exactHeight = widget.props.rowHeight + (displayData.length * widget.props.rowHeight);

          return LayoutBuilder(
            builder: (context, constraints) {
              return ScrollbarTheme(
                data: const ScrollbarThemeData(
                  thumbColor: WidgetStatePropertyAll(Color(0xFF78909C)),
                  thickness: WidgetStatePropertyAll(8.0),
                  radius: Radius.circular(4),
                  mainAxisMargin: 8,
                ),
                child: Scrollbar(
                  controller: _horizontalController,
                  thumbVisibility: true,
                  notificationPredicate: (notification) => notification.metrics.axis == Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalController,
                    child: SizedBox(
                      width: effectiveWidth,
                      height: exactHeight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hàng tiêu đề - tối ưu với RepaintBoundary
                          RepaintBoundary(
                            child: Container(
                              height: widget.props.rowHeight,
                              decoration: BoxDecoration(
                                color: widget.props.headerBackgroundColor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: widget.props.gridLineColor,
                                    width: widget.props.gridLineWidth,
                                  ),
                                  top: BorderSide(
                                    color: widget.props.gridLineColor,
                                    width: widget.props.gridLineWidth,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: _buildHeaderCells(controller, false, effectiveWidth, totalWidth),
                              ),
                            ),
                          ),
                          // Phần thân bảng - với ListView.builder được tối ưu
                          Expanded(
                            child: ListView.builder(
                              controller: _verticalController,
                              physics: const ClampingScrollPhysics(),
                              itemCount: displayData.length,
                              itemExtent: widget.props.rowHeight,
                              addAutomaticKeepAlives: false,
                              addRepaintBoundaries: true,
                              itemBuilder: (context, index) {
                                return _buildTableRow(
                                    context, controller, index, displayData, effectiveWidth, totalWidth);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Xây dựng hàng bảng với caching
  Widget _buildTableRow(BuildContext context, SgTableController<T> controller, int index, List<T> data,
      double effectiveWidth, double totalWidth) {
    final item = data[index];
    final isLast = index == data.length - 1;
    final isChecked = controller.selectedItems.contains(item);
    final isSelected = controller.selectedRowIndex == index;

    // Sử dụng màu nền đã cache
    final backgroundColor = _getBackgroundColor(index, isSelected, isChecked);

    // Sử dụng các ô hàng đã cache nếu có
    List<Widget>? cachedCells;
    if (!isSelected && !isChecked) {
      // Không cache hàng được chọn hoặc đánh dấu vì chúng thay đổi thường xuyên
      cachedCells = controller.getCachedRow(item, effectiveWidth);
    }

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _hoveredRowIndex = index);
        },
        onExit: (_) {
          if (_hoveredRowIndex == index) {
            setState(() => _hoveredRowIndex = null);
          }
        },
        child: GestureDetector(
          onTap: () => controller.onRowSelected(index),
          child: ColoredBox(
            color: backgroundColor,
            child: Row(
              children: cachedCells ?? _buildAndCacheRowCells(controller, item, index, effectiveWidth, totalWidth),
            ),
          ),
        ),
      ),
    );
  }

  // Xây dựng và cache các ô trong hàng
  List<Widget> _buildAndCacheRowCells(
      SgTableController<T> controller, T item, int rowIndex, double effectiveWidth, double totalWidth) {
    final cells = _buildRowCells(
      context,
      controller,
      item,
      false,
      effectiveWidth,
      totalWidth,
      rowIndex,
    );

    // Cache các ô để sử dụng sau này
    controller.cacheRow(item, effectiveWidth, cells);

    return cells;
  }

  // Xây dựng các ô tiêu đề với caching
  List<Widget> _buildHeaderCells(
      SgTableController<T> controller, bool shouldExpand, double screenWidth, double totalWidth) {
    // Kiểm tra các ô tiêu đề đã cache
    final int cacheKey = controller.effectiveColumns.length;
    final List<Widget>? cachedCells = controller.getCachedHeaderCells(cacheKey);

    if (cachedCells != null) {
      return cachedCells;
    }

    final cells = List.generate(controller.effectiveColumns.length, (index) {
      final column = controller.effectiveColumns[index];
      final hasSort = column.sortValueGetter != null;
      final isLast = index == controller.effectiveColumns.length - 1;

      // Trường hợp đặc biệt cho cột checkbox
      if (widget.props.showCheckboxes && index == 0) {
        return _buildHeaderCell(
          controller: controller,
          child: Center(
            child: Transform.scale(
              scale: widget.props.scaleCheckbox,
              child: Checkbox(
                value: controller.allSelected,
                onChanged: (selected) => controller.toggleSelectAll(selected),
                activeColor: widget.props.activeColor,
                checkColor: widget.props.checkColor,
                side: widget.props.side,
                shape: widget.props.shape,
              ),
            ),
          ),
          width: column.width,
          isLast: isLast,
          columnIndex: index,
        );
      }

      return _buildHeaderCell(
        controller: controller,
        child: InkWell(
          onTap: hasSort ? () => controller.onSortColumn(index) : null,
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
                    color: widget.props.textHeaderColor ?? Colors.white,
                    style: widget.props.titleStyleHeader ??
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                    maxLines: column.maxLinesTitle,
                    overflow: column.maxLinesTitle == 1 ? TextOverflow.ellipsis : null,
                  ),
                ),
                // Chỉ thêm biểu tượng sắp xếp khi cần thiết
                if (hasSort && controller.sortColumnIndex == index && controller.sortDirection != SortDirection.none)
                  _buildSortIcon(controller.sortDirection),
              ],
            ),
          ),
        ),
        width: column.width,
        isLast: isLast,
        columnIndex: index,
      );
    });

    // Cache các ô đã tạo
    controller.cacheHeaderCells(cacheKey, cells);

    return cells;
  }

  // Tạo biểu tượng sắp xếp cho cột tiêu đề
  Widget _buildSortIcon(SortDirection direction) {
    return Icon(
      direction == SortDirection.ascending ? Icons.arrow_upward : Icons.arrow_downward,
      size: 16,
      color: SGAppColors.neutral700,
    );
  }

  // Xây dựng các ô dữ liệu cho hàng
  List<Widget> _buildRowCells(BuildContext context, SgTableController<T> controller, T item, bool shouldExpand,
      double screenWidth, double totalWidth, int rowIndex) {
    final cells = List.generate(controller.effectiveColumns.length, (index) {
      final column = controller.effectiveColumns[index];
      final isLast = index == controller.effectiveColumns.length - 1;

      // Xử lý đặc biệt cho cột checkbox
      if (widget.props.showCheckboxes && index == 0) {
        return _buildCell(
          controller: controller,
          child: Center(
            child: column.cellBuilder(item),
          ),
          width: column.width,
          isLast: isLast,
          columnIndex: index,
        );
      }

      // Cho các cột dữ liệu thông thường
      return _buildCell(
        controller: controller,
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
      );
    });

    return cells;
  }

  // Xây dựng một ô (cho tiêu đề hoặc hàng dữ liệu) với RepaintBoundary
  Widget _buildCell({
    required SgTableController<T> controller,
    required Widget child,
    double? width,
    bool isLast = false,
    int? columnIndex,
  }) {
    final baseWidth =
        columnIndex != null ? (controller.columnWidths[columnIndex] ?? (width ?? 120.0)) : (width ?? 120.0);
    final adjustedWidth = baseWidth;

    return RepaintBoundary(
      child: Container(
        width: adjustedWidth,
        height: widget.props.rowHeight,
        decoration: BoxDecoration(
          border: widget.props.showVerticalLines && !isLast
              ? Border(
                  right: BorderSide(
                    color: widget.props.gridLineColor,
                    width: widget.props.gridLineWidth,
                  ),
                )
              : null,
        ),
        child: child,
      ),
    );
  }

// Xây dựng một ô (cho tiêu đề hoặc hàng dữ liệu) với RepaintBoundary
  Widget _buildHeaderCell({
    required SgTableController<T> controller,
    required Widget child,
    double? width,
    bool isLast = false,
    int? columnIndex,
  }) {
    final baseWidth =
        columnIndex != null ? (controller.columnWidths[columnIndex] ?? (width ?? 120.0)) : (width ?? 120.0);
    final adjustedWidth = baseWidth;

    return RepaintBoundary(
      child: Stack(
        children: [
          Container(
            width: adjustedWidth,
            height: widget.props.rowHeight,
            decoration: BoxDecoration(
              border: widget.props.showVerticalLines && !isLast
                  ? Border(
                      right: BorderSide(
                        color: widget.props.gridLineColor,
                        width: widget.props.gridLineWidth,
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
                  onHorizontalDragStart: (details) {
                    controller.startResize(columnIndex, details.globalPosition.dx);
                  },
                  onHorizontalDragUpdate: (details) {
                    controller.updateResize(details.globalPosition.dx);
                  },
                  onHorizontalDragEnd: (_) {
                    controller.endResize();
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
