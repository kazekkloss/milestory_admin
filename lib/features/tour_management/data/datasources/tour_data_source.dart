import 'dart:async';

import 'package:injectable/injectable.dart';
import '../../../../../core/core_export.dart';
import '../../tour_managenent_export.dart';

abstract class TourDataSource {
  Future<DataState<ToursResponse>> getTours({int page, required String userId, String? tourStatus});
  Future<DataState> deleteTour({required String tourId});
  Future<DataState> deleteImage({required String imageUrl});
  Future<DataState> setPublicTour({required String tourId});
  Future<DataState> setPrivateTour({required String tourId});
}

@LazySingleton(as: TourDataSource)
class TourDataSourceImpl implements TourDataSource {
  final ApiClient apiClient;

  TourDataSourceImpl(this.apiClient);

  @override
  Future<DataState<ToursResponse>> getTours({required String userId, int page = 1, String? tourStatus}) async {
    try {
      final queryParams = {'page': page.toString(), 'userId': userId.toString(), if (tourStatus != null) 'tourStatus': tourStatus};

      final response = await apiClient.request(url: ApiConstants.getAllTours, method: RequestMethod.get, queryParameters: queryParams);

      if (response is DataSuccess) {
        final toursResponseModel = ToursResponseModel.fromJson(response.data);
        return DataSuccess(toursResponseModel);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<DataState> deleteTour({required String tourId}) async {
    try {
      final response = await apiClient.request(url: ApiConstants.deleteTour, method: RequestMethod.delete, data: {'tourId': tourId});
      if (response is DataSuccess) {
        return DataSuccess(response);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<DataState> deleteImage({required String imageUrl}) async {
    try {
      final response = await apiClient.request(url: ApiConstants.deleteImage, method: RequestMethod.delete, data: {'imageUrl': imageUrl});
      if (response is DataSuccess) {
        return DataSuccess(response);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<DataState> setPublicTour({required String tourId}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.changeStatusTour,
        method: RequestMethod.post,
        data: {'tourId': tourId, 'status': 'public'},
      );

      if (response is DataSuccess) {
        return DataSuccess(response);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<DataState> setPrivateTour({required String tourId}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.changeStatusTour,
        method: RequestMethod.post,
        data: {'tourId': tourId, 'status': 'private'},
      );

      if (response is DataSuccess) {
        return DataSuccess(response);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
