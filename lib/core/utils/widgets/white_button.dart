import 'package:flutter/material.dart';

import '../../core_export.dart';

class WhiteButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final double? paddingRight;
  final bool? isLoading;

  const WhiteButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.paddingRight = 15,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading == true ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(
          left: 10,
          right: paddingRight!,
        ),
        backgroundColor: Colors.white,
        disabledBackgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: SizedBox(
        height: 41,
        child: Center(
          child: isLoading == true
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(CustomColorScheme.customColorScheme.primary),
                  ),
                )
              : child,
        ),
      ),
    );
  }
}
