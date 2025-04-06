import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/core_export.dart';
import '../auth_bloc/auth_bloc.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  bool _obscurePassword = true;

  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: AppContainer(
        //width: 90.w,
        //height: 70.h,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "Logowanie",
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
              ),
              AppTextFormField(
                descriptionText: "email",
                hintText: "kowalski@example.com",
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pole nie może być puste';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Nieprawidłowy adres e-mail';
                  }
                  return null;
                },
              ),
              AppTextFormField(
                descriptionText: "hasło",
                controller: _passwordController,
                obscureText: _obscurePassword,
                hintText: "••••••••",
                suffixIcon: TextButton(
                    child: _obscurePassword ? const Text("pokaż") : const Text("ukryj"),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pole nie może być puste';
                  }
                  return null;
                },
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Row(children: [
                  TextButton(onPressed: () {}, child: const Text("Zapomniałem hasła")),
                  const SizedBox(width: 48, height: 48),
                ]),
              ),
              const SizedBox(height: 10),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Column(
                    spacing: 15,
                    children: [
                      CustomElevatedButton(
                        onPressed: () {
                          if (_signInFormKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(SignInEvent(email: _emailController.text, password: _passwordController.text));
                          }
                        },
                        text: "Zaloguj się",
                        isLoading: state.loading,
                      ),
                      Text("lub", style: Theme.of(context).textTheme.labelMedium),
                      SizedBox(
                        width: 193,
                        child: WhiteButton(
                          onPressed: () {
                            //context.read<AuthBloc>().add(GoogleSignInEvent());
                          },
                          isLoading: state.googleLoading,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset('assets/svg/google_logo.svg', height: 20),
                              const Text("Wejdź za pomocą Google"),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.labelMedium,
                    children: [
                      const TextSpan(text: "Logując się wyrażasz zgodę na\n"),
                      TextSpan(
                        text: "Regulamin",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Otwieram regulamin");
                          },
                      ),
                      const TextSpan(text: " oraz "),
                      TextSpan(
                        text: "Politykę prywatności",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Otwieram politykę prywatności");
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
