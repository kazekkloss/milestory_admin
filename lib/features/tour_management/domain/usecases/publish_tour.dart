import 'package:injectable/injectable.dart';
import '../../../../../core/core_export.dart';
import '../../tour_managenent_export.dart';

@lazySingleton
class PublishTour {
  final TourRepository repository;

  PublishTour(this.repository);

  Future<DataState> call({required String tourId}) async {
    return await repository.publishTour(tourId: tourId);
  }
}