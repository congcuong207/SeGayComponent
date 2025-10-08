import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';

enum SGDateTimeMode {
  dayMonthYear,  // dd/MM/yyyy
  monthYear,     // MM/yyyy  
  year,          // yyyy
}

class SGDateTimeInputButton extends StatefulWidget {
  final TextEditingController controller;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final bool isRequired;
  final String label;

  // Appearance/size (align with SGDropdownInputButton API where possible)
  final double? width;
  final double? height;
  final double? sizeBorderLine;
  final double? sizeBorderCircular;
  final Color? colorBorder;
  final Color? colorBorderFocus;
  final Color? colorLabel;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;

  // Behavior
  /// If true, acts like disabled (no popup, readOnly input). Follow SGDropdownInputButton semantics.
  final bool enable;

  /// Allow typing in the input; when false, input is readOnly but popup can still open (if !enable)
  final bool allowTyping;

  /// Show underline-only border like SGDropdownInputButton's option
  final bool showUnderlineBorderOnly;
  final FocusNode? focusNode;

  // Calendar/time options
  final bool showTimeSection; // show time selectors in popup
  final bool includeSeconds; // show seconds selector
  final bool timeOptional; // user can choose to include or not include time
  final bool initialIncludeTime; // initial state for include-time toggle
  final DateTime? firstDate; // optional min date
  final DateTime? lastDate; // optional max date

  /// Custom date format when not including time (default dd/MM/yyyy)
  final String? dateFormat;

  /// Custom datetime format when including time (default dd/MM/yyyy HH:mm:ss or HH:mm if !includeSeconds)
  final String? dateTimeFormat;

  /// If true and `value` is null, initialize with current date-time on first load
  final bool initWithNow;

  final Alignment? targetAnchor;
  final Alignment? followerAnchor;

  /// Thêm thuộc tính mới
  final SGDateTimeMode dateTimeMode;

  const SGDateTimeInputButton({
    super.key,
    required this.controller,
    required this.onChanged,
    this.value,
    this.label = '',
    this.isRequired = false,
    this.width,
    this.height,
    this.sizeBorderLine,
    this.sizeBorderCircular,
    this.colorBorder,
    this.colorBorderFocus,
    this.colorLabel,
    this.contentPadding,
    this.textStyle,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.textOverflow,
    this.enable = false,
    this.allowTyping = true,
    this.showUnderlineBorderOnly = false,
    this.focusNode,
    this.showTimeSection = true,
    this.includeSeconds = true,
    this.timeOptional = true,
    this.initialIncludeTime = false,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.dateTimeFormat,
    this.initWithNow = false,
    this.targetAnchor,
    this.followerAnchor,
    this.dateTimeMode = SGDateTimeMode.dayMonthYear,
  });

  @override
  State<SGDateTimeInputButton> createState() => _SGDateTimeInputButtonState();
}

class _SGDateTimeInputButtonState extends State<SGDateTimeInputButton> {
  final LayerLink _layerLink = LayerLink();
  late final FocusNode _focusNode;
  bool _ownsFocusNode = false;

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _isHovering = false;

  late DateTime _visibleMonth; // first day of visible month
  DateTime? _selectedDateTime;

  // Time controls
  late bool _includeTimeToggle;
  int _hour = 0;
  int _minute = 0;
  int _second = 0;

  bool isProgrammaticChange = false;
  bool _preventOverlayClose =
      false; // block blur-close when interacting with popup

  @override
  void initState() {
    super.initState();

    // Khởi tạo FocusNode
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    // Khởi tạo giá trị ngày giờ
    _selectedDateTime = widget.value;
    final now = DateTime.now();
    _visibleMonth = DateTime(
      (_selectedDateTime ?? now).year,
      (_selectedDateTime ?? now).month,
      1,
    );

    // Khởi tạo giá trị thời gian
    if (widget.value != null) {
      _hour = widget.value!.hour;
      _minute = widget.value!.minute;
      _second = widget.value!.second;
    }

    // Khởi tạo _includeTimeToggle
    _includeTimeToggle = widget.initialIncludeTime ||
        (widget.value != null && _hasNonZeroTime(widget.value!));

    // Nếu được yêu cầu, khởi tạo với thời gian hiện tại khi không có giá trị
    if (widget.value == null && widget.initWithNow) {
      _includeTimeToggle = true;
      _selectedDateTime = now;
      _hour = now.hour;
      _minute = now.minute;
      _second = now.second;
      _visibleMonth = DateTime(now.year, now.month, 1);
      _setControllerTextFromDate(_selectedDateTime);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onChanged(_selectedDateTime);
      });
    }

    // Khởi tạo text cho các controller thời gian
    _hourController.text = _hour.toString().padLeft(2, '0');
    _minuteController.text = _minute.toString().padLeft(2, '0');
    _secondController.text = _second.toString().padLeft(2, '0');

    // Lắng nghe sự kiện focus
    _focusNode.addListener(_handleFocus);

    // Khởi tạo text cho controller nếu có giá trị ban đầu
    if (widget.value != null && widget.controller.text.isEmpty) {
      _setControllerTextFromDate(widget.value);
    }
  }

  void _rebuildOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _notifySelectionChanged() {
    DateTime? result = _selectedDateTime;
    if (result != null) {
      if (widget.showTimeSection &&
          (_includeTimeToggle || !widget.timeOptional)) {
        result = DateTime(
            result.year, result.month, result.day, _hour, _minute, _second);
      } else {
        result = DateTime(result.year, result.month, result.day);
      }
    }
    _setControllerTextFromDate(result);
    widget.onChanged(result);
  }

  @override
  void didUpdateWidget(covariant SGDateTimeInputButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedDateTime = widget.value;
      if (_selectedDateTime != null) {
        _hour = _selectedDateTime!.hour;
        _minute = _selectedDateTime!.minute;
        _second = _selectedDateTime!.second;
        _visibleMonth =
            DateTime(_selectedDateTime!.year, _selectedDateTime!.month, 1);
      }
      _setControllerTextFromDate(widget.value);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    if (_ownsFocusNode) _focusNode.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _handleFocus() {
    if (_focusNode.hasFocus) {
      // open overlay when focused
      if (!_isOpen) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlay());
      }
    } else {
      // On blur, wait briefly and close only if not interacting with popup
      if (_preventOverlayClose) return;
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        if (_focusNode.hasFocus || _preventOverlayClose) return;
        _commitTextIfPossible();
        _removeOverlay();
      });
    }
  }

  void _showOverlay() {
    if (widget.enable) return; // disabled state
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  void _removeOverlay() {
    if (_isOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isOpen = false;
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero, ancestor: overlayBox);

    final screenHeight = MediaQuery.of(context).size.height;
    final spaceAbove = position.dy;
    final spaceBelow = screenHeight - (position.dy + size.height);

    const double estimatedPopupHeight = 380; // calendar + time
    final showAbove =
        spaceBelow < estimatedPopupHeight && spaceAbove > spaceBelow;
    final popupWidth =
        math.max(math.min(widget.width ?? size.width, 420.0), 280.0);
    final useLeftAlignment = popupWidth >= 400;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap outside to dismiss
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _commitTextIfPossible();
                _removeOverlay();
                _focusNode.unfocus();
              },
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: widget.targetAnchor ??
                (useLeftAlignment
                    ? (showAbove ? Alignment.topLeft : Alignment.bottomLeft)
                    : (showAbove
                        ? Alignment.topCenter
                        : Alignment.bottomCenter)),
            followerAnchor: widget.followerAnchor ??
                (useLeftAlignment
                    ? (showAbove ? Alignment.bottomLeft : Alignment.topLeft)
                    : (showAbove
                        ? Alignment.bottomCenter
                        : Alignment.topCenter)),
            offset: Offset(0, showAbove ? -4 : 4),
            child: SizedBox(
              width: popupWidth < 320 ? 320 : popupWidth,
              child: Listener(
                onPointerDown: (_) {
                  // Any click inside popup should not close it via focus loss
                  _preventOverlayClose = true;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) _preventOverlayClose = false;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Material(
                  elevation: 4,
                  borderRadius: widget.showUnderlineBorderOnly
                      ? null
                      : BorderRadius.circular(widget.sizeBorderCircular ?? 12),
                  child: _buildCalendarPopup(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarPopup() {
    return Container(
      decoration: BoxDecoration(
        color: widget.showUnderlineBorderOnly ? null : SGAppColors.neutral0,
        borderRadius: widget.showUnderlineBorderOnly
            ? null
            : BorderRadius.circular(widget.sizeBorderCircular ?? 12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8,
            ),
            _buildCalendarHeader(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 16),
            ),
            _buildCalendarGrid(),
            if (widget.showTimeSection) ...[
              const Divider(height: 16),
              _buildTimeSection(),
            ],
            const Divider(height: 16),
            _buildActionRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    String headerLabel;
    VoidCallback? prevAction;
    VoidCallback? nextAction;
    
    switch (widget.dateTimeMode) {
      case SGDateTimeMode.dayMonthYear:
        try {
          headerLabel = DateFormat("'Tháng' M yyyy").format(_visibleMonth);
        } catch (_) {
          headerLabel = 'Tháng ${_visibleMonth.month} ${_visibleMonth.year}';
        }
        prevAction = () => setState(() => _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1));
        nextAction = () => setState(() => _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1));
        break;
      case SGDateTimeMode.monthYear:
        headerLabel = 'Năm ${_visibleMonth.year}';
        prevAction = () => setState(() => _visibleMonth = DateTime(_visibleMonth.year - 1, _visibleMonth.month, 1));
        nextAction = () => setState(() => _visibleMonth = DateTime(_visibleMonth.year + 1, _visibleMonth.month, 1));
        break;
      case SGDateTimeMode.year:
        final startYear = (_visibleMonth.year ~/ 12) * 12;
        headerLabel = '$startYear - ${startYear + 11}';
        prevAction = () => setState(() => _visibleMonth = DateTime(_visibleMonth.year - 12, _visibleMonth.month, 1));
        nextAction = () => setState(() => _visibleMonth = DateTime(_visibleMonth.year + 12, _visibleMonth.month, 1));
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          // Prev year/period
          Tooltip(
            message: widget.dateTimeMode == SGDateTimeMode.year ? 'Trước' : 'Năm trước',
            child: InkWell(
              onTap: () {
                if (widget.dateTimeMode == SGDateTimeMode.year) {
                  setState(() => _visibleMonth = DateTime(_visibleMonth.year - 12, _visibleMonth.month, 1));
                } else {
                  setState(() => _visibleMonth = DateTime(_visibleMonth.year - 1, _visibleMonth.month, 1));
                }
                _rebuildOverlay();
              },
              child: const Icon(
                Icons.keyboard_double_arrow_left,
                size: 20,
                color: SGAppColors.neutral500,
              ),
            ),
          ),
          // Prev
          Tooltip(
            message: widget.dateTimeMode == SGDateTimeMode.dayMonthYear ? 'Tháng trước' : 'Trước',
            child: InkWell(
              onTap: () {
                if (prevAction != null) prevAction();
                _rebuildOverlay();
              },
              child: const Icon(
                Icons.chevron_left,
                size: 18,
                color: SGAppColors.neutral500,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                headerLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          // Next
          Tooltip(
            message: widget.dateTimeMode == SGDateTimeMode.dayMonthYear ? 'Tháng sau' : 'Sau',
            child: InkWell(
              onTap: () {
                if (nextAction != null) nextAction();
                _rebuildOverlay();
              },
              child: const Icon(
                Icons.chevron_right,
                size: 18,
                color: SGAppColors.neutral500,
              ),
            ),
          ),
          // Next year/period
          Tooltip(
            message: widget.dateTimeMode == SGDateTimeMode.year ? 'Sau' : 'Năm sau',
            child: InkWell(
              onTap: () {
                if (widget.dateTimeMode == SGDateTimeMode.year) {
                  setState(() => _visibleMonth = DateTime(_visibleMonth.year + 12, _visibleMonth.month, 1));
                } else {
                  setState(() => _visibleMonth = DateTime(_visibleMonth.year + 1, _visibleMonth.month, 1));
                }
                _rebuildOverlay();
              },
              child: const Icon(
                Icons.keyboard_double_arrow_right,
                size: 20,
                color: SGAppColors.neutral500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    switch (widget.dateTimeMode) {
      case SGDateTimeMode.dayMonthYear:
        return _buildDayCalendarGrid();
      case SGDateTimeMode.monthYear:
        return _buildMonthCalendarGrid();
      case SGDateTimeMode.year:
        return _buildYearCalendarGrid();
    }
  }

  Widget _buildDayCalendarGrid() {
    // Monday-first grid with week numbers and leading/trailing days
    const double cellHeight = 26;
    const double cellWidth = 26;

    // Find the first Monday on/before the first day of month
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final int firstWeekday = firstOfMonth.weekday; // Mon=1..Sun=7
    final DateTime gridStart =
        firstOfMonth.subtract(Duration(days: (firstWeekday - 1)));

    // Build 6 weeks x 7 days
    final DateTime today = DateTime.now();

    List<TableRow> rows = [];

    // Header row: #, Th 2 .. CN
    rows.add(
      TableRow(
        children: [
          _buildHeaderCell('T2', width: cellWidth),
          _buildHeaderCell('T3', width: cellWidth),
          _buildHeaderCell('T4', width: cellWidth),
          _buildHeaderCell('T5', width: cellWidth),
          _buildHeaderCell('T6', width: cellWidth),
          _buildHeaderCell('T7', width: cellWidth),
          _buildHeaderCell('CN', width: cellWidth),
        ],
      ),
    );

    DateTime cursor = gridStart;
    for (int week = 0; week < 6; week++) {
      final List<Widget> cells = [];

      for (int d = 0; d < 7; d++) {
        final date = cursor;
        final bool isCurrentMonth = date.month == _visibleMonth.month;
        final bool isToday = date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
        final bool isSelected = _selectedDateTime != null &&
            _selectedDateTime!.year == date.year &&
            _selectedDateTime!.month == date.month &&
            _selectedDateTime!.day == date.day;

        final bool isDisabled = (widget.firstDate != null &&
                date.isBefore(_stripTime(widget.firstDate!))) ||
            (widget.lastDate != null &&
                date.isAfter(_stripTime(widget.lastDate!)));

        cells.add(_buildDayCell(
          date: date,
          isCurrentMonth: isCurrentMonth,
          isToday: isToday,
          isSelected: isSelected,
          isDisabled: isDisabled,
          width: cellWidth,
          height: cellHeight,
        ));

        cursor = cursor.add(const Duration(days: 1));
      }

      rows.add(TableRow(children: cells));
    }

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }

  Widget _buildHeaderCell(String text, {required double width}) {
    return Container(
      width: width,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: SGAppColors.neutral100,
        borderRadius: BorderRadius.circular(2),
      ),
      child: SGText(
        text: text,
        size: 13,
        fontWeight: FontWeight.w600,
        color: SGAppColors.dark,
      ),
    );
  }

  Widget _buildDayCell({
    required DateTime date,
    required bool isCurrentMonth,
    required bool isToday,
    required bool isSelected,
    required bool isDisabled,
    required double width,
    required double height,
  }) {
    final Color textColor = isDisabled
        ? Colors.grey
        : (isCurrentMonth ? Colors.black87 : Colors.black38);

    final Widget dayText = SGText(
      text: '${date.day}',
      size: 14,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      color: isSelected
          ? SGAppColors.info700
          : (isToday ? SGAppColors.primary600 : textColor),
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: Tooltip(
        message: '${date.day}/${date.month}/${date.year}',
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          hoverColor: SGAppColors.colorBorderGray.withOpacity(0.15),
          onTap: isDisabled
              ? null
              : () {
                  setState(() {
                    if (_includeTimeToggle) {
                      _selectedDateTime = DateTime(date.year, date.month,
                          date.day, _hour, _minute, _second);
                    } else {
                      _selectedDateTime =
                          DateTime(date.year, date.month, date.day);
                    }
                    _visibleMonth = DateTime(date.year, date.month, 1);
                  });
                  _notifySelectionChanged();
                  _removeOverlay();
                  _focusNode.unfocus();
                  _rebuildOverlay();
                },
          child: SizedBox(
            height: height,
            width: 14,
            child: Stack(
              alignment: Alignment.center,
              children: [
                dayText,
                if (isSelected)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 14,
                      height: 2,
                      decoration: BoxDecoration(
                        color: SGAppColors.error500,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                if (isToday && !isSelected)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 14,
                      height: 2,
                      decoration: BoxDecoration(
                        color: SGAppColors.info400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      )
    );
  }

  // Thêm _buildMonthCalendarGrid
  Widget _buildMonthCalendarGrid() {
    const double cellHeight = 40;
    const double cellWidth = 80;
    
    final DateTime today = DateTime.now();
    List<TableRow> rows = [];

    for (int row = 0; row < 4; row++) {
      List<Widget> cells = [];
      for (int col = 0; col < 3; col++) {
        final month = row * 3 + col + 1;
        final date = DateTime(_visibleMonth.year, month, 1);
        
        final bool isToday = today.year == date.year && today.month == date.month;
        final bool isSelected = _selectedDateTime != null &&
            _selectedDateTime!.year == date.year &&
            _selectedDateTime!.month == date.month;
        
        final bool isDisabled = (widget.firstDate != null &&
                date.isBefore(DateTime(widget.firstDate!.year, widget.firstDate!.month, 1))) ||
            (widget.lastDate != null &&
                date.isAfter(DateTime(widget.lastDate!.year, widget.lastDate!.month, 1)));

        cells.add(_buildMonthCell(
          date: date,
          isToday: isToday,
          isSelected: isSelected,
          isDisabled: isDisabled,
          width: cellWidth,
          height: cellHeight,
        ));
      }
      rows.add(TableRow(children: cells));
    }

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }

  // Thêm _buildYearCalendarGrid
  Widget _buildYearCalendarGrid() {
    const double cellHeight = 40;
    const double cellWidth = 60;
    
    final DateTime today = DateTime.now();
    final int startYear = (_visibleMonth.year ~/ 12) * 12;
    List<TableRow> rows = [];

    for (int row = 0; row < 4; row++) {
      List<Widget> cells = [];
      for (int col = 0; col < 3; col++) {
        final year = startYear + row * 3 + col;
        
        final bool isToday = today.year == year;
        final bool isSelected = _selectedDateTime != null && _selectedDateTime!.year == year;
        
        final bool isDisabled = (widget.firstDate != null && year < widget.firstDate!.year) ||
            (widget.lastDate != null && year > widget.lastDate!.year);

        cells.add(_buildYearCell(
          year: year,
          isToday: isToday,
          isSelected: isSelected,
          isDisabled: isDisabled,
          width: cellWidth,
          height: cellHeight,
        ));
      }
      rows.add(TableRow(children: cells));
    }

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }

  // Thêm _buildMonthCell
  Widget _buildMonthCell({
    required DateTime date,
    required bool isToday,
    required bool isSelected,
    required bool isDisabled,
    required double width,
    required double height,
  }) {
    final String monthName = DateFormat('MMM').format(date);
    final Color textColor = isDisabled ? Colors.grey : Colors.black87;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: isDisabled ? null : () {
          setState(() {
            _selectedDateTime = DateTime(date.year, date.month, 1);
            _visibleMonth = DateTime(date.year, date.month, 1);
          });
          _notifySelectionChanged();
          _removeOverlay();
          _focusNode.unfocus();
        },
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? SGAppColors.info100 : null,
            borderRadius: BorderRadius.circular(6),
            border: isToday ? Border.all(color: SGAppColors.primary600) : null,
          ),
          child: Text(
            monthName,
            style: TextStyle(
              color: isSelected ? SGAppColors.info700 : textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // Thêm _buildYearCell
  Widget _buildYearCell({
    required int year,
    required bool isToday,
    required bool isSelected,
    required bool isDisabled,
    required double width,
    required double height,
  }) {
    final Color textColor = isDisabled ? Colors.grey : Colors.black87;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: isDisabled ? null : () {
          setState(() {
            _selectedDateTime = DateTime(year, 1, 1);
            _visibleMonth = DateTime(year, 1, 1);
          });
          _notifySelectionChanged();
          _removeOverlay();
          _focusNode.unfocus();
        },
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? SGAppColors.info100 : null,
            borderRadius: BorderRadius.circular(6),
            border: isToday ? Border.all(color: SGAppColors.primary600) : null,
          ),
          child: Text(
            year.toString(),
            style: TextStyle(
              color: isSelected ? SGAppColors.info700 : textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      )
    );
  }

  Widget _buildTimeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.timeOptional)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SGText(
                    text: 'Chọn thời gian',
                    size: 12,
                    fontWeight: FontWeight.w600),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SgCheckbox(
                    size: 20,
                    value: _includeTimeToggle,
                    onChanged: (v) {
                      setState(() {
                        _includeTimeToggle = v;
                        _hour = DateTime.now().hour;
                        _minute = DateTime.now().minute;
                        _second = DateTime.now().second;
                        _hourController.text = _hour.toString().padLeft(2, '0');
                        _minuteController.text =
                            _minute.toString().padLeft(2, '0');
                        _secondController.text =
                            _second.toString().padLeft(2, '0');
                      });

                      if (_selectedDateTime != null) {
                        _notifySelectionChanged();
                      }
                      _rebuildOverlay();
                    },
                  ),
                )
              ],
            ),
          if (!widget.timeOptional || _includeTimeToggle)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNumberDropdown('Giờ', 0, 23, _hour, (v) {
                  setState(() => _hour = v);
                  _hourController.text = _hour.toString().padLeft(2, '0');
                  if (_selectedDateTime != null) _notifySelectionChanged();
                  _rebuildOverlay();
                }, controller: _hourController),
                const SizedBox(width: 8),
                _buildNumberDropdown('Phút', 0, 59, _minute, (v) {
                  setState(() => _minute = v);
                  _minuteController.text = _minute.toString().padLeft(2, '0');
                  if (_selectedDateTime != null) _notifySelectionChanged();
                  _rebuildOverlay();
                }, controller: _minuteController),
                if (widget.includeSeconds) ...[
                  const SizedBox(width: 8),
                  _buildNumberDropdown('Giây', 0, 59, _second, (v) {
                    setState(() => _second = v);
                    _secondController.text = _second.toString().padLeft(2, '0');
                    if (_selectedDateTime != null) _notifySelectionChanged();
                    _rebuildOverlay();
                  }, controller: _secondController),
                ]
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNumberDropdown(
      String label, int min, int max, int value, ValueChanged<int> onChanged,
      {required TextEditingController controller}) {
    final items = List.generate(max - min + 1, (i) => min + i);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(width: 6),
        SGDropdownInputButton<int>(
          items: items
              .map((e) => DropdownMenuItem(
                  value: e, child: Text(e.toString().padLeft(2, '0'))))
              .toList(),
          value: value,
          onChanged: (v) {
            onChanged(v ?? value);
          },
          controller: controller,
          width: 25,
          height: 25,
          maxLength: 2,
          isShowSuffixIcon: false,
          sizeBorderCircular: 5,
          fontSize: 12,
          colorBorder: SGAppColors.colorBorderGray,
          allowFreeInput: true,
          onFreeInputSubmitted: (text) {
            final parsed = int.tryParse(text);
            if (parsed != null && parsed >= min && parsed <= max) {
              onChanged(parsed);
            } else {
              // keep text, but do not change numeric value if invalid
            }
          },
          colorBorderFocus: SGAppColors.info500,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          // showUnderlineBorderOnly: true,
        ),
      ],
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
          onTap: () {
            final now = DateTime.now();
            setState(() {
              _visibleMonth = DateTime(now.year, now.month, 1);
              if (_includeTimeToggle) {
                _selectedDateTime = DateTime(
                    now.year, now.month, now.day, _hour, _minute, _second);
              } else {
                _selectedDateTime = DateTime(now.year, now.month, now.day);
              }
            });
            _notifySelectionChanged();
            _removeOverlay();
            _focusNode.unfocus();
            _rebuildOverlay();
          },
          child: const SGText(
              text: 'Hôm nay',
              color: SGAppColors.info400,
              size: 12,
              fontWeight: FontWeight.w600)),
    );
  }

  void _commitTextIfPossible() {
    final text = widget.controller.text.trim();
    if (text.isEmpty) {
      _selectedDateTime = null;
      widget.onChanged(null);
      return;
    }

    final parsed = _tryParseVietnameseDateTime(text);
    if (parsed != null) {
      _selectedDateTime = parsed;
      _hour = parsed.hour;
      _minute = parsed.minute;
      _second = parsed.second;
      _includeTimeToggle = _hasNonZeroTime(parsed);
      _setControllerTextFromDate(parsed);
      widget.onChanged(parsed);
    }
  }

  // Formatting helpers
  String _formatDate(DateTime dateTime, {required bool includeTime}) {
    String defaultDateFmt;
    
    switch (widget.dateTimeMode) {
      case SGDateTimeMode.dayMonthYear:
        defaultDateFmt = widget.dateFormat ?? 'dd/MM/yyyy';
        break;
      case SGDateTimeMode.monthYear:
        defaultDateFmt = widget.dateFormat ?? 'MM/yyyy';
        break;
      case SGDateTimeMode.year:
        defaultDateFmt = widget.dateFormat ?? 'yyyy';
        break;
    }
    
    final defaultDateTimeFmt = widget.dateTimeFormat ??
        (widget.includeSeconds ? '$defaultDateFmt HH:mm:ss' : '$defaultDateFmt HH:mm');
    final fmt = DateFormat(includeTime ? defaultDateTimeFmt : defaultDateFmt);
    return fmt.format(dateTime);
  }

  void _setControllerTextFromDate(DateTime? dateTime) {
    isProgrammaticChange = true;
    if (dateTime == null) {
      widget.controller.text = '';
    } else {
      final includeTime = widget.showTimeSection &&
          (_includeTimeToggle || !widget.timeOptional);
      widget.controller.text = _formatDate(dateTime, includeTime: includeTime);
    }
    isProgrammaticChange = false;
  }

  DateTime? _tryParseVietnameseDateTime(String text) {
    List<String> patterns = [];
    
    switch (widget.dateTimeMode) {
      case SGDateTimeMode.dayMonthYear:
        patterns = [
          'dd/MM/yyyy HH:mm:ss',
          'dd/MM/yyyy HH:mm',
          'd/M/yyyy HH:mm:ss',
          'd/M/yyyy HH:mm',
          'dd-MM-yyyy HH:mm:ss',
          'dd-MM-yyyy HH:mm',
          'yyyy-MM-dd HH:mm:ss',
          'yyyy-MM-dd HH:mm',
          'dd/MM/yyyy',
          'd/M/yyyy',
          'dd-MM-yyyy',
          'yyyy-MM-dd',
        ];
        break;
      case SGDateTimeMode.monthYear:
        patterns = [
          'MM/yyyy HH:mm:ss',
          'MM/yyyy HH:mm',
          'M/yyyy HH:mm:ss',
          'M/yyyy HH:mm',
          'MM-yyyy HH:mm:ss',
          'MM-yyyy HH:mm',
          'yyyy-MM HH:mm:ss',
          'yyyy-MM HH:mm',
          'MM/yyyy',
          'M/yyyy',
          'MM-yyyy',
          'yyyy-MM',
        ];
        break;
      case SGDateTimeMode.year:
        patterns = [
          'yyyy HH:mm:ss',
          'yyyy HH:mm',
          'yyyy',
        ];
        break;
    }

    for (final p in patterns) {
      try {
        final dt = DateFormat(p).parseStrict(text);
        return dt;
      } catch (_) {
        // try next
      }
    }

    // Try fallback parsing
    try {
      final replaced = text.replaceAll('-', '/');
      switch (widget.dateTimeMode) {
        case SGDateTimeMode.dayMonthYear:
          return DateFormat('d/M/yyyy').parse(replaced);
        case SGDateTimeMode.monthYear:
          return DateFormat('M/yyyy').parse(replaced);
        case SGDateTimeMode.year:
          return DateFormat('yyyy').parse(replaced);
      }
    } catch (_) {}

    return null;
  }

  bool _hasNonZeroTime(DateTime dt) =>
      dt.hour != 0 || dt.minute != 0 || dt.second != 0;
  DateTime _stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  // UI build
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            readOnly: widget.enable ? true : !widget.allowTyping,
            enableInteractiveSelection: widget.allowTyping,
            textAlign: widget.textAlign ??
                (widget.showUnderlineBorderOnly
                    ? TextAlign.left
                    : TextAlign.center),
            style: _buildTextStyle(),
            maxLines: 1,
            textAlignVertical: widget.enable ? null : TextAlignVertical.center,
            decoration: _buildInputDecoration(),
            onTap: () {
              if (!_isOpen && !widget.enable) {
                _showOverlay();
              }
            },
            onEditingComplete: () {
              _commitTextIfPossible();
              _removeOverlay();
            },
            inputFormatters: _buildInputFormatters(),
          ),
        ),
      ),
    );
  }

  List<TextInputFormatter>? _buildInputFormatters() {
    // Allow digits, separators '/', '-', space, ':' only
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9/:\- ]')),
    ];
  }

  TextStyle _buildTextStyle() {
    final bool isReadOnly = widget.enable ? true : !widget.allowTyping;
    final Color readOnlyColor = Colors.grey.shade600;
    final baseStyle = TextStyle(
      fontSize: widget.fontSize ?? 14,
      fontWeight: widget.fontWeight ?? FontWeight.normal,
      overflow: widget.textOverflow,
      height: 1.2,
      leadingDistribution: TextLeadingDistribution.even,
      color: isReadOnly
          ? readOnlyColor
          : (widget.textStyle?.color ?? Colors.black),
    );

    return widget.textStyle?.copyWith(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          overflow: widget.textOverflow,
          height: 1.2,
          leadingDistribution: TextLeadingDistribution.even,
          color: isReadOnly
              ? readOnlyColor
              : (widget.textStyle?.color ?? Colors.black),
        ) ??
        baseStyle;
  }

  InputDecoration _buildInputDecoration() {
    const Color normalBgColor = Colors.transparent;
    if (widget.showUnderlineBorderOnly) {
      return InputDecoration(
        label: _buildLabel(),
        isDense: false,
        filled: true,
        fillColor: normalBgColor,
        border: _buildUnderlineBorder(false),
        enabledBorder: _buildUnderlineBorder(false),
        focusedBorder: _buildUnderlineBorder(true),
        suffixIcon: widget.enable ? null : _buildSuffixIcon(),
        contentPadding:
            widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
      );
    } else {
      return InputDecoration(
        label: _buildLabel(),
        isDense: false,
        filled: true,
        fillColor: normalBgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.sizeBorderCircular ?? 12),
          borderSide: BorderSide(
            color: widget.colorBorder ?? SGAppColors.colorBorderGray,
            width: widget.sizeBorderLine ?? 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.sizeBorderCircular ?? 12),
          borderSide: BorderSide(
            color: widget.colorBorderFocus ?? SGAppColors.info500,
            width: widget.sizeBorderLine ?? 1,
          ),
        ),
        suffixIcon: widget.enable ? null : _buildSuffixIcon(),
        contentPadding:
            widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
      );
    }
  }

  InputBorder _buildUnderlineBorder(bool isFocused) {
    if (_isHovering || isFocused) {
      final color = isFocused
          ? (widget.colorBorderFocus ?? SGAppColors.info500)
          : (widget.colorBorder ?? SGAppColors.colorBorderGray);
      return UnderlineInputBorder(
        borderSide: BorderSide(color: color, width: widget.sizeBorderLine ?? 1),
      );
    } else {
      return const UnderlineInputBorder(
        borderSide: BorderSide(color: SGAppColors.colorBorderGray, width: 1),
      );
    }
  }

  Widget _buildSuffixIcon() {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: IconButton(
        icon: const Icon(Icons.calendar_today_outlined, size: 16),
        onPressed: () {
          if (_isOpen) {
            _removeOverlay();
          } else {
            _focusNode.requestFocus();
            _showOverlay();
          }
        },
      ),
    );
  }

  Widget _buildLabel() {
    double fontSize = widget.fontSize ?? 16;
    if (widget.label == '') return const SizedBox.shrink();
    if (widget.isRequired) {
      return RichText(
        text: TextSpan(
          text: widget.label,
          style: TextStyle(
            color: widget.colorLabel ?? Colors.black,
            fontSize: fontSize + 2,
          ),
          children: [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontSize: fontSize + 2),
            ),
          ],
        ),
      );
    } else {
      return Text(
        widget.label,
        style: TextStyle(
          color: widget.colorLabel ?? Colors.black,
          fontSize: fontSize + 2,
        ),
      );
    }
  }
}
