import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milestory_admin/core/core_export.dart';
import 'package:milestory_admin/features/auth/auth_export.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onForgotPassword;
  const LoginForm({
    super.key,
    required this.onForgotPassword,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context
          .read<AuthBloc>()
          .add(SignInEvent(email: _email.text, password: _pass.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final tt = Theme.of(context).textTheme;
    final mobile = SizeConfig.isMobile(context);

    return Center(
      child: AppContainer(
        width: mobile ? double.infinity : 420,
        padding: EdgeInsets.all(mobile ? 24 : 32),
        child: SizedBox(
          height: SizeConfig.authFormHeight,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Zaloguj się', style: tt.headlineLarge),
                const SizedBox(height: 35),
                AppTextFormField(
                  descriptionText: 'Email',
                  controller: _email,
                  hintText: 'kowalski@example.com',
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Pole nie może być puste';
                    }
                    if (!v.contains('@') || !v.contains('.')) {
                      return 'Nieprawidłowy adres e-mail';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                AppTextFormField(
                  descriptionText: 'Hasło',
                  hintText: '••••••••',
                  controller: _pass,
                  obscureText: _obscure,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Center(
                        widthFactor: 1,
                        child: Text(_obscure ? 'pokaż' : 'ukryj',
                            style: tt.labelMedium!.copyWith(color: c.accent)),
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Pole nie może być puste';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: widget.onForgotPassword,
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text('Zapomniałem hasła',
                        style: tt.labelMedium!.copyWith(color: c.accent)),
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      'Twórz trasy, które opowiadają historię',
                      style: ts.caption.copyWith(
                        fontSize: 12,
                        color: c.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _FeatureItem(
                            icon: Icons.map_outlined,
                            label: 'Trasy',
                            c: c,
                            ts: ts),
                        const SizedBox(width: 24),
                        _FeatureItem(
                            icon: Icons.headphones_outlined,
                            label: 'Audio',
                            c: c,
                            ts: ts),
                        const SizedBox(width: 24),
                        _FeatureItem(
                            icon: Icons.people_outline,
                            label: 'Turyści',
                            c: c,
                            ts: ts),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) => GlowButton(
                    width: 200,
                    onPressed: state.loading ? null : _submit,
                    text: 'Zaloguj się',
                    isLoading: state.loading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppColors c;
  final AppTextStyles ts;

  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.c,
    required this.ts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: c.accent.withValues(alpha: 0.5)),
        const SizedBox(height: 6),
        Text(
          label,
          style: ts.caption.copyWith(fontSize: 11, color: c.textMuted),
        ),
      ],
    );
  }
}
