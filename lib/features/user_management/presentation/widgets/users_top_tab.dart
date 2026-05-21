import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milestory_admin/core/core_export.dart';
import '../bloc/users_bloc.dart';

class UsersTopTab extends StatelessWidget {
  const UsersTopTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);
    final narrow = SizeConfig.isNarrow(context);

    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        final total = state.stats?.total ?? state.users.length;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            narrow ? 20 : 28,
            narrow ? 20 : 28,
            narrow ? 20 : 28,
            0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zarządzanie użytkownikami',
                      style: ts.sectionTitle.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lista wszystkich zarejestrowanych użytkowników.',
                      style: ts.caption,
                    ),
                  ],
                ),
              ),
              if (!narrow) _TotalCounter(total: total),
            ],
          ),
        );
      },
    );
  }
}

class _TotalCounter extends StatelessWidget {
  final int total;
  const _TotalCounter({required this.total});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(c.radiusMd),
        border: Border.all(color: c.borderSubtle, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Wszyscy użytkownicy', style: ts.caption),
          const SizedBox(width: 12),
          Text(
            total.toString(),
            style: TextStyle(
              fontFamily: AppColors.fontBody,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
