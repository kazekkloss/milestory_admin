import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../repository/tour_repository.dart';

@lazySingleton
class ChangeStatus {
  final TourRepository _repository;
  ChangeStatus(this._repository);

  Future<DataState<void>> call(String tourId, TourStatus targetStatus, {String? rejectionReason, TourStatus? sourceStatus}) =>
      _repository.changeStatus(tourId, targetStatus, rejectionReason: rejectionReason, sourceStatus: sourceStatus);
}
