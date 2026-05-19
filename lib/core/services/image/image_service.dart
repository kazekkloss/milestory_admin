import 'dart:typed_data';
import '../../core_export.dart';

abstract class ImageService {

  Future<DataState<String>> saveImage({
    required Uint8List fileImage,
    required String imageFileName,
    String? oldImageUrl,
  });

  Future<DataState> deleteImage({required String imageUrl});
}