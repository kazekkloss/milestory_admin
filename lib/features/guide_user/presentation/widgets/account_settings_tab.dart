import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../../auth/auth_export.dart';

class AccountSettingsTab extends StatefulWidget {
  const AccountSettingsTab({super.key});

  @override
  State<AccountSettingsTab> createState() => _AccountSettingsTabState();
}

class _AccountSettingsTabState extends State<AccountSettingsTab> {
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _cooldownSeconds = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_cooldownSeconds <= 1) {
        t.cancel();
        if (mounted) setState(() => _cooldownSeconds = 0);
      } else {
        if (mounted) setState(() => _cooldownSeconds--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          !prev.passwordRecoverySent && curr.passwordRecoverySent,
      listener: (context, state) => _startCooldown(),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _emailSection(context, c, ts),
              const SizedBox(height: 24),
              _passwordSection(context, c, ts),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Email
  // ─────────────────────────────────────────────
  Widget _emailSection(BuildContext context, AppColors c, AppTextStyles ts) {
    final email = context.select<AuthBloc, String>(
      (bloc) => bloc.state.user.email,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adres e-mail',
          style: ts.caption.copyWith(fontSize: 13),
        ),
        const SizedBox(height: 8),
        AppContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: c.textMuted, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(email, style: ts.cardTitle),
              ),
              Text(
                'W tej chwili zmiana adresu nie jest możliwa',
                style: ts.caption.copyWith(fontSize: 12, color: c.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Password
  // ─────────────────────────────────────────────
  Widget _passwordSection(BuildContext context, AppColors c, AppTextStyles ts) {
    final email = context.select<AuthBloc, String>(
      (bloc) => bloc.state.user.email,
    );
    final isLoading = context.select<AuthBloc, bool>(
      (bloc) => bloc.state.loading,
    );

    return AppContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HASŁO',
            style: ts.sectionLabel.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.lock_reset_outlined, color: c.textMuted, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Zmiana hasła odbywa się przez link resetujący wysłany na Twój adres e-mail.',
                  style: ts.caption,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: c.borderSubtle, height: 1),
          const SizedBox(height: 16),
          Text(
            'Kliknij przycisk poniżej, a wyślemy Ci wiadomość z instrukcją ustawienia nowego hasła.',
            style: ts.caption,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: (_cooldownSeconds > 0 || isLoading)
                ? null
                : () => context
                    .read<AuthBloc>()
                    .add(SendPasswordRecoveryLinkEvent(email: email)),
            icon: isLoading
                ? const SizedBox(
                    width: 13,
                    height: 13,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  )
                : const Icon(Icons.mail_outline, size: 13),
            label: Text(
              _cooldownSeconds > 0
                  ? 'Wyślij ponownie za ${_cooldownSeconds}s'
                  : 'Wyślij link resetujący',
            ),
          ),
        ],
      ),
    );
  }
}
