import 'package:injectable/injectable.dart';
import '../../../../../core/core_export.dart';
import '../../tour_managenent_export.dart';

@lazySingleton
class SetPrivateTour {
  final TourRepository repository;

  SetPrivateTour(this.repository);

  Future<DataState> call({required String tourId}) async {
    return await repository.setPrivateTour(tourId: tourId);
  }
}