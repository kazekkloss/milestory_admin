import 'package:injectable/injectable.dart';
import '../../../../core/response/response.dart';
import '../../tour_managenent_export.dart';

@lazySingleton
class DeleteTour {
  final TourRepository repository;

  DeleteTour(this.repository);

  Future<DataState> call({required String tourId}) async {
    return await repository.deleteTour(tourId: tourId);
  }
}
