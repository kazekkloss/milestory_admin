import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  void initState() {
    // na local
    _emailController.text = "kazekkloss.kr@gmail.com";

    // na global
    //_emailController.text = "test@admin.com";

    _passwordController.text = "Chujwdupe4!";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: AppContainer(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.symmetric(vertical: 30), child: Text("Logowanie", style: Theme.of(context).textTheme.titleMedium!)),
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
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pole nie może być puste';
                  }
                  return null;
                },
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
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
