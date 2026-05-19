import 'package:flutter/material.dart';

enum TourStatus {
  draft,
  pendingReview,
  published,
  rejected,
  private,
}

class TourStatusData {
  final List<String> statusStrings;
  final List<Widget> statusIcons;

  TourStatusData()
      : statusStrings = TourStatus.values
            .map((status) => mapStatusEnumToString(status))
            .toList(),
        statusIcons = TourStatus.values
            .map((status) => mapStatusEnumToIcon(status))
            .toList();

  static String mapStatusEnumToString(TourStatus status) {
    switch (status) {
      case TourStatus.draft:
        return 'Szkic';
      case TourStatus.pendingReview:
        return 'Weryfikacja';
      case TourStatus.published:
        return 'Publiczna';
      case TourStatus.rejected:
        return 'Odrzucona';
      case TourStatus.private:
        return 'Prywatna';
    }
  }

  static Icon mapStatusEnumToIcon(TourStatus status) {
    switch (status) {
      case TourStatus.draft:
        return const Icon(Icons.edit_outlined);
      case TourStatus.pendingReview:
        return const Icon(Icons.hourglass_empty);
      case TourStatus.published:
        return const Icon(Icons.public);
      case TourStatus.rejected:
        return const Icon(Icons.cancel_outlined);
      case TourStatus.private:
        return const Icon(Icons.lock_outline);
    }
  }

  static TourStatus fromApiString(String value) {
    switch (value) {
      case 'draft':
        return TourStatus.draft;
      case 'pending_review':
        return TourStatus.pendingReview;
      case 'published':
        return TourStatus.published;
      case 'rejected':
        return TourStatus.rejected;
      case 'private':
        return TourStatus.private;
      default:
        return TourStatus.draft;
    }
  }

  static String mapStatusEnumToApiString(TourStatus status) {
    switch (status) {
      case TourStatus.draft:
        return 'draft';
      case TourStatus.pendingReview:
        return 'pending_review';
      case TourStatus.published:
        return 'published';
      case TourStatus.rejected:
        return 'rejected';
      case TourStatus.private:
        return 'private';
    }
  }

  TourStatus getStatusFromString(String value) {
    final index = statusStrings.indexOf(value);
    return index != -1 ? TourStatus.values[index] : TourStatus.draft;
  }
}
