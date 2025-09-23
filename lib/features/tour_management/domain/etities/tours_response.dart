import '../../../../../core/core_export.dart';
import '../../tour_managenent_export.dart';

class ToursResponse {
  final List<Tour> tours;
  final ToursStats stats;

  const ToursResponse({
    required this.tours,
    required this.stats,
  });

  ToursResponse copyWith({
    List<Tour>? tours,
    ToursStats? stats,
  }) {
    return ToursResponse(
      tours: tours ?? this.tours,
      stats: stats ?? this.stats,
    );
  }

  static const empty = ToursResponse(
    tours: [],
    stats: ToursStats.empty,
  );
}
