import 'package:flutter/material.dart';
import 'package:milestory_admin/core/core_export.dart';
import 'login_form.dart';
import 'forgot_password_dialog.dart';

enum _AuthTab { login, forgot }

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  _AuthTab _current = _AuthTab.login;

  void _goTo(_AuthTab tab) {
    setState(() => _current = tab);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final narrow = SizeConfig.isNarrow(context);
    final mobile = SizeConfig.isMobile(context);
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    final headlineStyle = ts.hero.copyWith(
      fontSize: mobile
          ? 28
          : narrow
              ? 36
              : 48,
      letterSpacing: mobile ? -0.5 : -0.8,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: h),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/milestory_baner.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: 1),
                Colors.black.withValues(alpha: 0.90),
                Colors.black.withValues(alpha: 0.40),
                Colors.black.withValues(alpha: 0),
              ],
              stops: const [0.0, 0.35, 0.80, 1.0],
            ),
          ),
          child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 32, bottom: 10),
                child: LogoWidget(),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: c.accentBorder),
                  color: c.accentDim,
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: c.accent)),
                  const SizedBox(width: 8),
                  Text('Panel Administracyjny MileStory',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: c.accent, letterSpacing: 0.3)),
                ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mobile ? 20 : 40),
                child: Text('Panel Admina',
                    textAlign: TextAlign.center, style: headlineStyle),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mobile ? 20 : 40),
                child: Text.rich(
                    TextSpan(children: [
                      const TextSpan(text: 'Zarządzaj '),
                      TextSpan(
                          text: 'aplikacją MileStory',
                          style: headlineStyle.copyWith(color: c.accent)),
                    ]),
                    textAlign: TextAlign.center,
                    style: headlineStyle),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mobile ? 24 : 60),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Text(
                      'Panel administracyjny dla przewodników MileStory. '
                      'Zarządzaj trasami, punktami audio i swoim profilem '
                      'w jednym miejscu.',
                      textAlign: TextAlign.center,
                      style: ts.body),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 40),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: switch (_current) {
                    _AuthTab.login => LoginForm(
                        key: const ValueKey(_AuthTab.login),
                        onForgotPassword: () => _goTo(_AuthTab.forgot),
                      ),
                    _AuthTab.forgot => ForgotPasswordForm(
                        key: const ValueKey(_AuthTab.forgot),
                        onBack: () => _goTo(_AuthTab.login),
                      ),
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
