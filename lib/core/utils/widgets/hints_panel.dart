import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core_export.dart';

class HintItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String text;

  const HintItem(
      {required this.icon,
      required this.iconColor,
      required this.iconBg,
      required this.title,
      required this.text});
}

class HintsPanel extends StatelessWidget {
  final String label;
  final VoidCallback? onClose;
  final List<HintItem> items;

  const HintsPanel({
    super.key,
    this.label = 'WSKAZÓWKI',
    this.onClose,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final ts = AppTextStyles.of(context);
    final c = AppColors.of(context);

    return AppContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: ts.sectionLabel.copyWith(fontSize: 11)),
              const Spacer(),
              onClose == null
                  ? const SizedBox.shrink()
                  : IconActionButton(
                      icon: FontAwesomeIcons.xmark,
                      radius: 100,
                      size: 22,
                      iconSize: 12,
                      color: c.textSecondary,
                      tooltip: "Zamknij",
                      onTap: onClose),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < items.length; i++) ...[
            _HintRow(item: items[i], isLast: i == items.length - 1),
            if (i < items.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  final HintItem item;
  final bool isLast;

  const _HintRow({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(item.icon, size: 11, color: item.iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: ts.cardTitle.copyWith(fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(item.text, style: ts.caption.copyWith(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              color: c.borderSubtle.withValues(alpha: 0.5),
              height: 0.5,
              thickness: 0.5,
            ),
          ),
      ],
    );
  }
}
