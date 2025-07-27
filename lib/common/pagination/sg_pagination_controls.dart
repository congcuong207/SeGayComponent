import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/sg_text.dart';

class SGPaginationControls extends StatelessWidget {
  final String? labelRowsPerPage;
  final int totalPages;
  final int currentPage;
  final int rowsPerPage;
  final TextEditingController controllerDropdownPage;
  final List<DropdownMenuItem<int>> items;
  final Function(int?) onRowsPerPageChanged;
  final Function(int) onPageChanged;
  final TextStyle? styleLabelRowsPerPage;
  final TextStyle? styleEntries;

  const SGPaginationControls({
    super.key,
    this.labelRowsPerPage,
    required this.totalPages,
    required this.currentPage,
    required this.rowsPerPage,
    required this.controllerDropdownPage,
    required this.items,
    required this.onPageChanged,
    required this.onRowsPerPageChanged,
    this.styleLabelRowsPerPage,
    this.styleEntries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 1, color: SGAppColors.neutral500),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              SGText(
                text: labelRowsPerPage ?? 'Row Per Page',
                style: styleLabelRowsPerPage ??
                    const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: SGAppColors.neutral900,
                    ),
              ),
              const SizedBox(width: 8),
              SGDropdownInputButton<int>(
                controller: controllerDropdownPage,
                width: 42,
                height: 25,
                textAlign: TextAlign.center,
                fontSize: 12,
                contentPadding: const EdgeInsets.all(1),
                sizeBorderCircular: 5,
                enableSearch: true,
                isShowSuffixIcon: false,
                colorSelectedText: SGAppColors.colorFE9F43,
                colorBorder: SGAppColors.colorC0C0C0,
                colorBorderFocus: SGAppColors.colorC0C0C0,
                value: rowsPerPage,
                items: items,
                onChanged: onRowsPerPageChanged,
              ),
              const SizedBox(width: 8),
              SGText(
                text: 'Mục',
                style: styleEntries ??
                    const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: SGAppColors.neutral900,
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 24,),
                onPressed: currentPage > 1
                    ? () {
                        onPageChanged(currentPage - 1);
                      }
                    : null,
              ),
              _buildPageNumbers(),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 24,),
                onPressed: currentPage < totalPages
                    ? () {
                        onPageChanged(currentPage + 1);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageNumbers() {
    const int maxVisiblePages = 5;
    int startPage;
    int endPage;

    if (totalPages <= maxVisiblePages) {
      startPage = 1;
      endPage = totalPages;
    } else {
      const int half = maxVisiblePages ~/ 2;

      if (currentPage <= half + 1) {
        startPage = 1;
        endPage = maxVisiblePages;
      } else if (currentPage >= totalPages - half) {
        startPage = totalPages - maxVisiblePages + 1;
        endPage = totalPages;
      } else {
        startPage = currentPage - half;
        endPage = currentPage + half;
      }
    }

    List<Widget> pageButtons = [];

    if (startPage > 1) {
      pageButtons.add(_buildPageButton(1));
      if (startPage > 2) {
        pageButtons.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('...'),
          ),
        );
      }
    }

    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(_buildPageButton(i));
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageButtons.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('...'),
          ),
        );
      }
      pageButtons.add(_buildPageButton(totalPages));
    }

    return Row(children: pageButtons);
  }

  Widget _buildPageButton(int page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: currentPage == page ? SGAppColors.colorFE9F43 : SGAppColors.neutral100,
          foregroundColor: currentPage == page ? Colors.white : SGAppColors.neutral500,
          minimumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          onPageChanged(page);
        },
        child: Text(
          page.toString(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: currentPage == page ? Colors.white : SGAppColors.neutral900,
          ),
        ),
      ),
    );
  }
}
