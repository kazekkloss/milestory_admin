import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final String descriptionText;
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool? obscureText;
  final Widget? suffixIcon;
  const AppTextFormField({
    super.key,
    required this.descriptionText,
    this.validator,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(descriptionText, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 3),
            TextFormField(
              focusNode: focusNode,
              style: Theme.of(context).textTheme.bodySmall,
              controller: controller,
              validator: validator,
              obscureText: obscureText!,
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                hintText: hintText,
              ),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
