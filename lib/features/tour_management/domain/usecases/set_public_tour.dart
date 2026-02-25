import 'package:injectable/injectable.dart';
import '../../../../../core/core_export.dart';
import '../../tour_managenent_export.dart';

@lazySingleton
class SetPublicTour {
  final TourRepository repository;

  SetPublicTour(this.repository);

  Future<DataState> call({required String tourId}) async {
    return await repository.setPublicTour(tourId: tourId);
  }
}