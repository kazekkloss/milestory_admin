import '../constants/tour_status.dart';

String slotBlockedHint(TourStatus status) {
  switch (status) {
    case TourStatus.draft:
      return 'Masz aktywny szkic. Dokończ go lub usuń, zanim zaczniesz nową trasę.';
    case TourStatus.pendingReview:
      return 'Twoja trasa jest w weryfikacji. Zaczekaj na decyzję, zanim utworzysz kolejną.';
    case TourStatus.rejected:
      return 'Masz odrzuconą trasę. Popraw ją albo usuń, zanim zaczniesz nową.';
    default:
      return 'Masz aktywną trasę. Dokończ ją lub usuń przed dodaniem nowej.';
  }
}

String slotBlockedSubtitle(TourStatus status, String title) {
  switch (status) {
    case TourStatus.draft:
      return 'Masz aktywny szkic: $title';
    case TourStatus.pendingReview:
      return 'Trasa w weryfikacji: $title';
    case TourStatus.rejected:
      return 'Trasa odrzucona: $title';
    default:
      return 'Aktywna trasa: $title';
  }
}
