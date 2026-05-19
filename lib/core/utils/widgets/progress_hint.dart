import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core_export.dart';

class ProgressHint extends StatelessWidget {
  final int filled;
  final int total;
  final String hint;
  const ProgressHint({
    super.key,
    required this.filled,
    required this.total,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final isDone = filled == total;
    final Color accent = isDone ? SemanticColors.success : SemanticColors.info;

    return Row(
      children: [
        FaIcon(
          isDone ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.lightbulb,
          size: 12,
          color: accent,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            hint,
            style: ts.caption.copyWith(fontSize: 12, color: c.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: accent.withAlpha(12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$filled/$total',
            style: ts.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
        ),
      ],
    );
  }
}
