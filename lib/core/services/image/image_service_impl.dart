import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import '../../core_export.dart';

@LazySingleton(as: ImageService)
class ImageServiceImpl implements ImageService {
  final ApiClient apiClient;

  ImageServiceImpl(this.apiClient);

  @override
  Future<DataState<String>> saveImage({
    required Uint8List fileImage,
    required String imageFileName,
    String? oldImageUrl,
  }) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.saveImage,
        method: RequestMethod.streamTo,
        fileData: fileImage,
        fileName: imageFileName,
        data: {'imageUrl': oldImageUrl},
      );

      if (response is DataSuccess) {
        final String imageUrl = response.data['imageUrl'];
        return DataSuccess(imageUrl);
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(
          UiEvent(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<DataState> deleteImage({required String imageUrl}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.deleteImage,
        method: RequestMethod.delete,
        data: {'imageUrl': imageUrl},
      );

      if (response is DataSuccess) {
        return DataSuccess(response);
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(
          UiEvent(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}