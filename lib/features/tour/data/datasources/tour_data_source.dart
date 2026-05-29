import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../tour_export.dart';

abstract class TourDataSource {
  Future<DataState<ToursResponse>> getTours({int page, int limit, String? tourStatus, String? userId, String? title});
  Future<DataState<void>> changeStatus(String tourId, TourStatus targetStatus, {String? rejectionReason, TourStatus? sourceStatus});
}

@LazySingleton(as: TourDataSource)
class TourDataSourceImpl implements TourDataSource {
  final ApiClient apiClient;
  TourDataSourceImpl(this.apiClient);

  @override
  Future<DataState<ToursResponse>> getTours(
      {int page = 1, int limit = 20, String? tourStatus, String? userId, String? title}) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final String url;
      if (title != null && title.isNotEmpty) {
        queryParams['title'] = title;
        queryParams['platform'] = ApiConstants.platform;
        url = ApiConstants.getToursByTitle;
      } else if (userId != null && userId.isNotEmpty) {
        queryParams['userId'] = userId;
        if (tourStatus != null) queryParams['tourStatus'] = tourStatus;
        url = ApiConstants.getToursByAuthorId;
      } else {
        if (tourStatus != null) queryParams['tourStatus'] = tourStatus;
        url = ApiConstants.getAllTours;
      }

      final response = await apiClient.request(
        url: url,
        method: RequestMethod.get,
        queryParameters: queryParams,
      );
      if (response is DataSuccess) {
        final data = response.data;
        final parsed = data is List
            ? ToursResponseModel.fromList(data)
            : ToursResponseModel.fromJson(data as Map<String, dynamic>);
        return DataSuccess(parsed);
      }
      return DataFailed(response.uiEvent!);
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }

  @override
  Future<DataState<void>> changeStatus(String tourId, TourStatus targetStatus, {String? rejectionReason, TourStatus? sourceStatus}) async {
    try {
      final action = _actionFor(targetStatus, sourceStatus);
      final url = '${ApiConstants.tourBase}/$tourId/$action';
      final data = targetStatus == TourStatus.rejected && rejectionReason != null
          ? {'reason': rejectionReason}
          : null;
      final response = await apiClient.request(
        url: url,
        method: RequestMethod.post,
        data: data,
      );
      if (response is DataSuccess) return const DataSuccess(null);
      return DataFailed(response.uiEvent!);
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }

  String _actionFor(TourStatus target, TourStatus? source) {
    switch (target) {
      case TourStatus.draft:         return 'cancel-review';
      case TourStatus.pendingReview: return 'submit-for-review';
      case TourStatus.published:     return source == TourStatus.private ? 'set-public' : 'approve';
      case TourStatus.private:       return 'set-private';
      case TourStatus.rejected:      return 'reject';
    }
  }
}
