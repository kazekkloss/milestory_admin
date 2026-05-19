import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../../tour/tour_export.dart';
import '../../guide_user_export.dart';

class ProfileSettingsTab extends StatefulWidget {
  const ProfileSettingsTab({super.key});

  @override
  State<ProfileSettingsTab> createState() => _ProfileSettingsTabState();
}

class _ProfileSettingsTabState extends State<ProfileSettingsTab> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  Uint8List? _pendingAvatarBytes;
  String? _pendingAvatarFileName;
  String? _avatarUrlToDelete;
  bool _avatarDeleted = false;

  // Saved baseline — compared against to compute hasChanges dynamically
  String _savedName = '';
  String _savedDescription = '';

  bool get _hasChanges {
    final nameChanged = _nameController.text.trim() != _savedName;
    final descChanged = _descriptionController.text.trim() != _savedDescription;
    final avatarChanged = _pendingAvatarBytes != null || _avatarDeleted;
    return nameChanged || descChanged || avatarChanged;
  }

  @override
  void initState() {
    super.initState();
    final guideUser = context.read<GuideUserBloc>().state.guideUser;
    _savedName = guideUser.name;
    _savedDescription = guideUser.guideDescription;
    _nameController = TextEditingController(text: _savedName)
      ..addListener(_onTextChanged);
    _descriptionController = TextEditingController(text: _savedDescription)
      ..addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Rebuild so _hasChanges getter is re-evaluated by _SaveRow.
    if (mounted) setState(() {});
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  void _onSaveCompleted(GuideUserState state) {
    _savedName = state.guideUser.name;
    _savedDescription = state.guideUser.guideDescription;
    setState(() {
      _pendingAvatarBytes = null;
      _pendingAvatarFileName = null;
      _avatarDeleted = false;
      _avatarUrlToDelete = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GuideUserBloc, GuideUserState>(
      listenWhen: (p, c) => p.loading && !c.loading,
      listener: (_, state) => _onSaveCompleted(state),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AvatarSection(
                  initials: _initials,
                  onPicked: (bytes, name) => setState(() {
                    _pendingAvatarBytes = bytes;
                    _pendingAvatarFileName = name;
                    _avatarDeleted = false;
                    _avatarUrlToDelete = null;
                  }),
                  onRemoved: (savedUrl) => setState(() {
                    if (_pendingAvatarBytes != null) {
                      _pendingAvatarBytes = null;
                      _pendingAvatarFileName = null;
                    } else {
                      _avatarUrlToDelete = savedUrl;
                      _avatarDeleted = true;
                    }
                  }),
                ),
                const SizedBox(height: 24),
                AppTextFormField(
                  controller: _nameController,
                  descriptionText: 'Nazwa przewodnika',
                  hintText: 'np. Przewodnik Kazimierz',
                  maxLength: 40,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Uzupełnij nazwę przewodnika' : null,
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _descriptionController,
                  descriptionText: 'Opis dla turystów',
                  hintText:
                      'Opowiedz o sobie, swoich zainteresowaniach i doświadczeniu...',
                  maxLines: 6,
                  maxLength: 280,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Uzupełnij opis przewodnika' : null,
                ),
                const SizedBox(height: 16),
                const _VisibilityBanner(),
                const SizedBox(height: 28),
                _SaveRow(
                  hasChanges: _hasChanges,
                  onSave: () => _saveAll(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveAll(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final guideState = context.read<GuideUserBloc>().state;
    final updated = guideState.guideUser.copyWith(
      name: _nameController.text.trim(),
      guideDescription: _descriptionController.text.trim(),
      avatarUrl: _avatarDeleted ? null : guideState.guideUser.avatarUrl,
      avatarBytes: _pendingAvatarBytes,
      avatarFileName: _pendingAvatarFileName,
    );
    context.read<GuideUserBloc>().add(UpdateGuideUserEvent(
          guideUser: updated,
          deleteAvatarUrl: _avatarUrlToDelete,
        ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar section — separate StatelessWidget, reads from BLoC itself
// ─────────────────────────────────────────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  final String Function(String?) initials;
  final void Function(Uint8List, String) onPicked;
  final void Function(String?) onRemoved;

  const _AvatarSection({
    required this.initials,
    required this.onPicked,
    required this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);
    final guideUser = context.select<GuideUserBloc, GuideUser>(
      (b) => b.state.guideUser,
    );

    return AppContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarPicker(
            savedUrl: guideUser.avatarUrl,
            initials: initials(guideUser.name),
            onPicked: onPicked,
            onRemoved: () => onRemoved(guideUser.avatarUrl),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Zdjęcie profilowe', style: ts.cardTitle),
                const SizedBox(height: 4),
                Text(
                  'Widoczne dla turystów w aplikacji. Format JPG lub PNG, do 2 MB.',
                  style: ts.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Visibility banner
// ─────────────────────────────────────────────────────────────────────────────

class _VisibilityBanner extends StatelessWidget {
  const _VisibilityBanner();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final publishedCount = context.select<TourBloc, int>(
      (b) =>
          b.state.tours.where((t) => t.status == TourStatus.published).length,
    );

    final isVisible = publishedCount > 0;
    final color = isVisible ? SemanticColors.success : SemanticColors.warning;
    final icon =
        isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    final baseStyle = ts.caption.copyWith(
      color: c.textSecondary,
      fontSize: 12,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: isVisible
                ? Text(
                    'Widoczny dla turystów. Liczba publicznych tras: $publishedCount',
                    style: baseStyle,
                  )
                : RichText(
                    text: TextSpan(
                      style: baseStyle,
                      children: [
                        const TextSpan(text: 'Twój profil jest '),
                        TextSpan(
                          text: 'niewidoczny dla turystów',
                          style: baseStyle.copyWith(
                            color: SemanticColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' — opublikuj choć jedną trasę, żeby się pojawić w aplikacji.',
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Save row — osobny StatelessWidget żeby mieć własny rebuild
// ─────────────────────────────────────────────────────────────────────────────

class _SaveRow extends StatelessWidget {
  final bool hasChanges;
  final VoidCallback onSave;

  const _SaveRow({
    required this.hasChanges,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select<GuideUserBloc, bool>((b) => b.state.loading);

    return GlowButton(
      onPressed: hasChanges ? onSave : null,
      text: 'Zapisz zmiany',
      isLoading: isLoading,
      width: 200,
    );
  }
}
