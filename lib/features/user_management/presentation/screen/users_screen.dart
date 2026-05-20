import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:milestory_admin/core/core_export.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.users, size: 32, color: c.textMuted),
            const SizedBox(height: 16),
            Text('Zarządzanie użytkownikami', style: ts.sectionTitle.copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            Text('Ekran w budowie', style: ts.caption.copyWith(color: c.textMuted)),
          ],
        ),
      ),
    );
  }
}
