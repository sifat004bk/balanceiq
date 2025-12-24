import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A model for sub-menu items in the expandable menu
class ProfileSubMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const ProfileSubMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });
}

/// An expandable profile menu item that shows sub-items when expanded
class ExpandableProfileMenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<ProfileSubMenuItem> subItems;
  final Color? iconColor;
  final bool initiallyExpanded;

  const ExpandableProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subItems,
    this.iconColor,
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandableProfileMenuItem> createState() =>
      _ExpandableProfileMenuItemState();
}

class _ExpandableProfileMenuItemState extends State<ExpandableProfileMenuItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.iconColor ?? Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        // Main header item
        InkWell(
          onTap: _toggleExpand,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Icon(
                    LucideIcons.chevronDown,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Expandable sub-items
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, top: 8),
            child: Column(
              children: widget.subItems.map((subItem) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildSubItem(context, subItem),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubItem(BuildContext context, ProfileSubMenuItem subItem) {
    final itemColor =
        subItem.iconColor ?? Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: subItem.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: itemColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                subItem.icon,
                color: itemColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                subItem.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: subItem.titleColor ??
                      Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: Theme.of(context).hintColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
