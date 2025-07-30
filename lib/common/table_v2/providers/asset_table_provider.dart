import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/asset_model.dart';

/// Provider for Asset Table state management
class AssetTableProvider with ChangeNotifier {
  List<AssetModel> _assets = [];
  List<AssetModel> _filteredAssets = [];
  String _searchQuery = '';
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _currentPage = 1;
  int _itemsPerPage = 10;
  bool _isLoading = false;

  // Getters
  List<AssetModel> get assets => _filteredAssets;
  int get totalItems => _filteredAssets.length;
  int get totalPages => totalItems == 0 ? 1 : (totalItems / _itemsPerPage).ceil();
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  bool get sortAscending => _sortAscending;
  int get sortColumnIndex => _sortColumnIndex;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  /// Get the items for the current page
  List<AssetModel> get currentPageItems {
    if (totalItems == 0) return [];
    
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage > totalItems
        ? totalItems
        : startIndex + _itemsPerPage;
    
    if (startIndex >= totalItems) return [];
    return _filteredAssets.sublist(startIndex, endIndex);
  }

  /// Load assets from CSV file
  Future<void> loadAssets(BuildContext context) async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final assetBundle = DefaultAssetBundle.of(context);
      final csvData = await assetBundle.loadString('assets/data/tai_san.csv');
      
      _assets = parseAssetCsv(csvData);
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading assets: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Parse CSV data into a list of AssetModel objects
  List<AssetModel> parseAssetCsv(String csvData) {
    List<AssetModel> result = [];
    
    // Split the CSV by lines
    List<String> lines = LineSplitter.split(csvData).toList();
    
    if (lines.isEmpty) return result;
    
    // Get headers
    List<String> headers = _splitCsvLine(lines[0]);
    
    // Parse each line
    for (int i = 1; i < lines.length; i++) {
      List<String> values = _splitCsvLine(lines[i]);
      
      if (values.length != headers.length) continue;
      
      Map<String, dynamic> map = {};
      for (int j = 0; j < headers.length; j++) {
        map[headers[j]] = values[j];
      }
      
      result.add(AssetModel.fromCsv(map));
    }
    
    return result;
  }
  
  /// Helper method to split CSV lines, handling quoted fields
  List<String> _splitCsvLine(String line) {
    List<String> result = [];
    bool inQuotes = false;
    StringBuffer field = StringBuffer();
    
    for (int i = 0; i < line.length; i++) {
      if (line[i] == '"') {
        inQuotes = !inQuotes;
      } else if (line[i] == ',' && !inQuotes) {
        result.add(field.toString());
        field = StringBuffer();
      } else {
        field.write(line[i]);
      }
    }
    
    result.add(field.toString());
    return result;
  }

  /// Set the current page
  void setPage(int page) {
    if (page < 1) page = 1;
    if (page > totalPages) page = totalPages;
    _currentPage = page;
    notifyListeners();
  }

  /// Go to next page
  void nextPage() {
    if (_currentPage < totalPages) {
      _currentPage++;
      notifyListeners();
    }
  }

  /// Go to previous page
  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  /// Set the number of items per page
  void setItemsPerPage(int count) {
    _itemsPerPage = count;
    _currentPage = 1; // Reset to first page
    notifyListeners();
  }

  /// Sort the table by column
  void sort(int columnIndex, bool ascending) {
    _sortColumnIndex = columnIndex;
    _sortAscending = ascending;
    
    _filteredAssets.sort((a, b) {
      Object? aValue, bValue;
      
      switch (columnIndex) {
        case 0: // Asset ID
          aValue = a.assetId;
          bValue = b.assetId;
          break;
        case 1: // Asset Name
          aValue = a.assetName;
          bValue = b.assetName;
          break;
        case 2: // Registration Date
          aValue = a.registrationDate;
          bValue = b.registrationDate;
          break;
        case 3: // Department
          aValue = a.department;
          bValue = b.department;
          break;
        case 4: // Project
          aValue = a.project;
          bValue = b.project;
          break;
        case 5: // Original Price
          aValue = _parseNumberFromString(a.originalPrice);
          bValue = _parseNumberFromString(b.originalPrice);
          break;
        default:
          return 0;
      }
      
      // Handle null values
      if (aValue == null && bValue == null) return 0;
      if (aValue == null) return ascending ? -1 : 1;
      if (bValue == null) return ascending ? 1 : -1;
      
      // Compare values
      int result;
      if (aValue is String && bValue is String) {
        result = aValue.compareTo(bValue);
      } else if (aValue is DateTime && bValue is DateTime) {
        result = aValue.compareTo(bValue);
      } else if (aValue is num && bValue is num) {
        result = aValue.compareTo(bValue);
      } else {
        result = 0;
      }
      
      return ascending ? result : -result;
    });
    
    notifyListeners();
  }
  
  /// Parse a number from a string, handling different formats
  double _parseNumberFromString(String value) {
    if (value.isEmpty) return 0;
    // Remove non-numeric characters except decimal separator
    String cleaned = value.replaceAll(RegExp(r'[^\d.,]'), '').replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0;
  }

  /// Set the search query and filter the assets
  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }
  
  /// Apply filters based on search query
  void _applyFilters() {
    if (_searchQuery.isEmpty) {
      _filteredAssets = List.from(_assets);
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredAssets = _assets.where((asset) {
        return asset.assetId.toLowerCase().contains(query) ||
               asset.assetName.toLowerCase().contains(query) ||
               asset.department.toLowerCase().contains(query) ||
               asset.project.toLowerCase().contains(query);
      }).toList();
    }
    
    // Re-apply current sorting
    sort(_sortColumnIndex, _sortAscending);
  }
} 