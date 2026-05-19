import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/colors.dart';

class RegulationsWidget extends StatefulWidget {
  final bool isChecked;
  final bool isError;
  final ValueChanged<bool?> onCheckboxChanged;
  const RegulationsWidget({
    super.key,
    required this.isChecked,
    required this.isError,
    required this.onCheckboxChanged,
  });

  @override
  State<RegulationsWidget> createState() => _RegulationsWidgetState();
}

class _RegulationsWidgetState extends State<RegulationsWidget> {
  late final TapGestureRecognizer _regulaminRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _regulaminRecognizer = TapGestureRecognizer()
      ..onTap = () =>
          launchUrl(Uri.parse('https://milestory.pl/regulations_creator.html'));
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => launchUrl(
          Uri.parse('https://milestory.pl/privacy_policy_creator.html'));
  }

  @override
  void dispose() {
    _regulaminRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final baseStyle = TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 11.5,
      fontWeight: FontWeight.w300,
      color: c.textSecondary,
      height: 1.5,
    );
    final linkStyle = baseStyle.copyWith(
      color: c.accent,
      decoration: TextDecoration.underline,
      decorationColor: c.accent,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: widget.isChecked,
            onChanged: widget.onCheckboxChanged,
            activeColor: c.accent,
            checkColor: c.bg,
            side: BorderSide(
                color: widget.isError ? c.error : c.textMuted, width: 1.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text.rich(TextSpan(style: baseStyle, children: [
                  const TextSpan(text: 'Wyrażam zgodę na '),
                  TextSpan(
                      text: 'Regulamin',
                      style: linkStyle,
                      recognizer: _regulaminRecognizer),
                  const TextSpan(text: ' oraz '),
                  TextSpan(
                      text: 'Politykę prywatności',
                      style: linkStyle,
                      recognizer: _privacyRecognizer),
                ])),
              ),
              SizedBox(
                height: 18,
                child: widget.isError
                    ? Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text('Wymagana zgoda',
                            style: TextStyle(
                                fontFamily: AppColors.fontBody,
                                fontSize: 11,
                                color: c.error)))
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
