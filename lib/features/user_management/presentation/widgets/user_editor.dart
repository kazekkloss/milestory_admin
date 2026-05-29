import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:milestory_admin/core/core_export.dart';
import '../bloc/users_bloc.dart';

class UserEditor extends StatelessWidget {
  const UserEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        final user = state.selectedUser;

        if (user == null) {
          return Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: c.borderSubtle, width: 0.5)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FontAwesomeIcons.userPen, size: 24, color: c.textMuted),
                  const SizedBox(height: 12),
                  Text('Wybierz użytkownika z listy',
                      style: AppTextStyles.of(context).caption, textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: c.bg,
            border: Border(left: BorderSide(color: c.borderSubtle, width: 0.5)),
          ),
          child: Column(
            children: [
              _EditorHeader(user: user),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AccountSection(user: user, actionLoading: state.actionLoading),
                      const SizedBox(height: 16),
                      _GuideUserSection(
                        guideUser: state.guideUser,
                        loading: state.guideUserLoading,
                        hasGuideId: user.guideUserId != null && user.guideUserId!.isNotEmpty,
                      ),
                      const SizedBox(height: 16),
                      _ToursButton(user: user, guideUser: state.guideUser),
                      const SizedBox(height: 16),
                      _ActionsSection(user: user, actionLoading: state.actionLoading),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────
class _EditorHeader extends StatelessWidget {
  final dynamic user;
  const _EditorHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.borderSubtle, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(user.email,
                style: ts.cardTitle.copyWith(fontSize: 13),
                overflow: TextOverflow.ellipsis),
          ),
          IconActionButton(
            icon: FontAwesomeIcons.xmark,
            color: c.textSecondary,
            tooltip: 'Zamknij',
            onTap: () => context.read<UsersBloc>().add(SelectUserEvent(null)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sekcja konta
// ─────────────────────────────────────────────
class _AccountSection extends StatelessWidget {
  final dynamic user;
  final bool actionLoading;
  const _AccountSection({required this.user, required this.actionLoading});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final isAdmin = user.type == 'admin';

    return SectionCard(
      label: 'DANE KONTA',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: 'Email', value: user.email),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Dołączył',
            value: user.createdAt != null
                ? '${user.createdAt.day}.${user.createdAt.month.toString().padLeft(2, '0')}.${user.createdAt.year}'
                : '—',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text('Typ konta', style: ts.caption.copyWith(color: c.textSecondary)),
              ),
              _TypeToggle(
                isAdmin: isAdmin,
                loading: actionLoading,
                onToggle: (newIsAdmin) => context.read<UsersBloc>().add(
                      UpdateUserTypeEvent(
                        userId: user.id,
                        type: newIsAdmin ? 'admin' : 'user',
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text('Weryfikacja', style: ts.caption.copyWith(color: c.textSecondary)),
              ),
              if (user.verify)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF031410),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.3), width: 0.5),
                  ),
                  child: const Text('Zweryfikowany',
                      style: TextStyle(fontSize: 11, color: Color(0xFF1D9E75), fontWeight: FontWeight.w500)),
                )
              else
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: c.bgElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: c.borderSubtle, width: 0.5),
                      ),
                      child: Text('Niezweryfikowany',
                          style: TextStyle(fontSize: 11, color: c.textMuted, fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: actionLoading
                          ? null
                          : () => context.read<UsersBloc>().add(VerifyUserEvent(userId: user.id)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: c.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: c.accent.withValues(alpha: 0.3), width: 0.5),
                        ),
                        child: Text('Zweryfikuj',
                            style: TextStyle(fontSize: 11, color: c.accent, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sekcja guide user
// ─────────────────────────────────────────────
class _GuideUserSection extends StatelessWidget {
  final dynamic guideUser;
  final bool loading;
  final bool hasGuideId;
  const _GuideUserSection({required this.guideUser, required this.loading, required this.hasGuideId});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return SectionCard(
      label: 'PROFIL PRZEWODNIKA',
      child: Builder(builder: (context) {
        if (!hasGuideId) {
          return Text('Użytkownik nie ma profilu przewodnika.',
              style: ts.caption.copyWith(color: c.textMuted));
        }
        if (loading) {
          return const SizedBox(
            height: 48,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (guideUser == null) {
          return Text('Nie udało się załadować profilu.',
              style: ts.caption.copyWith(color: c.textMuted));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Avatar(imageUrl: guideUser.imageUrl),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guideUser.name.isNotEmpty ? guideUser.name : 'Brak nazwy',
                        style: ts.cardTitle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (guideUser.bio != null && guideUser.bio!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(guideUser.bio!,
                  style: ts.caption.copyWith(color: c.textSecondary, height: 1.5)),
            ],
          ],
        );
      }),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? imageUrl;
  const _Avatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    const size = 48.0;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: Image.network(imageUrl!, width: size, height: size, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder(c, size)),
      );
    }
    return _placeholder(c, size);
  }

  Widget _placeholder(AppColors c, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.bgElevated,
        shape: BoxShape.circle,
        border: Border.all(color: c.borderSubtle, width: 0.5),
      ),
      child: Icon(FontAwesomeIcons.user, size: 18, color: c.textMuted),
    );
  }
}

// ─────────────────────────────────────────────
// Przycisk tras użytkownika
// ─────────────────────────────────────────────
class _ToursButton extends StatefulWidget {
  final dynamic user;
  final dynamic guideUser;
  const _ToursButton({required this.user, required this.guideUser});

  @override
  State<_ToursButton> createState() => _ToursButtonState();
}

class _ToursButtonState extends State<_ToursButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final name = (widget.guideUser?.name?.isNotEmpty == true)
        ? widget.guideUser!.name as String
        : widget.user.email as String;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.goNamed(
          RouteConstants.dashboard,
          extra: UserToursArgs(
            displayName: name,
            guideUserId: widget.user.guideUserId as String?,
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? c.accent.withValues(alpha: 0.12) : c.bgElevated,
            borderRadius: BorderRadius.circular(c.radiusSm),
            border: Border.all(
              color: _hovered ? c.accent.withValues(alpha: 0.4) : c.borderSubtle,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.route, size: 12, color: c.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Trasy użytkownika',
                  style: ts.caption.copyWith(
                    fontSize: 12,
                    color: c.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, size: 14, color: c.accent.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sekcja akcji
// ─────────────────────────────────────────────
class _ActionsSection extends StatelessWidget {
  final dynamic user;
  final bool actionLoading;
  const _ActionsSection({required this.user, required this.actionLoading});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      label: 'AKCJE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ActionButton(
            label: 'Wymuś wylogowanie',
            icon: FontAwesomeIcons.rightFromBracket,
            color: const Color(0xFFEF9F27),
            loading: actionLoading,
            onTap: () => showAppConfirmDialog(
              context: context,
              title: 'Wymuś wylogowanie',
              content: 'Sesja użytkownika ${user.email} zostanie zakończona.',
              confirmText: 'Wyloguj',
              onConfirm: () => context.read<UsersBloc>().add(LogoutUserEvent(userId: user.id)),
            ),
          ),
          const SizedBox(height: 8),
          _ActionButton(
            label: 'Usuń konto',
            icon: FontAwesomeIcons.trashCan,
            color: const Color(0xFFE24B4A),
            loading: actionLoading,
            onTap: () => showCountdownConfirmDialog(
              context: context,
              title: 'Usuń konto',
              content: 'Konto ${user.email} zostanie trwale usunięte. Tej operacji nie można cofnąć.',
              confirmText: 'Usuń',
              onConfirm: () => context.read<UsersBloc>().add(DeleteUserEvent(userId: user.id)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    return Row(
      children: [
        Expanded(child: Text(label, style: ts.caption.copyWith(color: c.textSecondary))),
        Text(value, style: ts.caption.copyWith(color: c.textPrimary)),
      ],
    );
  }
}

class _TypeToggle extends StatefulWidget {
  final bool isAdmin;
  final bool loading;
  final ValueChanged<bool> onToggle;
  const _TypeToggle({required this.isAdmin, required this.loading, required this.onToggle});

  @override
  State<_TypeToggle> createState() => _TypeToggleState();
}

class _TypeToggleState extends State<_TypeToggle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final label = widget.isAdmin ? 'Admin' : 'User';
    final color = widget.isAdmin ? const Color(0xFF378ADD) : c.textSecondary;
    final bg = widget.isAdmin ? const Color(0xFF041525) : c.bgElevated;

    return MouseRegion(
      cursor: widget.loading ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.loading ? null : () => widget.onToggle(!widget.isAdmin),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _hovered && !widget.loading ? color.withValues(alpha: 0.18) : bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
              const SizedBox(width: 5),
              Icon(FontAwesomeIcons.arrowRightArrowLeft, size: 9, color: color.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool loading;
  final VoidCallback onTap;
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.loading,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return MouseRegion(
      cursor: widget.loading ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.loading ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered && !widget.loading
                ? widget.color.withValues(alpha: 0.12)
                : c.bgElevated,
            borderRadius: BorderRadius.circular(c.radiusSm),
            border: Border.all(
              color: _hovered && !widget.loading
                  ? widget.color.withValues(alpha: 0.4)
                  : c.borderSubtle,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              FaIcon(widget.icon, size: 12, color: widget.color),
              const SizedBox(width: 10),
              Text(widget.label,
                  style: TextStyle(fontSize: 12, color: widget.color, fontWeight: FontWeight.w500)),
              if (widget.loading) ...[
                const Spacer(),
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 1.5, color: widget.color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
