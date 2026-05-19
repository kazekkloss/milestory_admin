class ProgressField {
  final bool filled;
  final String hint;
  const ProgressField({required this.filled, required this.hint});
}

typedef ProgressResult = ({int filled, int total, String nextHint});

ProgressResult calculateFormProgress({
  required List<ProgressField> fields,
  required String doneHint,
  String? doneHintOptional,
  bool hasOptional = true,
}) {
  final filled = fields.where((f) => f.filled).length;
  final total = fields.length;

  final nextField = fields.firstWhere(
    (f) => !f.filled,
    orElse: () => ProgressField(
      filled: true,
      hint: (doneHintOptional != null && !hasOptional)
          ? doneHintOptional
          : doneHint,
    ),
  );

  return (filled: filled, total: total, nextHint: nextField.hint);
}