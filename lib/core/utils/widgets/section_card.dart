import 'package:flutter/material.dart';
import '../../core_export.dart';

class SectionCard extends StatelessWidget {
  final String label;
  final Widget child;
  final int? trailingCount;
  final EdgeInsets padding;

  const SectionCard({
    super.key,
    required this.label,
    required this.child,
    this.trailingCount,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return AppContainer(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: ts.sectionLabel.copyWith(fontSize: 11),
                ),
              ),
              if (trailingCount != null)
                Text(
                  '$trailingCount',
                  style: ts.caption.copyWith(
                    fontSize: 11,
                    color: c.textMuted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
