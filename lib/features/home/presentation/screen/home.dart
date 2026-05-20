import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../../tour/tour_export.dart';
import '../../home_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TourBloc>().add(GetToursEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalErrorListener(
      child: Scaffold(
        body: AnimatedAppContainer(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Greeting(),
                        const SizedBox(height: 24),
                        const StatsCard(),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 580) {
                              return const IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(child: StatusDistributionCard()),
                                    SizedBox(width: 16),
                                    Expanded(child: QuickActionsCard()),
                                  ],
                                ),
                              );
                            }
                            return const Column(
                              children: [
                                StatusDistributionCard(),
                                SizedBox(height: 16),
                                QuickActionsCard(),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const NotificationsCard(),
                      ],
                    ),
                  ),
                ),
              ),
              const FooterWidget(isFullContext: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cześć, Adminie',
          style: ts.sectionTitle.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 4),
        Text(
          'Witaj w panelu admina',
          style: ts.caption,
        ),
      ],
    );
  }
}
