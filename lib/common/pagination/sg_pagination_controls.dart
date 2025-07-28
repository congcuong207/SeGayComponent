import 'dart:developer';

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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 1, color: SGAppColors.neutral500),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            // vertical: 12,
          ),
          child: Row(
            children: [
              SGText(text: labelRowsPerPage ?? 'Row Per Page'),
              const SizedBox(width: 8),
              SGDropdownInputButton<int>(
                controller: controllerDropdownPage,
                // inputType: TextInputType.number,
                // defaultValue: 10,
                width: 25,
                height: 25,
                textAlign: TextAlign.center,
                fontSize: 12,
                contentPadding: const EdgeInsets.all(1),
                sizeBorderCircular: 5,
                enableSearch: true,
                isShowSuffixIcon: false,
                colorSelectedText: SGAppColors.error500,
                value: rowsPerPage,
                items: items,
                onChanged: (value) {
                  onRowsPerPageChanged(value);
                },
              ),
              const SizedBox(width: 8),
              const Text('Entries'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed:
                    currentPage > 1
                        ? () {
                          onPageChanged(currentPage - 1);
                        }
                        : null,
              ),
              _buildPageNumbers(),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed:
                    currentPage < totalPages
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
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              currentPage == page ? Colors.orange[400] : Colors.grey[200],
          foregroundColor: currentPage == page ? Colors.white : Colors.black,
          minimumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
          elevation: 0,
          shape: const CircleBorder(),
        ),
        onPressed: () {
          onPageChanged(page);
        },
        child: Text(page.toString()),
      ),
    );
  }
}
