import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedLeaveType = 'Tất cả';
    _selectedStatus = 'Tất cả';
    _leaveTypeController.text = _selectedLeaveType!;
    _statusController.text = _selectedStatus!;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _leaveTypeController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Widget _buildSearchField(Size size) {
    return SizedBox(
      width: size.width * 0.2,
      child: SGInputText(
        controller: _searchController,
        width: size.width * 0.2,
        borderRadius: 10,
        hintText: 'Tìm kiếm',
        onChanged: (value) {
          setState(() {
            _searchTerm = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterDropdown(String title, List<String> items, String? value,
      Function(String?) onChanged, TextEditingController controller, Size size) {
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
            controller: controller,
            value: value,
            items: items.map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: onChanged,
            sizeBorderCircular: 10,
            colorBorder: SGAppColors.neutral400,
            enableSearch: false,
            isShowSuffixIcon: true,
            hintText: 'Chọn ${title.toLowerCase()}',
            textAlign: TextAlign.left,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

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
                  },
                  _statusController,
                  size,
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
                    leaveTypeFilter: _selectedLeaveType == 'Tất cả'
                        ? null
                        : _selectedLeaveType,
                    statusFilter:
                        _selectedStatus == 'Tất cả' ? null : _selectedStatus,
                  ),
                ),
              ),
            ),
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

class DemoBaseTable extends StatelessWidget {
  final String searchTerm;
  final String? leaveTypeFilter;
  final String? statusFilter;

  DemoBaseTable(
      {super.key,
      this.searchTerm = "",
      this.leaveTypeFilter,
      this.statusFilter});

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

  final List<DataTable> dataTable = [
    DataTable(
      id: 'TO/0076',
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
      id: 'TO/0075',
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
      id: 'TO/0071',
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
      id: 'TO/0052',
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
    final duplicatedLeaveRequests = [
      ...dataTable,
      ...dataTable,
      ...dataTable,
      ...dataTable
    ];

    return SgTable<DataTable>(
      // textHeaderColor: SGAppColors.error50,
      headerBackgroundColor: Colors.blue,
      evenRowBackgroundColor: Colors.grey.shade200,
      oddRowBackgroundColor: Colors.white,
      selectedRowColor: Colors.lightBlue.shade100,
      gridLineColor: Colors.grey.shade300,
      gridLineWidth: 1.0,
      showVerticalLines: true,
      showHorizontalLines: true,
      allowRowSelection: true,
      searchTerm: searchTerm,
      customFilter: (item) {
        // Lọc theo loại ngày nghỉ nếu đã chọn
        if (leaveTypeFilter != null && item.leaveType != leaveTypeFilter) {
          return false;
        }

        // Lọc theo trạng thái nếu đã chọn
        if (statusFilter != null && item.status != statusFilter) {
          return false;
        }

        return true;
      },
      // Bật tính năng hiển thị cột hành động
      showActions: true,
      actionColumnTitle: 'Thao tác',
      actionColumnWidth: 150,
      actionViewColor: Colors.green,
      actionEditColor: Colors.blue,
      actionDeleteColor: Colors.red,
      onViewAction: (item) {
        log('message ${item.employeeName}');
      },
      onEditAction: (item) {},
      onDeleteAction: (item) {},
      columns: [
        TableColumnBuilder.createTextColumn<DataTable>(
          title: 'Mã',
          getValue: (item) => item.id,
          width: 100,
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
          cellBuilder: (item) => _buildStatusTag(item.status),
          sortValueGetter: (item) => item.status,
          searchValueGetter: (item) => item.status,
          cellAlignment: TextAlign.center,
          titleAlignment: TextAlign.center,
          width: 170,
          searchable: true,
        ),
        // Đã xóa cột hành động tại đây vì đã dùng showActions
      ],
      data: duplicatedLeaveRequests,
      onRowTap: (item) {
        debugPrint('Đã chọn: ${item.id} - ${item.employeeName}');
      },
    );
  }

  Widget _buildStatusTag(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (status) {
      case 'Hoàn thành':
        backgroundColor = Colors.green;
        break;
      case 'Hủy':
        backgroundColor = Colors.red;
        break;
      case 'Đã từ chối':
        backgroundColor = Colors.orange;
        break;
      case 'Dự thảo':
        backgroundColor = Colors.blue;
        break;
      case 'Chờ CBQL duyệt':
        backgroundColor = Colors.purple;
        break;
      default:
        backgroundColor = SGAppColors.neutral500;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: SGText(
          text: status,
          color: textColor,
          textAlign: TextAlign.center,
          size: 14,
        ),
      ),
    );
  }
}
