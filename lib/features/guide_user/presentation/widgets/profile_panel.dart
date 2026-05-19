import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../../auth/auth_export.dart';
import '../../../tour/tour_export.dart';
import '../../guide_user_export.dart';

class ProfilePanel extends StatefulWidget {
  const ProfilePanel({super.key});

  @override
  State<ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends State<ProfilePanel> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  Uint8List? _pendingAvatarBytes;
  String? _pendingAvatarFileName;
  String? _avatarUrlToDelete;
  bool _avatarDeleted = false;
  bool _isEditingName = false;
  bool _isEditingDescription = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final guideUser = context.read<GuideUserBloc>().state.guideUser;
    _nameController = TextEditingController(text: guideUser.name);
    _descriptionController =
        TextEditingController(text: guideUser.guideDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final narrow = SizeConfig.isNarrow(context);
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return BlocListener<GuideUserBloc, GuideUserState>(
      listenWhen: (prev, curr) =>
          prev.guideUser.guideDescription != curr.guideUser.guideDescription ||
          (prev.loading && !curr.loading),
      listener: (context, state) {
        if (!_isEditingDescription) {
          _descriptionController.text = state.guideUser.guideDescription;
        }
        if (!state.loading) {
          setState(() {
            _hasChanges = false;
            _isEditingName = false;
            _isEditingDescription = false;
            _pendingAvatarBytes = null;
            _pendingAvatarFileName = null;
            _avatarDeleted = false;
            _avatarUrlToDelete = null;
          });
        }
      },
      child: _ProfileContainer(
        isNarrow: narrow,
        child: narrow
            ? _profileContent(c, ts)
            : SingleChildScrollView(
                child: _profileContent(c, ts),
              ),
      ),
    );
  }

  Widget _profileContent(AppColors c, AppTextStyles ts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PROFIL PRZEWODNIKA',
            style: ts.sectionLabel.copyWith(fontSize: 11)),
        const SizedBox(height: 20),
        _avatarSection(context, c, ts),
        const SizedBox(height: 24),
        _fieldsSection(context, c, ts),
        const SizedBox(height: 28),
        _saveButton(context, c),
        const SizedBox(height: 40),
        _passwordNote(context, c, ts),
        const SizedBox(height: 24),
        _dangerZone(context, c, ts),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Avatar
  // ─────────────────────────────────────────────
  Widget _avatarSection(BuildContext context, AppColors c, AppTextStyles ts) {
    final guideState = context.watch<GuideUserBloc>().state;
    return AppContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarPicker(
            savedUrl: guideState.guideUser.avatarUrl,
            initials: _initials(guideState.guideUser.name),
            onPicked: (bytes, name) => setState(() {
              _pendingAvatarBytes = bytes;
              _pendingAvatarFileName = name;
              _avatarDeleted = false;
              _avatarUrlToDelete = null;
              _hasChanges = true;
            }),
            onRemoved: () => setState(() {
              if (_pendingAvatarBytes != null) {
                _pendingAvatarBytes = null;
                _pendingAvatarFileName = null;
              } else {
                _avatarUrlToDelete = guideState.guideUser.avatarUrl;
                _avatarDeleted = true;
              }
              _hasChanges = true;
            }),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guideState.guideUser.name.isEmpty
                      ? 'Przewodnik'
                      : guideState.guideUser.name,
                  style: ts.cardTitle,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text('Przewodnik MileStory', style: ts.caption),
                const SizedBox(height: 8),
                BlocSelector<TourBloc, TourState, bool>(
                  selector: (state) => state.tours
                      .any((t) => t.status == TourStatus.published),
                  builder: (context, isActive) => StatusPill(
                    label: isActive ? 'Aktywny' : 'Nieaktywny',
                    color: isActive
                        ? const Color(0xFF1D9E75)
                        : AppColors.of(context).textMuted,
                    size: 20,
                    selected: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Fields
  // ─────────────────────────────────────────────
  Widget _fieldsSection(BuildContext context, AppColors c, AppTextStyles ts) {
    return AppContainer(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<GuideUserBloc, GuideUserState>(
        builder: (context, guideState) {
          if (!_isEditingDescription &&
              _descriptionController.text.isEmpty &&
              guideState.guideUser.guideDescription.isNotEmpty) {
            _descriptionController.text = guideState.guideUser.guideDescription;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DANE KONTA', style: ts.sectionLabel.copyWith(fontSize: 11)),
              const SizedBox(height: 14),
              Builder(builder: (context) {
                final guideState = context.watch<GuideUserBloc>().state;
                if (!_isEditingName) {
                  _nameController.text = guideState.guideUser.name;
                }
                return AppTextFormField(
                  controller: _nameController,
                  descriptionText: 'Nazwa przewodnika',
                  hintText: 'np. Przewodnik Kazimierz',
                  maxLength: 40,
                  onChanged: (_) => setState(() {
                    _isEditingName = true;
                    _hasChanges = true;
                  }),
                );
              }),
              AppTextFormField(
                controller: _descriptionController,
                descriptionText: 'Opis dla turystów',
                hintText:
                    'Opowiedz o sobie, swoich zainteresowaniach i doświadczeniu...',
                maxLines: 6,
                maxLength: 400,
                onChanged: (_) => setState(() {
                  _isEditingDescription = true;
                  _hasChanges = true;
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Save
  // ─────────────────────────────────────────────
  Widget _saveButton(BuildContext context, AppColors c) {
    return BlocBuilder<GuideUserBloc, GuideUserState>(
      builder: (context, state) {
        final hasChanges = _hasChanges;

        return GlowButton(
          onPressed: hasChanges ? () => _saveAll(context, state) : null,
          text: 'Zapisz zmiany',
          isLoading: state.loading,
        );
      },
    );
  }

  Widget _passwordNote(BuildContext context, AppColors c, AppTextStyles ts) {
    return Row(
      children: [
        Icon(Icons.phonelink_lock, color: c.textMuted, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Zmiana hasła jest dostępna wyłącznie w aplikacji mobilnej MileStory.',
            style: ts.caption,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Danger zone
  // ─────────────────────────────────────────────
  Widget _dangerZone(BuildContext context, AppColors c, AppTextStyles ts) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, curr) =>
          prev.deleteAccountLoading != curr.deleteAccountLoading,
      builder: (context, authState) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.bgCard,
            borderRadius: BorderRadius.circular(c.radiusMd),
            border: Border.all(
              color: c.dangerColor.withValues(alpha: 0.35),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STREFA ZAGROŻENIA',
                style: ts.sectionLabel.copyWith(
                  fontSize: 11,
                  color: c.dangerColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Usunięcie konta jest nieodwracalne. Trasy opublikowane pozostaną w MileStory — wszystkie pozostałe (szkice, odrzucone, prywatne) zostaną trwale usunięte.',
                style: ts.caption.copyWith(fontSize: 12, height: 1.5),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: authState.deleteAccountLoading
                      ? null
                      : () => showAppConfirmDialog(
                            context: context,
                            title: 'Usunąć konto?',
                            content:
                                'Ta akcja jest nieodwracalna. Zalogujesz się i nie odzyskasz dostępu do konta.',
                            warningContent:
                                'Trasy opublikowane pozostaną w MileStory. Szkice, odrzucone i prywatne zostaną trwale usunięte.',
                            confirmText: 'Usuń konto',
                            cancelText: 'Anuluj',
                            isDestructive: true,
                            onConfirm: () => context
                                .read<AuthBloc>()
                                .add(DeleteAccountEvent()),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.dangerColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(c.radiusSm),
                    ),
                  ),
                  child: authState.deleteAccountLoading
                      ? const SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Usuń konto',
                          style: ts.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveAll(BuildContext context, GuideUserState guideState) {
    final updated = guideState.guideUser.copyWith(
      name: _nameController.text.trim(),
      guideDescription: _descriptionController.text.trim(),
      avatarUrl: _avatarDeleted ? null : guideState.guideUser.avatarUrl,
      avatarBytes: _pendingAvatarBytes,
      avatarFileName: _pendingAvatarFileName,
    );

    showAppConfirmDialog(
      context: context,
      title: 'Zapisz zmiany',
      content: 'Czy na pewno chcesz zapisać zmiany w profilu?',
      confirmText: 'Zapisz',
      onConfirm: () => context.read<GuideUserBloc>().add(UpdateGuideUserEvent(
            guideUser: updated,
            deleteAvatarUrl: _avatarUrlToDelete,
          )),
    );
  }
}

class _ProfileContainer extends StatelessWidget {
  final Widget child;
  final bool isNarrow;
  const _ProfileContainer({required this.child, required this.isNarrow});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    if (isNarrow) {
      return AppContainer(child: child);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(c.radiusLg),
          topRight: Radius.circular(c.radiusLg),
          bottomRight: Radius.circular(c.radiusLg),
        ),
        border: Border.all(color: c.accentBorder),
      ),
      child: child,
    );
  }
}
