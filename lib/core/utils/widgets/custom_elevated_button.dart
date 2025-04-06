import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final bool isLoading;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 0)),
      onPressed: isLoading ? null : onPressed,
      child: SizedBox(
        width: 110,
        height: 41,
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : Text(text),
        ),
      ),
    );
  }
}
