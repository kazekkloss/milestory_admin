import 'package:flutter/material.dart';

import '../core_export.dart';

extension TourStatusColors on TourStatus {
  Color get color {
    switch (this) {
      case TourStatus.draft:
        return const Color(0xFF378ADD);
      case TourStatus.pendingReview:
        return const Color(0xFFEF9F27);
      case TourStatus.published:
        return const Color(0xFF1D9E75);
      case TourStatus.rejected:
        return const Color(0xFFE05252);
      case TourStatus.private:
        return const Color(0xFFA8A8A8);
    }
  }
}
