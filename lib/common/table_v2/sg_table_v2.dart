import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:se_gay_components/common/table_v2/widget/table_cell.dart';
import 'models/asset_model.dart';
import 'providers/asset_table_provider.dart';
import 'utils/formatters.dart';

/// Main Table Widget
class SGTableV2 extends StatefulWidget {
  const SGTableV2({super.key});

  @override
  State<SGTableV2> createState() => _SGTableV2State();
}

class _SGTableV2State extends State<SGTableV2> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssetTableProvider(),
      child: Builder(builder: (context) {
        // Access provider with the correct context from Builder
        final provider = Provider.of<AssetTableProvider>(context);

        // Load data when provider is first created
        if (provider.assets.isEmpty && !provider.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.loadAssets(context);
          });
        }

        // Use SizedBox.expand to fill available space
        return SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchAndFilters(context, provider),
              const SizedBox(height: 16),
              if (provider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Expanded(
                  child: _buildTable(context, provider),
                ),
              const SizedBox(height: 16),
              _buildPagination(context, provider),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, AssetTableProvider provider) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm tài sản',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: provider.setSearchQuery,
          ),
        ),
        const SizedBox(width: 16),
        DropdownButton<int>(
          value: provider.itemsPerPage,
          items: [10, 20, 50, 100].map((e) => DropdownMenuItem(value: e, child: Text('$e dòng'))).toList(),
          onChanged: (value) {
            if (value != null) provider.setItemsPerPage(value);
          },
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, AssetTableProvider provider) {
    if (provider.totalItems == 0) {
      return const Center(
        child: Text('Không có dữ liệu'),
      );
    }

    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTableHeader(context, provider),
          Expanded(
            child: _buildTableBody(context, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, AssetTableProvider provider) {
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          _buildHeaderCell('Mã tài sản', 0, provider, flex: 2),
          _buildHeaderCell('Tên tài sản', 1, provider, flex: 4),
          _buildHeaderCell('Ngày vào sổ', 2, provider, flex: 2),
          _buildHeaderCell('Đơn vị sử dụng', 3, provider, flex: 3),
          _buildHeaderCell('Dự án', 4, provider, flex: 3),
          _buildHeaderCell('Nguyên giá', 5, provider, flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, int columnIndex, AssetTableProvider provider, {int flex = 1}) {
    final isSorted = provider.sortColumnIndex == columnIndex;

    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          provider.sort(columnIndex, isSorted ? !provider.sortAscending : true);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
              if (isSorted)
                Icon(
                  provider.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableBody(BuildContext context, AssetTableProvider provider) {
    return ListView.builder(
      itemCount: provider.currentPageItems.length,
      itemExtent: 40,
      itemBuilder: (context, index) {
        final asset = provider.currentPageItems[index];
        return _buildTableRow(context, asset, index);
      },
    );
  }

  Widget _buildTableRow(BuildContext context, AssetModel asset, int index) {
    final isEven = index % 2 == 0;

    return Container(
      color: isEven ? Colors.white : Colors.grey[50],
      child: InkWell(
        onTap: () {
          // Handle row tap - show details, etc.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected: ${asset.assetName}')),
          );
        },
        child: ListView.separated(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return SGTableCell(text: asset.assetId, width: 120, height: 40);
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
        // child: Row(
        //   children: [
        //     SGTableCell(text: asset.assetId),
        //     SGTableCell(text: asset.assetName),
        //     SGTableCell(
        //       text: TableFormatters.formatDate(asset.registrationDate),
        //     ),
        //     SGTableCell(text: asset.department),
        //     SGTableCell(text: asset.project),
        //     SGTableCell(text: TableFormatters.formatCurrency(asset.originalPrice), alignment: Alignment.centerRight),
        //   ],
        // ),
      ),
    );
  }

  Widget _buildPagination(BuildContext context, AssetTableProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.first_page),
          onPressed: provider.currentPage > 1 ? () => provider.setPage(1) : null,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: provider.currentPage > 1 ? provider.previousPage : null,
        ),
        const SizedBox(width: 8),
        Text(
          'Trang ${provider.currentPage} / ${provider.totalPages}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: provider.currentPage < provider.totalPages ? provider.nextPage : null,
        ),
        IconButton(
          icon: const Icon(Icons.last_page),
          onPressed: provider.currentPage < provider.totalPages ? () => provider.setPage(provider.totalPages) : null,
        ),
      ],
    );
  }
}

// Example usage
class TableV2Example extends StatelessWidget {
  const TableV2Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý tài sản'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SGTableV2(),
      ),
    );
  }
}
