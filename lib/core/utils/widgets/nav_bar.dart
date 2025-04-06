import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milestory_crm/features/auth/presentation/auth_bloc/auth_bloc.dart';

class NavBar extends StatefulWidget {
  final Widget child;
  final List<NavBarItem> tabs;
  const NavBar({super.key, required this.child, required this.tabs});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    if (index < widget.tabs.length - 1) {
      setState(() {
        _selectedIndex = index;
      });
      context.go(widget.tabs[index].initialLocation);
    } else {
      context.read<AuthBloc>().add(LogoutEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: widget.tabs
                .map((tab) => NavigationRailDestination(
                      icon: tab.icon,
                      label: Text(tab.label ?? ''),
                    ))
                .toList(),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

class NavBarItem {
  final String initialLocation;
  final Icon icon;
  final String? label;
  const NavBarItem({required this.initialLocation, required this.icon, this.label});
}
