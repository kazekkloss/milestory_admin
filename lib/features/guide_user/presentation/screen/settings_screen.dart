import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/core_export.dart';
import '../../../tour/tour_export.dart';
import '../../guide_user_export.dart';

enum SettingsTab { profile, account, danger }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsTab _activeTab = SettingsTab.profile;

  @override
  Widget build(BuildContext context) {
    final narrow = SizeConfig.isNarrow(context);
    final c = AppColors.of(context);

    return GlobalErrorListener(
      child: Scaffold(
        backgroundColor: c.bg,
        body: AnimatedAppContainer(
          child: narrow ? _narrowLayout() : _wideLayout(),
        ),
      ),
    );
  }

  Widget _wideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SettingsSidebar(
          activeTab: _activeTab,
          onTabSelected: (tab) => setState(() => _activeTab = tab),
        ),
        Expanded(child: _TabContent(activeTab: _activeTab)),
        const _PreviewPanel(),
      ],
    );
  }

  Widget _narrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NarrowTopBar(
          activeTab: _activeTab,
          onTabSelected: (tab) => setState(() => _activeTab = tab),
        ),
        Expanded(
          child: _TabContent(activeTab: _activeTab, narrow: true),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Left sidebar
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsSidebar extends StatelessWidget {
  final SettingsTab activeTab;
  final ValueChanged<SettingsTab> onTabSelected;

  const _SettingsSidebar({
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return AppContainer(
      width: 240,
      roundBottomLeft: false,
      roundTopLeft: false,
      borderLeft: false,
      padding: const EdgeInsets.fromLTRB(10, 28, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ustawienia',
                style: ts.sectionTitle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text('Profil i konto', style: ts.caption),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              _SidebarItem(
                label: 'Profil',
                icon: Icons.person_outline_rounded,
                tab: SettingsTab.profile,
                activeTab: activeTab,
                onTap: onTabSelected,
                c: c,
                ts: ts,
              ),
              const SizedBox(height: 4),
              _SidebarItem(
                label: 'Konto',
                icon: Icons.manage_accounts_outlined,
                tab: SettingsTab.account,
                activeTab: activeTab,
                onTap: onTabSelected,
                c: c,
                ts: ts,
              ),
              const SizedBox(height: 4),
              _SidebarItem(
                label: 'Strefa zagrożenia',
                icon: Icons.warning_amber_rounded,
                tab: SettingsTab.danger,
                activeTab: activeTab,
                onTap: onTabSelected,
                dangerItem: true,
                c: c,
                ts: ts,
              ),
            ],
          ),
          const Spacer(),
          _AccountInfo(c: c, ts: ts),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final SettingsTab tab;
  final SettingsTab activeTab;
  final ValueChanged<SettingsTab> onTap;
  final bool dangerItem;
  final AppColors c;
  final AppTextStyles ts;

  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.tab,
    required this.activeTab,
    required this.onTap,
    this.dangerItem = false,
    required this.c,
    required this.ts,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  bool get _isActive => widget.tab == widget.activeTab;

  Color get _color {
    if (widget.dangerItem) {
      return _isActive || _hovered ? widget.c.dangerColor : widget.c.textMuted;
    }
    if (_isActive) return widget.c.accent;
    return _hovered ? widget.c.textSecondary : widget.c.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _isActive
                ? widget.c.bgInput
                : _hovered
                    ? Color.lerp(widget.c.bgCard, widget.c.bgInput, 0.6)!
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(widget.c.radiusSm),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                child: Icon(widget.icon, size: 18, color: _color),
              ),
              const SizedBox(width: 10),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 160),
                style: widget.ts.caption.copyWith(
                  fontSize: 14,
                  color: _color,
                  fontWeight: _isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountInfo extends StatelessWidget {
  final AppColors c;
  final AppTextStyles ts;

  const _AccountInfo({required this.c, required this.ts});

  @override
  Widget build(BuildContext context) {
    final guideUser =
        context.select<GuideUserBloc, GuideUser>((b) => b.state.guideUser);
    final dateStr = guideUser.createdAt != null
        ? DateFormat('d MMMM yyyy', 'pl').format(guideUser.createdAt!)
        : '—';

    return AppContainer(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KONTO OD',
            style: ts.sectionLabel.copyWith(fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(dateStr, style: ts.cardTitle.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Narrow top bar (mobile)
// ─────────────────────────────────────────────────────────────────────────────

class _NarrowTopBar extends StatelessWidget {
  final SettingsTab activeTab;
  final ValueChanged<SettingsTab> onTabSelected;

  const _NarrowTopBar({
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ustawienia', style: ts.sectionTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 4),
          Text('Profil i konto', style: ts.caption),
          const SizedBox(height: 20),
          Row(
            children: [
              _NarrowTabItem(
                label: 'Profil',
                icon: Icons.person_outline_rounded,
                tab: SettingsTab.profile,
                activeTab: activeTab,
                onTap: onTabSelected,
              ),
              _NarrowTabItem(
                label: 'Konto',
                icon: Icons.manage_accounts_outlined,
                tab: SettingsTab.account,
                activeTab: activeTab,
                onTap: onTabSelected,
              ),
              _NarrowTabItem(
                label: 'Zagrożenie',
                icon: Icons.warning_amber_rounded,
                tab: SettingsTab.danger,
                activeTab: activeTab,
                onTap: onTabSelected,
                isDanger: true,
              ),
            ],
          ),
          Container(height: 1, color: c.borderSubtle),
        ],
      ),
    );
  }
}

class _NarrowTabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final SettingsTab tab;
  final SettingsTab activeTab;
  final ValueChanged<SettingsTab> onTap;
  final bool isDanger;

  const _NarrowTabItem({
    required this.label,
    required this.icon,
    required this.tab,
    required this.activeTab,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final isActive = tab == activeTab;
    final color = isDanger
        ? (isActive ? c.dangerColor : c.textMuted)
        : (isActive ? c.accent : c.textMuted);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(tab),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? color : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: Icon(icon, key: ValueKey(isActive), size: 20, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: ts.caption.copyWith(
                  fontSize: 11,
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab content
// ─────────────────────────────────────────────────────────────────────────────

class _TabContent extends StatelessWidget {
  final SettingsTab activeTab;
  final bool narrow;

  const _TabContent({required this.activeTab, this.narrow = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: narrow
          ? const EdgeInsets.fromLTRB(16, 16, 16, 16)
          : const EdgeInsets.fromLTRB(28, 24, 28, 20),
      child: AppContainer(
          child: switch (activeTab) {
        SettingsTab.profile => const ProfileSettingsTab(),
        SettingsTab.account => const AccountSettingsTab(),
        SettingsTab.danger => const DangerZoneTab(),
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Right preview panel
// ─────────────────────────────────────────────────────────────────────────────

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return AppContainer(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PODGLĄD',
              style: AppTextStyles.of(context)
                  .sectionLabel
                  .copyWith(fontSize: 11)),
          const SizedBox(height: 12),
          _ProfilePreviewCard(c: c, ts: ts),
          const SizedBox(height: 16),
          _TipCard(c: c, ts: ts),
        ],
      ),
    );
  }
}

class _ProfilePreviewCard extends StatelessWidget {
  final AppColors c;
  final AppTextStyles ts;

  const _ProfilePreviewCard({required this.c, required this.ts});

  @override
  Widget build(BuildContext context) {
    final guideUser =
        context.select<GuideUserBloc, GuideUser>((b) => b.state.guideUser);
    final publishedCount = context.select<TourBloc, int>((b) =>
        b.state.allTours.where((t) => t.status == TourStatus.published).length);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(c.radiusMd),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        children: [
          Text(
            'Tak widzą Cię turyści',
            style: ts.caption.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 16),
          _AvatarPreview(guideUser: guideUser, c: c),
          const SizedBox(height: 12),
          Text(
            guideUser.name.isEmpty ? 'Twoja nazwa' : guideUser.name,
            style: ts.cardTitle.copyWith(
              color: guideUser.name.isEmpty ? c.textMuted : c.textPrimary,
              fontStyle:
                  guideUser.name.isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            guideUser.guideDescription.isEmpty
                ? 'Twój opis pojawi się tutaj...'
                : guideUser.guideDescription,
            style: ts.caption.copyWith(
              fontSize: 12,
              color: guideUser.guideDescription.isEmpty
                  ? c.textMuted
                  : c.textSecondary,
              fontStyle: guideUser.guideDescription.isEmpty
                  ? FontStyle.italic
                  : FontStyle.normal,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatItem(value: '$publishedCount', label: 'tras', c: c, ts: ts),
              Container(
                width: 1,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: c.borderSubtle,
              ),
              _StatItem(value: '0', label: 'godzin', c: c, ts: ts),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  final GuideUser guideUser;
  final AppColors c;

  const _AvatarPreview({required this.guideUser, required this.c});

  String _initials(String name) {
    if (name.trim().isEmpty) return '?';
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasAvatar =
        guideUser.avatarUrl != null || guideUser.avatarBytes != null;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.bgElevated,
        border: Border.all(color: c.borderSubtle, width: 1),
      ),
      child: hasAvatar
          ? ClipOval(
              child: guideUser.avatarBytes != null
                  ? Image.memory(guideUser.avatarBytes!, fit: BoxFit.cover)
                  : Image.network(guideUser.avatarUrl!, fit: BoxFit.cover),
            )
          : Center(
              child: Text(
                _initials(guideUser.name),
                style: TextStyle(
                  fontFamily: AppColors.fontBody,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: c.textMuted,
                ),
              ),
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final AppColors c;
  final AppTextStyles ts;

  const _StatItem({
    required this.value,
    required this.label,
    required this.c,
    required this.ts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: ts.cardTitle.copyWith(fontSize: 20),
        ),
        Text(
          label,
          style: ts.caption.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final AppColors c;
  final AppTextStyles ts;

  const _TipCard({required this.c, required this.ts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(c.radiusMd),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: SemanticColors.infoBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: SemanticColors.info.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              size: 15,
              color: SemanticColors.info,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wskazówka',
                  style: ts.caption.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dobry opis przewodnika to 2–3 zdania o tym, co Cię pasjonuje i co odróżnia Twoje trasy. Turyści wybierają osoby, nie tylko trasy.',
                  style: ts.caption.copyWith(fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
