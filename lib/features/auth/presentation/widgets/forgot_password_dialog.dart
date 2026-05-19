import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milestory_admin/core/core_export.dart';
import 'package:milestory_admin/features/auth/auth_export.dart';

class ForgotPasswordForm extends StatefulWidget {
  final VoidCallback onBack;
  const ForgotPasswordForm({super.key, required this.onBack});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _controller = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _controller.text.trim();
    if (email.isEmpty) return;
    context.read<AuthBloc>().add(SendPasswordRecoveryLinkEvent(email: email));
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final tt = Theme.of(context).textTheme;
    final mobile = SizeConfig.isMobile(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          !prev.passwordRecoverySent && curr.passwordRecoverySent,
      listener: (context, state) => setState(() => _sent = true),
      builder: (context, state) {
        return Center(
          child: AppContainer(
            width: mobile ? double.infinity : 420,
            padding: EdgeInsets.all(mobile ? 24 : 32),
            child: SizedBox(
              height: SizeConfig.authFormHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _sent
                    ? _sentContent(tt, ts, c)
                    : _formContent(tt, ts, c, state.loading),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _formContent(
      TextTheme tt, AppTextStyles ts, AppColors c, bool loading) {
    return [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c.accentDim,
          border: Border.all(color: c.accentBorder),
        ),
        child: Icon(Icons.lock_reset_outlined, color: c.accent, size: 22),
      ),
      const SizedBox(height: 16),
      Text('Resetowanie hasła', style: tt.headlineLarge),
      const SizedBox(height: 8),
      Text(
        'Podaj adres email powiązany z kontem.\nWyślemy link do zresetowania hasła.',
        style: ts.body.copyWith(fontSize: 13, height: 1.5),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 28),
      AppTextFormField(
        controller: _controller,
        descriptionText: 'Email',
        hintText: 'kowalski@example.com',
      ),
      const SizedBox(height: 24),
      GlowButton(
        width: 200,
        onPressed: loading ? null : _submit,
        text: 'Wyślij link',
        isLoading: loading,
      ),
      const SizedBox(height: 16),
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: loading ? null : widget.onBack,
          child: Text('Wróć do logowania',
              style: ts.caption.copyWith(color: c.textSecondary)),
        ),
      ),
    ];
  }

  List<Widget> _sentContent(TextTheme tt, AppTextStyles ts, AppColors c) {
    return [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SemanticColors.successBg,
          border: Border.all(color: const Color(0xFF0A2E22)),
        ),
        child: const Icon(Icons.check_circle_outline,
            color: SemanticColors.success, size: 22),
      ),
      const SizedBox(height: 16),
      Text('Sprawdź skrzynkę', style: tt.headlineLarge),
      const SizedBox(height: 8),
      Text(
        'Wysłaliśmy link resetujący hasło.',
        style: ts.body.copyWith(fontSize: 13, height: 1.5),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 28),
      GlowButton(
        width: 200,
        height: 46,
        onPressed: widget.onBack,
        text: 'Wróć do logowania',
        isLoading: false,
      ),
    ];
  }
}
