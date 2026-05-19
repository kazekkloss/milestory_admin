import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../../auth/auth_export.dart';
import '../../guide_user_export.dart';

class DangerZoneTab extends StatefulWidget {
  const DangerZoneTab({super.key});

  @override
  State<DangerZoneTab> createState() => _DangerZoneTabState();
}

class _DangerZoneTabState extends State<DangerZoneTab> {
  late TextEditingController _confirmController;

  @override
  void initState() {
    super.initState();
    _confirmController = TextEditingController();
    _confirmController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  bool _nameMatches(String guideName) => _confirmController.text == guideName;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final guideName =
        context.select<GuideUserBloc, String>((b) => b.state.guideUser.name);
    final isLoading = context.select<AuthBloc, bool>(
      (b) => b.state.deleteAccountLoading,
    );

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Container(
          padding: const EdgeInsets.all(20),
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
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: c.dangerColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'STREFA ZAGROŻENIA',
                    style: ts.sectionLabel.copyWith(
                      fontSize: 11,
                      color: c.dangerColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Usunięcie konta jest nieodwracalne. Trasy opublikowane pozostaną w MileStory (anonimizowane). Wszystkie pozostałe — szkice, prywatne i odrzucone — zostaną trwale usunięte.',
                style: ts.caption.copyWith(fontSize: 13, height: 1.6),
              ),
              const SizedBox(height: 24),
              _ConfirmField(
                guideName: guideName,
                controller: _confirmController,
                c: c,
                ts: ts,
              ),
              const SizedBox(height: 20),
              GlowButton(
                width: 200,
                onPressed: _nameMatches(guideName) && !isLoading
                    ? () => _showCountdownDialog(context)
                    : null,
                color: c.dangerColor,
                text: "Usuń konto bezpowrotnie",
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCountdownDialog(BuildContext context) {
    showCountdownConfirmDialog(
      context: context,
      title: 'Potwierdzenie usunięcia',
      content: 'Ta akcja jest nieodwracalna. Konto zostanie trwale usunięte.',
      onConfirm: () => context.read<AuthBloc>().add(DeleteAccountEvent()),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Confirm field
// ─────────────────────────────────────────────────────────────────────────────

class _ConfirmField extends StatelessWidget {
  final String guideName;
  final TextEditingController controller;
  final AppColors c;
  final AppTextStyles ts;

  const _ConfirmField({
    required this.guideName,
    required this.controller,
    required this.c,
    required this.ts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: ts.caption.copyWith(fontSize: 13),
            children: [
              const TextSpan(text: 'Aby kontynuować, wpisz: '),
              TextSpan(
                text: guideName.isEmpty ? '(brak nazwy)' : guideName,
                style: ts.caption.copyWith(
                  fontSize: 13,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                  backgroundColor: c.bgElevated,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        AppTextFormField(
          controller: controller,
          descriptionText: '',
          hintText: guideName.isEmpty ? 'Brak nazwy przewodnika' : guideName,
        ),
      ],
    );
  }
}

