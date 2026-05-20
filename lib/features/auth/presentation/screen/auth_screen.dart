import 'package:flutter/material.dart';
import 'package:milestory_admin/core/core_export.dart';
import 'package:milestory_admin/features/auth/auth_export.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      body: GlobalErrorListener(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: const LoginTab(),
        ),
      ),
    );
  }
}
