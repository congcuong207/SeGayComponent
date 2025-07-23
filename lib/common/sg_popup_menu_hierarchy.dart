import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_menu_hierarchy.dart';

/// Model class for menu items with hierarchical structure
class SGPopupMenuItem {
  final String id;
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final List<SGPopupMenuItem> children;

  SGPopupMenuItem({
    required this.id,
    required this.label,
    this.icon,
    this.onTap,
    this.children = const [],
  });

  bool get hasChildren => children.isNotEmpty;
}

/// Hierarchical popup menu that shows nested levels on hover
class SGPopupMenuHierarchy extends StatefulWidget {
  final List<SGPopupMenuItem> items;
  final Widget child;
  final double itemHeight;
  final double itemWidth;
  final bool barrierDismissible;
  
  const SGPopupMenuHierarchy({
    super.key,
    required this.items,
    required this.child,
    this.itemHeight = 40.0,
    this.itemWidth = 180.0,
    this.barrierDismissible = true,
  });

  @override
  State<SGPopupMenuHierarchy> createState() => _SGPopupMenuHierarchyState();
}

class _SGPopupMenuHierarchyState extends State<SGPopupMenuHierarchy> {
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleMenu,
        onHover: (isHovering) {
          if (isHovering && !_isOpen) {
            _openMenu();
          }
        },
        child: widget.child,
      ),
    );
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final OverlayState overlayState = Overlay.of(context);
    const String rootPath = "root";
    
    final menuEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: widget.barrierDismissible ? () => _closeAllMenus() : null,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              width: widget.itemWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                followerAnchor: Alignment.topLeft,
                targetAnchor: Alignment.bottomLeft,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(4),
                  color: SGAppColors.neutral0,
                  child: _buildMenuItems(widget.items, rootPath),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
    SGMenuHierarchy.instance.registerMenu(rootPath, menuEntry);
    overlayState.insert(menuEntry);
    
    _isOpen = true;
  }
  
  Widget _buildMenuItems(List<SGPopupMenuItem> items, String parentPath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        
        return SGMenuPathBuilder(
          parentPath: parentPath,
          itemId: item.id,
          child: _PopupMenuItemWidget(
            item: item,
            itemHeight: widget.itemHeight,
            itemWidth: widget.itemWidth,
            parentPath: parentPath,
            onClose: _closeAllMenus,
          ),
        );
      }).toList(),
    );
  }
  
  void _closeMenu() {
    SGMenuHierarchy.instance.closeAllMenus();
    _isOpen = false;
  }
  
  void _closeAllMenus() {
    SGMenuHierarchy.instance.closeAllMenus();
    _isOpen = false;
  }
}

class _PopupMenuItemWidget extends StatefulWidget {
  final SGPopupMenuItem item;
  final double itemHeight;
  final double itemWidth;
  final String parentPath;
  final VoidCallback onClose;

  const _PopupMenuItemWidget({
    required this.item,
    required this.itemHeight,
    required this.itemWidth,
    required this.parentPath,
    required this.onClose,
  });

  @override
  State<_PopupMenuItemWidget> createState() => _PopupMenuItemWidgetState();
}

class _PopupMenuItemWidgetState extends State<_PopupMenuItemWidget> {
  final LayerLink _layerLink = LayerLink();
  bool _isHovering = false;

  String get itemPath => widget.parentPath.isEmpty 
      ? widget.item.id 
      : '${widget.parentPath}/${widget.item.id}';

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: InkWell(
          onTap: () {
            if (widget.item.onTap != null) {
              widget.onClose();
              widget.item.onTap!();
            }
          },
          child: Container(
            height: widget.itemHeight,
            width: widget.itemWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            color: _isHovering ? SGAppColors.neutral200 : Colors.transparent,
            child: Row(
              children: [
                if (widget.item.icon != null) ...[
                  Icon(
                    widget.item.icon,
                    size: 16,
                    color: SGAppColors.neutral800,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    widget.item.label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: SGAppColors.neutral800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.item.hasChildren)
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: SGAppColors.neutral700,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
    
    if (isHovering) {
      // Khi di chuột qua mục mới, đóng tất cả menu con không liên quan
      SGMenuHierarchy.instance.closeMenusNotInPath(widget.parentPath);
      
      // Nếu có menu con, hiển thị nó
      if (widget.item.hasChildren) {
        _showSubmenu();
      }
    } else {
      // Giữ lại logic trì hoãn đóng hiện tại
      Future.delayed(const Duration(milliseconds: 50), () {
        if (!mounted || _isHovering) return;
        final currentPath = SGMenuHierarchy.instance.getCurrentPath();
        if (currentPath.startsWith(itemPath) && currentPath != itemPath) {
          SGMenuHierarchy.instance.closeMenusNotInPath(itemPath);
        }
      });
    }
  }

  void _showSubmenu() {
    if (!widget.item.hasChildren) return;
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    
    final OverlayState overlayState = Overlay.of(context);
    
    // Close any existing submenus from this item
    SGMenuHierarchy.instance.closeMenusNotInPath(itemPath);
    
    final submenuEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned(
            left: position.dx + widget.itemWidth - 5, // Slight overlap
            top: position.dy,
            width: widget.itemWidth,
            child: CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.topRight,
              followerAnchor: Alignment.topLeft,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(4),
                color: SGAppColors.neutral0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.item.children.map((childItem) {
                    return SGMenuPathBuilder(
                      parentPath: itemPath,
                      itemId: childItem.id,
                      child: _PopupMenuItemWidget(
                        item: childItem,
                        itemHeight: widget.itemHeight,
                        itemWidth: widget.itemWidth,
                        parentPath: itemPath,
                        onClose: widget.onClose,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
    SGMenuHierarchy.instance.registerMenu(itemPath, submenuEntry);
    overlayState.insert(submenuEntry);
    SGMenuHierarchy.instance.setCurrentPath(itemPath);
  }
}