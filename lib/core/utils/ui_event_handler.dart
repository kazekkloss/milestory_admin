import 'package:flutter/material.dart';

import '../core_export.dart';

void handleUiEvent(BuildContext context, UiEvent event) {
  if (!event.isError) return;

  switch (event.code) {
    case 'SLOT_OCCUPIED':
      showSlotOccupiedDialog(context, event.blockingStatus);
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(event.message, textAlign: TextAlign.center)),
      );
  }
}
