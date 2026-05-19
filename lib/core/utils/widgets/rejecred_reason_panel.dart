import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core_export.dart';

class RejectedReasonPanel extends StatelessWidget {
  final String rejectionReason;
  final VoidCallback? onClose;
  const RejectedReasonPanel(
      {super.key, required this.rejectionReason, this.onClose});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    return AppContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Row(
                children: [
                  Text('UWAGA DO POPRAWY',
                      style: ts.sectionLabel.copyWith(fontSize: 11)),
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
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A0A0A),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    size: 11,
                    color: SemanticColors.danger,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rejectionReason,
                            style: ts.cardTitle.copyWith(fontSize: 13)),
                        const SizedBox(height: 2),
                        Text("Popraw uwagi i wyślij ponownie do weryfikacji.",
                            style: ts.caption.copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
