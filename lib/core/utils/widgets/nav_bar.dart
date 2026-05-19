import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:milestory_admin/features/auth/presentation/auth_bloc/auth_bloc.dart';

import '../../core_export.dart';

// ─────────────────────────────────────────────────────────────────────
// NAVBAR — shell widget
// ─────────────────────────────────────────────────────────────────────

class NavBar extends StatelessWidget {
  final Widget child;
  final List<NavBarItem> tabs;
  const NavBar({super.key, required this.child, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final location =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final selectedIndex = _resolveIndex(location);
    final primary = Theme.of(context).colorScheme.primary;
    final isMobile = SizeConfig.isMobile(context);
    final isCompact = SizeConfig.isNarrow(context) && !isMobile;

    if (isMobile) {
      return Scaffold(
        body: child,
        bottomNavigationBar: _BottomBar(
          tabs: tabs,
          selectedIndex: selectedIndex,
          primaryColor: primary,
          onItemTapped: (i) => _onItemTapped(context, i),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          _SideRail(
            tabs: tabs,
            selectedIndex: selectedIndex,
            primaryColor: primary,
            onItemTapped: (i) => _onItemTapped(context, i),
            compact: isCompact,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  int _resolveIndex(String location) {
    for (int i = 0; i < tabs.length - 1; i++) {
      if (location.startsWith(tabs[i].initialLocation)) return i;
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index < tabs.length - 1) {
      context.go(tabs[index].initialLocation);
    } else {
      showAppConfirmDialog(
        context: context,
        title: 'Wylogowywanie',
        content: 'Czy na pewno chcesz się wylogować?',
        confirmText: 'Wyloguj',
        onConfirm: () =>
            context.read<AuthBloc>().add(LogoutEvent(isLocal: false)),
      );
    }
  }
}

// ═════════════════════════════════════════════════════════════════════
// SIDE RAIL  (desktop: >= 900  |  compact: 600–900)
// ═════════════════════════════════════════════════════════════════════

class _SideRail extends StatelessWidget {
  final List<NavBarItem> tabs;
  final int selectedIndex;
  final Color primaryColor;
  final ValueChanged<int> onItemTapped;
  final bool compact;

  const _SideRail({
    required this.tabs,
    required this.selectedIndex,
    required this.primaryColor,
    required this.onItemTapped,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final normalTabs = tabs.sublist(0, tabs.length - 1);

    return Container(
      width: compact ? 56 : 72,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          right: BorderSide(color: Color(0xFF313131), width: 1.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const LogoWidget.compact(),
          const SizedBox(height: 28),
          _divider(),
          const SizedBox(height: 12),
          ...List.generate(
              normalTabs.length,
              (i) => _NavItem(
                    icon: normalTabs[i].icon,
                    label: compact ? '' : (normalTabs[i].label ?? ''),
                    tooltipText: normalTabs[i].label ?? '',
                    isSelected: selectedIndex == i,
                    primaryColor: primaryColor,
                    compact: compact,
                    onTap: () => onItemTapped(i),
                  )),
          const Spacer(),
          _divider(),
          const SizedBox(height: 8),
          _NavItem(
            icon: tabs.last.icon,
            label: compact ? '' : (tabs.last.label ?? 'Wyloguj'),
            tooltipText: tabs.last.label ?? 'Wyloguj',
            isSelected: false,
            primaryColor: primaryColor,
            isLogout: true,
            compact: compact,
            onTap: () => onItemTapped(tabs.length - 1),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: compact ? 28 : 36,
        height: 1,
        color: const Color(0xFF313131),
      );
}

// ═════════════════════════════════════════════════════════════════════
// NAV ITEM  (side rail)
// ═════════════════════════════════════════════════════════════════════

class _NavItem extends StatefulWidget {
  final Icon icon;
  final String label;
  final String tooltipText;
  final bool isSelected;
  final Color primaryColor;
  final bool isLogout;
  final bool compact;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.tooltipText,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
    this.isLogout = false,
    this.compact = false,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  Color get _iconColor {
    if (widget.isSelected) return widget.primaryColor;
    if (widget.isLogout && _hovered) return const Color(0xFFE24B4A);
    return _hovered ? Colors.white70 : const Color(0xFF787878);
  }

  Color get _labelColor {
    if (widget.isSelected) return widget.primaryColor;
    if (widget.isLogout && _hovered) return const Color(0xFFE24B4A);
    return _hovered ? Colors.white54 : const Color(0xFF5A5A5A);
  }

  Color get _bg {
    if (widget.isSelected) return widget.primaryColor.withValues(alpha: 0.1);
    if (_hovered) {
      return widget.isLogout
          ? const Color(0xFFE24B4A).withValues(alpha: 0.08)
          : Colors.white.withValues(alpha: 0.05);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.compact ? 44.0 : 56.0;

    return Tooltip(
      message: widget.tooltipText,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF313131)),
      ),
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        color: Color(0xFFC8C8C8),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Stack(
              children: [
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconTheme(
                          data: IconThemeData(
                            color: _iconColor,
                            size: widget.compact ? 20 : 22,
                          ),
                          child: widget.icon,
                        ),
                        if (widget.label.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.label,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              fontWeight: widget.isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: _labelColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
// BOTTOM BAR  (mobile < 600px)
// ═════════════════════════════════════════════════════════════════════

class _BottomBar extends StatelessWidget {
  final List<NavBarItem> tabs;
  final int selectedIndex;
  final Color primaryColor;
  final ValueChanged<int> onItemTapped;

  const _BottomBar({
    required this.tabs,
    required this.selectedIndex,
    required this.primaryColor,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Color(0xFF313131), width: 1.0)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final isSelected = i < tabs.length - 1 && selectedIndex == i;
              return _BottomBarItem(
                icon: tabs[i].icon,
                label: tabs[i].label ?? '',
                isSelected: isSelected,
                primaryColor: primaryColor,
                onTap: () => onItemTapped(i),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final Icon icon;
  final String label;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? primaryColor : const Color(0xFF787878);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(color: color, size: 20),
              child: icon,
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// NAV BAR ITEM MODEL
// ─────────────────────────────────────────────────────────────────────

class NavBarItem {
  final String initialLocation;
  final Icon icon;
  final String? label;
  const NavBarItem({
    required this.initialLocation,
    required this.icon,
    this.label,
  });
}
