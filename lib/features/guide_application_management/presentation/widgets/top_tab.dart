import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../guide_application_export.dart';

class TopTab extends StatefulWidget {
  const TopTab({super.key});

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuideApplicationBloc, GuideApplicationState>(
      builder: (context, state) {
        return Container(
          height: 60,
          margin: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Panel zarządzania zgłoszeniami na przewodnika", style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Liczba zgłoszeń: "),
                        Text(state.stats?.toString() ?? "Ładowanie", style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
