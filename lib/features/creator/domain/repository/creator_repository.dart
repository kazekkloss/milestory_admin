import '../../../../core/response/response.dart';
import '../../creator_export.dart';

abstract class CreatorRepository {
  Future<DataState<List<TourPoint>>> getTourPoints({required String tourId});
}
