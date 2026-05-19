import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../../auth/auth_export.dart';
import '../../../guide_user/guide_user_export.dart';
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
    final auth = context.read<AuthBloc>().state;
    final guideUserId = auth.user.guideUserId;
    if (guideUserId != null && guideUserId.isNotEmpty) {
      context
          .read<GuideUserBloc>()
          .add(GetGuideUserEvent(guideUserId: guideUserId));
    }
    context
        .read<TourBloc>()
        .add(GetToursEvent(userId: auth.user.guideUserId ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    final narrow = SizeConfig.isNarrow(context);

    return GlobalErrorListener(
      child: Scaffold(
        body: AnimatedAppContainer(
          child: narrow ? _narrowLayout() : _wideLayout(),
        ),
      ),
    );
  }

  Widget _wideLayout() {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SizedBox(
                width: SizeConfig.sidePanelWidth,
                child: _SidePanel(),
              ),
            ],
          ),
        ),
        const FooterWidget(isFullContext: false),
      ],
    );
  }

  Widget _narrowLayout() {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Greeting(),
                SizedBox(height: 24),
                StatsCard(),
                SizedBox(height: 16),
                StatusDistributionCard(),
                SizedBox(height: 16),
                QuickActionsCard(),
                SizedBox(height: 16),
                NotificationsCard(),
                SizedBox(height: 16),
                MiniProfileCard(),
                SizedBox(height: 16),
                OnboardingChecklistCard(),
                SizedBox(height: 16),
                LastEditedTourCard(),
                SizedBox(height: 24),
              ],
            ),
          ),
          FooterWidget(isFullContext: false),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Side panel (right column on wide layout)
// ─────────────────────────────────────────────
class _SidePanel extends StatelessWidget {
  const _SidePanel();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, 28, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MiniProfileCard(),
          SizedBox(height: 16),
          OnboardingChecklistCard(),
          SizedBox(height: 16),
          LastEditedTourCard(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Greeting
// ─────────────────────────────────────────────
class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);
    final name = context.select<GuideUserBloc, String>(
      (b) => b.state.guideUser.name,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 14,
          runSpacing: 8,
          children: [
            Text(
              'Cześć, ${name.isEmpty ? 'Przewodniku' : name}',
              style: ts.sectionTitle.copyWith(fontSize: 22),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Witaj w panelu przewodnika',
          style: ts.caption,
        ),
      ],
    );
  }
}
