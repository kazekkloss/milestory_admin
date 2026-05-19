import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../core_export.dart';

// ─────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────

ShapeBorder _dialogShape(AppColors c, {bool danger = false}) =>
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(c.radiusMd),
      side: BorderSide(
        color: danger ? c.dangerColor.withValues(alpha: 0.4) : c.borderSubtle,
        width: 0.5,
      ),
    );

Widget _dangerTitleRow(String title, AppTextStyles ts, AppColors c) => Row(
      children: [
        Icon(Icons.warning_amber_rounded, color: c.dangerColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: ts.cardTitle.copyWith(color: c.dangerColor)),
        ),
      ],
    );

TextButton _cancelBtn(
  String label,
  VoidCallback onPressed,
  AppTextStyles ts,
  AppColors c,
) =>
    TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(c.radiusSm),
        ),
      ),
      child: Text(label, style: ts.caption.copyWith(color: c.textSecondary)),
    );

// ─────────────────────────────────────────────
// Public show functions
// ─────────────────────────────────────────────

Future<void> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? warningContent,
  String confirmText = 'Potwierdź',
  String cancelText = 'Anuluj',
  bool isDestructive = false,
  VoidCallback? onConfirm,
  VoidCallback? onSecondary,
  String? secondaryText,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => PointerInterceptor(
      child: _AppDialog(
        title: title,
        content: content,
        warningContent: warningContent,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: onConfirm,
        onSecondary: onSecondary,
        secondaryText: secondaryText,
      ),
    ),
  );
}

Future<void> showCountdownConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Potwierdź',
  String cancelText = 'Anuluj',
  int countdownSeconds = 3,
  required VoidCallback onConfirm,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PointerInterceptor(
      child: _CountdownConfirmDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        countdownSeconds: countdownSeconds,
        onConfirm: onConfirm,
      ),
    ),
  );
}

// ─────────────────────────────────────────────
// Base dialog widget
// ─────────────────────────────────────────────

class _AppDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? warningContent;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final VoidCallback? onConfirm;
  final VoidCallback? onSecondary;
  final String? secondaryText;

  const _AppDialog({
    required this.title,
    required this.content,
    this.warningContent,
    required this.confirmText,
    required this.cancelText,
    required this.isDestructive,
    this.onConfirm,
    this.onSecondary,
    this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final infoOnly = onConfirm == null && onSecondary == null;

    void close() => Navigator.of(context).pop();

    return AlertDialog(
      backgroundColor: c.bgCard,
      shape: _dialogShape(c, danger: isDestructive),
      title: isDestructive
          ? _dangerTitleRow(title, ts, c)
          : Text(title, style: ts.cardTitle),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content, style: ts.caption.copyWith(fontSize: 13, height: 1.6)),
            if (warningContent != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: SemanticColors.warningBg,
                  borderRadius: BorderRadius.circular(c.radiusSm),
                  border: Border.all(
                    color: SemanticColors.warning.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 15, color: SemanticColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        warningContent!,
                        style: ts.caption.copyWith(
                          fontSize: 12,
                          color: SemanticColors.warning,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: _buildActions(c, ts, infoOnly, close),
    );
  }

  List<Widget> _buildActions(
    AppColors c,
    AppTextStyles ts,
    bool infoOnly,
    VoidCallback close,
  ) {
    TextButton confirmBtn(String label, VoidCallback onTap, Color bg,
            {bool whiteText = false}) =>
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: whiteText ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(c.radiusSm),
            ),
          ),
          child: Text(
            label,
            style: ts.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: whiteText ? Colors.white : Colors.black,
            ),
          ),
        );

    if (infoOnly) {
      return [SizedBox(width: 130, child: _cancelBtn(confirmText, close, ts, c))];
    }

    if (onConfirm == null && onSecondary != null) {
      return [
        SizedBox(width: 130, child: _cancelBtn(cancelText, close, ts, c)),
        SizedBox(
          width: 130,
          child: confirmBtn(secondaryText ?? 'OK', () { close(); onSecondary!(); }, c.accent),
        ),
      ];
    }

    return [
      SizedBox(width: 130, child: _cancelBtn(cancelText, close, ts, c)),
      SizedBox(
        width: 130,
        child: confirmBtn(
          confirmText,
          () { close(); onConfirm!(); },
          isDestructive ? c.dangerColor : c.accent,
          whiteText: isDestructive,
        ),
      ),
    ];
  }
}

// ─────────────────────────────────────────────
// Countdown confirm dialog
// ─────────────────────────────────────────────

class _CountdownConfirmDialog extends StatefulWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final int countdownSeconds;
  final VoidCallback onConfirm;

  const _CountdownConfirmDialog({
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.countdownSeconds,
    required this.onConfirm,
  });

  @override
  State<_CountdownConfirmDialog> createState() =>
      _CountdownConfirmDialogState();
}

class _CountdownConfirmDialogState extends State<_CountdownConfirmDialog> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.countdownSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        if (mounted) setState(() => _secondsLeft = 0);
      } else {
        if (mounted) setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ts = AppTextStyles.of(context);
    final canConfirm = _secondsLeft == 0;
    final total = widget.countdownSeconds;

    return AlertDialog(
      backgroundColor: c.bgCard,
      shape: _dialogShape(c, danger: true),
      title: _dangerTitleRow(widget.title, ts, c),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.content,
              style: ts.caption.copyWith(fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 24,
              child: !canConfirm
                  ? Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            value: (total - _secondsLeft) / total,
                            strokeWidth: 2,
                            color: c.dangerColor,
                            backgroundColor:
                                c.dangerColor.withValues(alpha: 0.2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Potwierdź za $_secondsLeft s...',
                          style: ts.caption
                              .copyWith(color: c.textMuted, fontSize: 13),
                        ),
                      ],
                    )
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: 80,
          child: _cancelBtn(
            widget.cancelText,
            () => Navigator.of(context).pop(),
            ts,
            c,
          ),
        ),
        SizedBox(
          width: 130,
          child: TextButton(
            onPressed: canConfirm
                ? () {
                    Navigator.of(context).pop();
                    widget.onConfirm();
                  }
                : null,
            style: TextButton.styleFrom(
              backgroundColor: canConfirm
                  ? c.dangerColor
                  : c.dangerColor.withValues(alpha: 0.3),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(c.radiusSm),
              ),
            ),
            child: Text(
              canConfirm
                  ? widget.confirmText
                  : '${widget.confirmText} ($_secondsLeft)',
              style: ts.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: canConfirm
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Concrete dialogs
// ─────────────────────────────────────────────

Future<void> showSlotOccupiedDialog(
  BuildContext context,
  String? blockingStatus, {
  VoidCallback? onSeeRejection,
}) {
  switch (blockingStatus) {
    case 'rejected':
      return showAppConfirmDialog(
        context: context,
        title: 'Masz odrzuconą trasę',
        content: 'Popraw ją i wyślij ponownie albo usuń, zanim zaczniesz nową.',
        confirmText: 'Rozumiem',
        cancelText: 'Anuluj',
        onSecondary: onSeeRejection,
        secondaryText: 'Zobacz uwagi',
      );
    case 'pending_review':
      return showAppConfirmDialog(
        context: context,
        title: 'Twoja trasa jest w weryfikacji',
        content:
            'Zaczekaj na decyzję, zanim utworzysz kolejną. Zazwyczaj trwa to 1–3 dni robocze.',
        confirmText: 'Rozumiem',
      );
    default: // 'draft'
      return showAppConfirmDialog(
        context: context,
        title: 'Masz już szkic w tworzeniu',
        content:
            'Możesz pracować tylko nad jedną trasą naraz. Dokończ aktualny szkic albo usuń go, zanim zaczniesz nowy.',
        confirmText: 'Rozumiem',
      );
  }
}

