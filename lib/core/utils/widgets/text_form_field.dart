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
  final int? maxLength; // Nowy parametr dla ograniczenia liczby znaków
  final int? maxLines;
  final double? maxWidth; // Nowy parametr dla liczby linii

  const AppTextFormField(
      {super.key,
      required this.descriptionText,
      this.validator,
      this.controller,
      this.hintText,
      this.obscureText = false,
      this.suffixIcon,
      this.onChanged,
      this.focusNode,
      this.maxLength,
      this.maxLines = 1, // Domyślnie jedna linia
      this.maxWidth = 320});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines != null && maxLines! > 1 ? null  : 90, // Dynamiczna wysokość dla wielu linii
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
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
              maxLength: maxLength, // Ograniczenie liczby znaków
              maxLines: maxLines, // Liczba linii
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                hintText: hintText,
                counterText: maxLength != null ? '' : null, // Opcjonalne ukrycie licznika znaków
              ),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
