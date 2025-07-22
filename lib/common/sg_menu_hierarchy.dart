import 'package:flutter/material.dart';

/// Menu hierarchy system to manage nested menus
class SGMenuHierarchy {
  static final SGMenuHierarchy _instance = SGMenuHierarchy._();
  static SGMenuHierarchy get instance => _instance;
  SGMenuHierarchy._();
  
  // Map of menu path to active overlay entries
  final Map<String, OverlayEntry> _activeMenus = {};
  
  // Current active path
  String _currentPath = '';
  
  // Register a menu at a specific path
  void registerMenu(String path, OverlayEntry entry) {
    _activeMenus[path] = entry;
    _currentPath = path;
  }
  
  // Get the current path
  String getCurrentPath() => _currentPath;
  
  // Check if a path is parent of or equal to the current path
  bool isPathActive(String path) {
    return _currentPath.startsWith(path);
  }
  
  // Set current active path
  void setCurrentPath(String path) {
    _currentPath = path;
  }
  
  // Close menus not in the current path
  void closeMenusNotInPath(String newPath) {
    // Create a list of paths to remove
    final List<String> pathsToRemove = [];
    
    _activeMenus.forEach((path, entry) {
      // If path is not a parent of or equal to the new path, mark for removal
      if (!newPath.startsWith(path)) {
        pathsToRemove.add(path);
      }
    });
    
    // Remove and close the identified menus
    for (final path in pathsToRemove) {
      final entry = _activeMenus.remove(path);
      try {
        entry?.remove();
      } catch (e) {
        print('Error removing menu at path $path: $e');
      }
    }
    
    // Update current path
    _currentPath = newPath;
  }
  
  // Close all menus
  void closeAllMenus() {
    final entries = _activeMenus.values.toList();
    _activeMenus.clear();
    _currentPath = '';
    
    for (final entry in entries) {
      try {
        entry.remove();
      } catch (e) {
        // Ignore errors
      }
    }
  }
  
  // Check if there are active menus
  bool hasActiveMenus() => _activeMenus.isNotEmpty;
  
  // Get count of active menus
  int activeMenuCount() => _activeMenus.length;
}

/// Widget to build a menu path
class SGMenuPathBuilder extends StatelessWidget {
  final String parentPath;
  final String itemId;
  final Widget child;
  
  // Combine parent path and item ID to create the full path
  String get fullPath => parentPath.isEmpty ? itemId : '$parentPath/$itemId';
  
  const SGMenuPathBuilder({
    super.key,
    required this.parentPath,
    required this.itemId,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return child;
  }
} 