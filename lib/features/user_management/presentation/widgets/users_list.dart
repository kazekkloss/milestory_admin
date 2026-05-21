import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:milestory_admin/core/core_export.dart';
import '../bloc/users_bloc.dart';
import '../../domain/entities/user_list_entity.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(GetUsersEvent());
  }

  void _loadMore() {
    setState(() => _currentPage++);
    context.read<UsersBloc>().add(
          GetUsersEvent(page: _currentPage, isLoadMore: true),
        );
  }

  void _refresh() {
    setState(() => _currentPage = 1);
    context.read<UsersBloc>().add(GetUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    final narrow = SizeConfig.isNarrow(context);
    final c = AppColors.of(context);

    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            narrow ? 16 : 28,
            24,
            narrow ? 16 : 28,
            narrow ? 16 : 20,
          ),
          child: AppContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                  child: Row(
                    children: [
                      Text('Użytkownicy',
                          style: AppTextStyles.of(context)
                              .cardTitle
                              .copyWith(fontSize: 13)),
                      const Spacer(),
                      IconActionButton(
                        icon: FontAwesomeIcons.arrowRotateRight,
                        color: c.textSecondary,
                        tooltip: 'Odśwież',
                        onTap: _refresh,
                      ),
                    ],
                  ),
                ),
                if (state.loading && state.users.isEmpty)
                  const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.users.isEmpty)
                  _EmptyState()
                else
                  Expanded(
                    child: _UserTable(
                      users: state.users,
                      selectedId: state.selectedUser?.id,
                      onLoadMore: _loadMore,
                      canLoadMore: state.users.length % 20 == 0,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Empty
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.users, size: 24, color: c.textMuted),
            const SizedBox(height: 12),
            Text('Brak użytkowników', style: ts.cardTitle.copyWith(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Table
// ─────────────────────────────────────────────
class _UserTable extends StatelessWidget {
  final List<UserListItem> users;
  final String? selectedId;
  final VoidCallback onLoadMore;
  final bool canLoadMore;

  const _UserTable({
    required this.users,
    required this.onLoadMore,
    required this.canLoadMore,
    this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 6),
          child: Row(
            children: [
              Expanded(flex: 5, child: Text('Email', style: ts.caption.copyWith(fontSize: 11, color: c.textMuted))),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: Text('Typ', style: ts.caption.copyWith(fontSize: 11, color: c.textMuted))),
              const SizedBox(width: 12),
              Expanded(flex: 3, child: Text('Weryfikacja', style: ts.caption.copyWith(fontSize: 11, color: c.textMuted))),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: Text('Dołączył', style: ts.caption.copyWith(fontSize: 11, color: c.textMuted))),
            ],
          ),
        ),
        Container(height: 0.5, color: c.borderSubtle),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            itemCount: users.length + (canLoadMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == users.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: SizedBox(
                      height: 36,
                      width: 140,
                      child: GlowButton(
                        onPressed: onLoadMore,
                        text: 'Załaduj więcej',
                        isLoading: false,
                      ),
                    ),
                  ),
                );
              }
              return _UserRow(
              user: users[index],
              isSelected: selectedId == users[index].id,
            );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Single row
// ─────────────────────────────────────────────
class _UserRow extends StatefulWidget {
  final UserListItem user;
  final bool isSelected;
  const _UserRow({required this.user, this.isSelected = false});

  @override
  State<_UserRow> createState() => _UserRowState();
}

class _UserRowState extends State<_UserRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final date = widget.user.createdAt != null
        ? DateFormat('d MMM yyyy', 'pl_PL').format(widget.user.createdAt!)
        : '—';

    final Color bg;
    if (widget.isSelected) {
      bg = c.accent.withValues(alpha: 0.10);
    } else if (_hovered) {
      bg = c.bgInput;
    } else {
      bg = Colors.transparent;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.read<UsersBloc>().add(SelectUserEvent(widget.user)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(c.radiusSm),
            border: widget.isSelected
                ? Border.all(color: c.accent.withValues(alpha: 0.35), width: 0.5)
                : null,
          ),
          child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                widget.user.email,
                style: ts.cardTitle.copyWith(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _TypePill(isAdmin: widget.user.isAdmin),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _VerifyPill(verified: widget.user.verify),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Text(
                date,
                style: ts.caption.copyWith(fontSize: 11, color: c.textMuted),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  final bool isAdmin;
  const _TypePill({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final color = isAdmin
        ? const Color(0xFF378ADD)
        : AppColors.of(context).textSecondary;
    final bg = isAdmin
        ? const Color(0xFF041525)
        : AppColors.of(context).bgElevated;
    final label = isAdmin ? 'Admin' : 'User';

    return Container(
      constraints: const BoxConstraints(minWidth: 58),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _VerifyPill extends StatelessWidget {
  final bool verified;
  const _VerifyPill({required this.verified});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1D9E75);
    const greenBg = Color(0xFF031410);
    final c = AppColors.of(context);
    final color = verified ? green : c.textMuted;
    final bg = verified ? greenBg : c.bgElevated;
    final label = verified ? 'Zweryfikowany' : 'Niezwer.';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}
