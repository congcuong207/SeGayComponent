import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_datetime_input_button.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/common/switch/sg_toggle_switch.dart';

class TableViewExemple extends StatefulWidget {
  const TableViewExemple({super.key});

  @override
  State<TableViewExemple> createState() => _TableViewExempleState();
}

class _TableViewExempleState extends State<TableViewExemple> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _leaveTypeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  String _searchTerm = "";
  String? _selectedLeaveType;
  String? _selectedStatus;

  // Danh sách các loại ngày nghỉ và trạng thái để lọc
  final List<String> _leaveTypes = [
    'Tất cả',
    'Nghỉ không hưởng lương',
    'Khám thai thông thường',
  ];

  final List<String> _statuses = [
    'Tất cả',
    'Hoàn thành',
    'Hủy',
    'Đã từ chối',
    'Dự thảo',
    'Chờ CBQL duyệt',
  ];

  // pagination_controls
  late int totalEntries;
  late int totalPages;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;
  late List<DataTable> pageProducts;
  TextEditingController? _controllerDropdownPage;
  late List<DataTable> duplicatedLeaveRequests;

  final List<DropdownMenuItem<int>> items = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
  ];

  @override
  void initState() {
    super.initState();
    // Only initialize the controller if pagination is actually used
    _controllerDropdownPage =
        TextEditingController(text: rowsPerPage.toString());
    _selectedLeaveType = 'Tất cả';
    _selectedStatus = 'Tất cả';
    _leaveTypeController.text = _selectedLeaveType!;
    _statusController.text = _selectedStatus!;

    // Create duplicated data
    duplicatedLeaveRequests = [
      ...dataTable,
      ...dataTable,
      ...dataTable,
      ...dataTable
    ];

    // Initialize pagination on startup
    _updatePagination();
  }

  @override
  void dispose() {
    // Safely dispose the controller
    _controllerDropdownPage?.dispose();
    _searchController.dispose();
    _leaveTypeController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _updatePagination() {
    totalEntries = dataTable.length;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    pageProducts = dataTable.isNotEmpty
        ? dataTable.sublist(
            startIndex < totalEntries ? startIndex : 0,
            endIndex < totalEntries ? endIndex : totalEntries,
          )
        : [];

    log('message pageProducts: ${pageProducts.length}');
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      _updatePagination();
    });
  }

  void _onRowsPerPageChanged(int? value) {
    if (value == null) return;
    setState(() {
      rowsPerPage = value;
      currentPage = 1;
      _updatePagination();
    });
  }

  Widget _buildSearchField(Size size) {
    return SizedBox(
      width: size.width * 0.2,
      child: SGInputText(
        controller: _searchController,
        // width: size.width * 0.2,
        borderRadius: 10,
        // enabled: false,
        onlyLine: true,
        showBorder: false,
        hintText: 'Tìm kiếm',
        onChanged: (value) {
          setState(() {
            _searchTerm = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterDropdown(
      String title,
      List<String> items,
      String? value,
      Function(String?) onChanged,
      TextEditingController controller,
      Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SGText(
          text: title,
          size: 14,
          color: SGAppColors.neutral700,
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: size.width * 0.15,
          child: SGDropdownInputButton<String>(
              label: title,
              required: true,
              height: 45,
              controller: controller,
              textOverflow: TextOverflow.ellipsis,
              value: value,
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: onChanged,
              sizeBorderCircular: 7,
              colorBorder: SGAppColors.neutral900,
              // showUnderlineBorderOnly: true,
              enableSearch: false,
              isClearController: false,
              isShowSuffixIcon: true,
              hintText: 'Chọn ${title.toLowerCase()}',
              textAlign: TextAlign.left,
              contentPadding:
                  const EdgeInsets.only(left: 10, top: 8, bottom: 10)),
        ),
      ],
    );
  }

  Widget _buildPaginationControls(List<DataTable> dataTable) {
    // Check if pagination is disabled or controller is null
    if (_controllerDropdownPage == null) {
      return const SizedBox(); // Return empty widget
    }

    return Visibility(
      visible: dataTable.length >= 5,
      child: SGPaginationControls(
        totalPages: totalPages,
        currentPage: currentPage,
        rowsPerPage: rowsPerPage,
        controllerDropdownPage: _controllerDropdownPage!,
        items: items,
        onPageChanged: _onPageChanged,
        onRowsPerPageChanged: _onRowsPerPageChanged,
      ),
    );
  }

  final List<DataTable> dataTable = [
    DataTable(
      id: 'TO/0070',
      employeeId: '[ID0015]',
      employeeName: 'Nguyễn Ngọc Anh',
      department: 'Ban giám đốc',
      leaveType: 'Nghỉ không hưởng lương',
      description: '',
      startDate: DateTime(2025, 7, 14, 22, 0),
      endDate: DateTime(2025, 7, 15, 7, 0),
      days: 1.0,
      status: 'Hủy',
    ),
    DataTable(
      id: 'TO/0071',
      employeeId: '[ID006]',
      employeeName: 'Hoàng Thị Mai',
      department: 'Phòng HCNS',
      leaveType: 'Nghỉ không hưởng lương',
      description: '',
      startDate: DateTime(2025, 7, 14, 13, 0),
      endDate: DateTime(2025, 7, 14, 17, 0),
      days: 0.5,
      status: 'Hủy',
    ),
    DataTable(
      id: 'TO/0072',
      employeeId: '[ID010]',
      employeeName: 'Nguyễn Thị Thảo',
      department: 'Phòng HCNS',
      leaveType: 'Khám thai thông thường',
      description: '',
      startDate: DateTime(2025, 7, 14, 8, 0),
      endDate: DateTime(2025, 7, 14, 17, 0),
      days: 1.0,
      status: 'Hoàn thành',
    ),
    DataTable(
      id: 'TO/0073',
      employeeId: '[TNBA22]',
      employeeName: 'Lê Thị Na',
      department: 'Phòng BA',
      leaveType: 'Khám thai thông thường',
      description: '',
      startDate: DateTime(2025, 1, 30, 8, 0),
      endDate: DateTime(2025, 1, 31, 17, 0),
      days: 0.0,
      status: 'Đã từ chối',
    ),
    DataTable(
      id: 'TO/0074',
      employeeId: '[ID001]',
      employeeName: 'Kế Toán Thủy',
      department: 'Phòng kế toán',
      leaveType: 'Khám thai thông thường',
      description: '',
      startDate: DateTime(2024, 12, 27, 8, 0),
      endDate: DateTime(2024, 12, 27, 17, 0),
      days: 1.0,
      status: 'Hoàn thành',
    ),
    DataTable(
      id: 'TO/0075',
      employeeId: '[ID010]',
      employeeName: 'Nguyễn Thị Thảo',
      department: 'Phòng HCNS',
      leaveType: 'Khám thai thông thường',
      description: '',
      startDate: DateTime(2025, 7, 14, 8, 0),
      endDate: DateTime(2025, 7, 14, 17, 0),
      days: 1.0,
      status: 'Hoàn thành',
    ),
    DataTable(
      id: 'TO/0076',
      employeeId: '[TNBA22]',
      employeeName: 'Lê Thị Na',
      department: 'Phòng BA',
      leaveType: 'Khám thai thông thường',
      description: '',
      startDate: DateTime(2025, 1, 30, 8, 0),
      endDate: DateTime(2025, 1, 31, 17, 0),
      days: 0.0,
      status: 'Đã từ chối',
    ),
    DataTable(
      id: 'TO/0077',
      employeeId: '[ID001]',
      employeeName: 'Kế Toán Thủy',
      department: 'Phòng kế toán',
      leaveType: 'Khám thai thông thường',
      description: '',
      startDate: DateTime(2024, 12, 27, 8, 0),
      endDate: DateTime(2024, 12, 27, 17, 0),
      days: 1.0,
      status: 'Hoàn thành',
    ),
    DataTable(
      id: 'TO/0077',
      employeeId: '[ID010]',
      employeeName: 'Nguyễn Thị Thảo',
      department: 'Phòng HCNS',
      leaveType: 'Khám thai thông thường',
      description: '',
      startDate: DateTime(2025, 7, 14, 8, 0),
      endDate: DateTime(2025, 7, 14, 17, 0),
      days: 1.0,
      status: 'Hoàn thành',
    ),
    DataTable(
      id: 'TO/0078',
      employeeId: '[TNBA22]',
      employeeName: 'Lê Thị Na',
      department: 'Phòng BA',
      leaveType: 'Khám thai thông thường',
      description: '',
      startDate: DateTime(2025, 1, 30, 8, 0),
      endDate: DateTime(2025, 1, 31, 17, 0),
      days: 0.0,
      status: 'Đã từ chối',
    ),
    DataTable(
      id: 'TO/0079',
      employeeId: '[ID001]',
      employeeName: 'Kế Toán Thủy',
      department: 'Phòng kế toán',
      leaveType: 'Khám thai thông thường',
      description: '',
      startDate: DateTime(2024, 12, 27, 8, 0),
      endDate: DateTime(2024, 12, 27, 17, 0),
      days: 1.0,
      status: 'Hoàn thành',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo SG Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SGText(
              text: 'Bảng Quản Lý Nghỉ Phép',
              size: 24,
              fontWeight: FontWeight.bold,
              color: SGAppColors.neutral900,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildSearchField(size),
                const SizedBox(width: 20),
                // SGButtonIcon(
                //   // enabled: true,
                //   paddingIconLeft: 10,
                //   isOutlined: true,
                //   borderWidth: 3,
                //   defaultBGColor: Colors.amber,
                //   // iconButton: 'assets/images/android.png',
                //   padding: const EdgeInsets.all(5),
                //   text: 'text',
                //   colorHover: Colors.red,
                //   onPressed: () {
                //     log('message onPressed');
                //   },
                // ),
                _buildFilterDropdown(
                  'Loại ngày nghỉ',
                  _leaveTypes,
                  _selectedLeaveType,
                  (value) {
                    setState(() {
                      _selectedLeaveType = value;
                      _leaveTypeController.text = value ?? '';
                    });
                  },
                  _leaveTypeController,
                  size,
                ),
                const SizedBox(width: 20),
                _buildFilterDropdown(
                  'Trạng thái',
                  _statuses,
                  _selectedStatus,
                  (value) {
                    setState(() {
                      _selectedStatus = value;
                      _statusController.text = value ?? '';
                    });
                    log('message value: $value');
                  },
                  _statusController,
                  size,
                ),

                SGDateTimeInputButton(
                  label: 'Chọn ngày giờ',
                  isRequired: true,
                  controller: TextEditingController(
                      text: DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(DateTime.now())),
                  // value: _selected,
                  onChanged: (dt) {
                    setState(() {
                      // _selected = dt;
                    });
                  },
                  width: 260,
                  height: 40,
                  // Hành vi
                  initWithNow: true, // bật khởi tạo với thời gian hiện tại
                  enable: true, // true = disable hoàn toàn
                  allowTyping: true, // cho phép gõ tay
                  showTimeSection: true, // hiển thị phần giờ-phút-giây
                  timeOptional: true, // cho phép bật/tắt thời gian
                  includeSeconds: true, // có trường giây
                  initialIncludeTime: false,

                  // Định dạng tuỳ biến (không bắt buộc)
                  // dateFormat: 'dd/MM/yyyy',
                  // dateTimeFormat: 'dd/MM/yyyy HH:mm',
                  // Giao diện theo SGDropdownInputButton
                  // sizeBorderCircular: 12,
                  colorBorder: SGAppColors.colorBorderGray,
                  colorBorderFocus: SGAppColors.info500,
                  // showUnderlineBorderOnly:
                  //     true, // true nếu muốn chỉ gạch chân như option có sẵn
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DemoBaseTable(
                    searchTerm: _searchTerm,
                    dataTable: pageProducts,
                    leaveTypeFilter: _selectedLeaveType == 'Tất cả'
                        ? null
                        : _selectedLeaveType,
                    statusFilter:
                        _selectedStatus == 'Tất cả' ? null : _selectedStatus,
                  ),
                ),
              ),
            ),
            _buildPaginationControls(dataTable),
          ],
        ),
      ),
    );
  }
}

class DataTable {
  final String id;
  final String employeeId;
  final String employeeName;
  final String department;
  final String leaveType;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double days;
  final String status;

  DataTable({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.leaveType,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.status,
  });

  // Chuyển đổi từ JSON thành đối tượng LeaveRequest
  factory DataTable.fromJson(Map<String, dynamic> json) {
    return DataTable(
      id: json['id'],
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
      department: json['department'],
      leaveType: json['leaveType'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      days: json['days'].toDouble(),
      status: json['status'],
    );
  }

  // Chuyển đổi từ đối tượng LeaveRequest thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'department': department,
      'leaveType': leaveType,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'days': days,
      'status': status,
    };
  }
}

class DemoBaseTable extends StatefulWidget {
  final String searchTerm;
  final String? leaveTypeFilter;
  final String? statusFilter;
  final List<DataTable> dataTable;

  const DemoBaseTable(
      {super.key,
      this.searchTerm = "",
      this.leaveTypeFilter,
      this.statusFilter,
      required this.dataTable});

  @override
  State<DemoBaseTable> createState() => _DemoBaseTableState();
}

class _DemoBaseTableState extends State<DemoBaseTable> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  bool _showCheckboxes = true; // State for toggling checkboxes
  List<DataTable> _selectedItems = []; // Selected items
  final _dtController = TextEditingController();
  DateTime? _selected = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('ctrl: ${_dtController.text}'); // đã có ngày/giờ
    });
  }

  @override
  void dispose() {
    // Safely dispose the controller
    _dtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add toggle for checkboxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_selectedItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Đã chọn: ${_selectedItems.length} mục',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Xóa đã chọn'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      onPressed: () {
                        // Handle batch delete
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xác nhận xóa'),
                            content: Text(
                                'Bạn có chắc chắn muốn xóa ${_selectedItems.length} mục đã chọn?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Implement delete logic here
                                },
                                child: const Text('Xóa'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            SGDateTimeInputButton(
              label: 'Chọn ngày giờ',
              isRequired: true,
              controller: _dtController,
              value: _selected,
              onChanged: (dt) {
                setState(() {
                  _selected = dt;
                });
              },
              width: 260,
              height: 40,
              // Hành vi
              initWithNow: true, // bật khởi tạo với thời gian hiện tại
              enable: true, // true = disable hoàn toàn
              allowTyping: true, // cho phép gõ tay
              showTimeSection: true, // hiển thị phần giờ-phút-giây
              timeOptional: true, // cho phép bật/tắt thời gian
              includeSeconds: true, // có trường giây
              initialIncludeTime: false,

              // Định dạng tuỳ biến (không bắt buộc)
              // dateFormat: 'dd/MM/yyyy',
              // dateTimeFormat: 'dd/MM/yyyy HH:mm',
              // Giao diện theo SGDropdownInputButton
              // sizeBorderCircular: 12,
              colorBorder: SGAppColors.colorBorderGray,
              colorBorderFocus: SGAppColors.info500,
              // showUnderlineBorderOnly:
              //     true, // true nếu muốn chỉ gạch chân như option có sẵn
            ),
            SgToggleSwitch(
              value: _showCheckboxes,
              onChanged: (value) => setState(() {
                _showCheckboxes = value;
              }),
              text: 'Custom Switch',
              switchColor: Colors.purple,
              onIcon: 'ON',
              offIcon: 'OFF',
            ),
            // Row(
            //   children: [
            //     const Text('Hiển thị hộp chọn:'),
            //     Switch(
            //       value: _showCheckboxes,
            //       onChanged: (value) {
            //         setState(() {
            //           _showCheckboxes = value;
            //           if (!value) {
            //             _selectedItems = [];
            //           }
            //         });
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
        const SizedBox(height: 8),

        SgTable<DataTable>(
          // textHeaderColor: SGAppColors.error50,
          headerBackgroundColor: Colors.blue,
          showVerticalLines: true,
          // evenRowBackgroundColor: Colors.grey.shade200,
          // oddRowBackgroundColor: Colors.white,
          // selectedRowColor: Colors.lightBlue.shade100,
          // Light blue background for checked rows
          // gridLineColor: Colors.grey.shade300,
          // gridLineWidth: 1.0,
          // showVerticalLines: true,
          // showHorizontalLines: true,
          // allowRowSelection: true,
          // searchTerm: widget.searchTerm,
          // showCheckboxes: _showCheckboxes, // on, off checkbox
          onSelectionChanged: (selectedItems) {
            setState(() {
              _selectedItems = selectedItems;
            });
          },
          // Row hover options
          // rowHoverColor: Colors.blue.withOpacity(0.1),
          rowHoverDuration: const Duration(milliseconds: 100),
          enableColumnFilters: true,
          // Bật tính năng hiển thị cột hành động
          // showActions: true,
          actionColumnTitle: 'Thao tác',
          // actionColumnWidth: 150,
          // actionViewColor: Colors.green,
          // actionEditColor: Colors.blue,
          // actionDeleteColor: Colors.red,
          onViewAction: (item) {
            log('message ${item.employeeName}');
          },
          onEditAction: (item) {},
          onDeleteAction: (item) {},
          columns: [
            TableColumnBuilder.createTextColumn<DataTable>(
              title: 'Mã',
              align: TextAlign.center,
              getValue: (item) => item.id,
              width: 100,
              filterable: true,
            ),
            TableColumnBuilder.createTextColumn<DataTable>(
              title: 'Nhân viên',
              getValue: (item) => '${item.employeeId} ${item.employeeName}',
              sortValue: (item) => item.employeeName,
              searchValue: (item) => '${item.employeeId} ${item.employeeName}',
              width: 200,
            ),
            TableColumnBuilder.createTextColumn<DataTable>(
              title: 'Phòng/Ban',
              getValue: (item) => item.department,
              width: 150,
            ),
            TableColumnBuilder.createTextColumn<DataTable>(
              title: 'Loại ngày nghỉ',
              getValue: (item) => item.leaveType,
            ),
            TableColumnBuilder.createTextColumn<DataTable>(
              title: 'Mô tả',
              getValue: (item) => item.description,
              width: 100,
              searchable: false, // Mô tả trống nên không tìm kiếm
            ),
            TableColumnBuilder.createDateColumn<DataTable>(
              title: 'Ngày bắt đầu',
              getValue: (item) => item.startDate,
              format: dateFormat,
              width: 150,
            ),
            TableColumnBuilder.createDateColumn<DataTable>(
              title: 'Ngày kết thúc',
              getValue: (item) => item.endDate,
              format: dateFormat,
              width: 150,
            ),
            TableColumnBuilder.createTextColumn<DataTable>(
              title: 'Số ngày',
              getValue: (item) => item.days.toString(),
              sortValue: (item) => item.days,
              // align: TextAlign.right,
              width: 120,
              isNumeric: true,
            ),
            SgTableColumn<DataTable>(
              title: 'Trạng thái',
              cellBuilder: (item) => _buildStatusTag2(item),
              // sortValueGetter: (item) => item.status,
              searchValueGetter: (item) {
                final status = getNumberStatus(item.status);
                return status == 1
                    ? 'Đã ký'
                    : status == 0
                        ? 'Chưa ký'
                        : status == 2
                            ? 'Đã ký nháy'
                            : status == 3
                                ? 'Đã ký & tạo'
                                : status == 4
                                    ? 'Chưa ký nháy'
                                    : status == 5
                                        ? 'Chưa ký & tạo'
                                        : 'Người tạo phiếu';
              },
              cellAlignment: TextAlign.center,
              titleAlignment: TextAlign.center,
              width: 170,
              // searchable: true,
              filterable: true,
            ),
            // Đã xóa cột hành động tại đây vì đã dùng showActions
          ],
          data: widget.dataTable,
          onRowTap: (item) {
            debugPrint('Đã chọn: ${item.id} - ${item.employeeName}');
          },
        ),
        // _buildPaginationControls(duplicatedLeaveRequests),
      ],
    );
  }

  Widget _buildStatusTag2(DataTable status) {
    return Container(
      child: SGText(
        text: status.status,
        color: Colors.white,
        textAlign: TextAlign.center,
        size: 14,
      ),
    );
  }

  int getNumberStatus(String status) {
    switch (status) {
      case 'Hoàn thành':
        return 1;
      case 'Hủy':
        return 2;
      case 'Đã từ chối':
        return 3;
      case 'Dự thảo':
        return 4;
      case 'Chờ CBQL duyệt':
        return 5;
      default:
        return 0;
    }
  }
}
