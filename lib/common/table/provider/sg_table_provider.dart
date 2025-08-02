import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:se_gay_components/common/table/model/sg_table_controller.dart';
import 'package:se_gay_components/common/table/model/sg_table_props.dart';

class SgTableProvider<T> extends ChangeNotifier {
  final SgTableController<T> controller;
  final SgTableProps<T> props;
  
  // ValueNotifiers để tối ưu hóa
  final ValueNotifier<List<T>> sortedDataNotifier = ValueNotifier<List<T>>([]);
  final ValueNotifier<Map<int, double>> columnWidthsNotifier = ValueNotifier<Map<int, double>>({});
  final ValueNotifier<bool> selectionChangedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<int?> selectedRowIndexNotifier = ValueNotifier<int?>(null);

  SgTableProvider({
    required this.props,
  }) : controller = SgTableController<T>(
          initialData: props.data,
          columns: props.columns,
          onSelectionChanged: props.onSelectionChanged,
          onRowTap: props.onRowTap,
          searchTerm: props.searchTerm,
          showCheckboxes: props.showCheckboxes,
          showActions: props.showActions,
          actionColumnTitle: props.actionColumnTitle,
          actionColumnWidth: props.actionColumnWidth,
          checkboxColumnWidth: props.checkboxColumnWidth,
          widthScreen: props.widthScreen,
        ) {
    // Khởi tạo các ValueNotifier
    sortedDataNotifier.value = List.from(controller.sortedData);
    columnWidthsNotifier.value = Map.from(controller.columnWidths);
    selectedRowIndexNotifier.value = controller.selectedRowIndex;
    
    // Lắng nghe thay đổi từ controller
    controller.addListener(_controllerChanged);
  }

  void _controllerChanged() {
    // Chỉ cập nhật ValueNotifiers khi cần thiết
    if (!listEquals(sortedDataNotifier.value, controller.sortedData)) {
      sortedDataNotifier.value = List.from(controller.sortedData);
    }
    
    if (columnWidthsNotifier.value != controller.columnWidths) {
      columnWidthsNotifier.value = Map.from(controller.columnWidths);
    }
    
    if (selectedRowIndexNotifier.value != controller.selectedRowIndex) {
      selectedRowIndexNotifier.value = controller.selectedRowIndex;
    }
    
    // Chuyển đổi selectionChangedNotifier để thông báo về bất kỳ thay đổi lựa chọn nào
    if (controller.selectedItems.isNotEmpty) {
      selectionChangedNotifier.value = !selectionChangedNotifier.value;
    }
    
    // Truyền thay đổi đến các listeners của provider này
    notifyListeners();
  }

  void updateProps(SgTableProps<T> newProps) {
    controller.updateFromProps(newProps);
  }

  @override
  void dispose() {
    controller.removeListener(_controllerChanged);
    sortedDataNotifier.dispose();
    columnWidthsNotifier.dispose();
    selectionChangedNotifier.dispose();
    selectedRowIndexNotifier.dispose();
    super.dispose();
  }

  // Phương thức helper để tạo Provider cho SgTableProvider
  static Widget create<T>({
    Key? key,
    required Widget child,
    required SgTableProps<T> props,
  }) {
    return ChangeNotifierProvider<SgTableProvider<T>>(
      key: key,
      create: (_) => SgTableProvider<T>(props: props),
      child: child,
    );
  }

  // Phương thức helper để lấy controller từ context
  static SgTableController<T> controllerOf<T>(BuildContext context, {bool listen = true}) {
    return Provider.of<SgTableProvider<T>>(context, listen: listen).controller;
  }
  
  // Phương thức helper để lấy data notifier
  static ValueNotifier<List<T>> dataNotifierOf<T>(BuildContext context) {
    return Provider.of<SgTableProvider<T>>(context, listen: false).sortedDataNotifier;
  }
  
  // Phương thức helper để lấy column widths notifier
  static ValueNotifier<Map<int, double>> widthsNotifierOf<T>(BuildContext context) {
    return Provider.of<SgTableProvider<T>>(context, listen: false).columnWidthsNotifier;
  }
  
  // Phương thức helper để lấy selection notifier
  static ValueNotifier<bool> selectionNotifierOf<T>(BuildContext context) {
    return Provider.of<SgTableProvider<T>>(context, listen: false).selectionChangedNotifier;
  }
  
  // Phương thức helper để lấy selected row index notifier
  static ValueNotifier<int?> rowIndexNotifierOf<T>(BuildContext context) {
    return Provider.of<SgTableProvider<T>>(context, listen: false).selectedRowIndexNotifier;
  }
}
