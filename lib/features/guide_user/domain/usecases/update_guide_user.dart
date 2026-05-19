import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../guide_user_export.dart';

@lazySingleton
class UpdateGuideUser {
  final GuideUserRepository repository;
  final ImageService imageService;

  UpdateGuideUser(this.repository, this.imageService);

  Future<DataState<GuideUser>> call({
    required GuideUser guideUser,
    String? deleteAvatarUrl,
  }) async {
    try {
      String? avatarUrl = guideUser.avatarUrl;

      if (deleteAvatarUrl != null && deleteAvatarUrl.isNotEmpty) {
        await imageService.deleteImage(imageUrl: deleteAvatarUrl);
        avatarUrl = null;
      }

      if (guideUser.avatarBytes != null && guideUser.avatarFileName != null) {
        final uploadResponse = await imageService.saveImage(
          fileImage: guideUser.avatarBytes!,
          imageFileName: guideUser.avatarFileName!,
          oldImageUrl: guideUser.avatarUrl,
        );
        if (uploadResponse is DataSuccess) {
          avatarUrl = uploadResponse.data;
        } else {
          return DataFailed(uploadResponse.uiEvent!);
        }
      }

      final prepared = guideUser.copyWith(
        avatarUrl: avatarUrl,
        avatarBytes: null,
        avatarFileName: null,
      );

      final saveResponse =
          await repository.updateGuideUser(guideUser: prepared);

      if (saveResponse is DataSuccess) {
        return DataSuccess(prepared);
      } else {
        return DataFailed(saveResponse.uiEvent!);
      }
    } catch (e) {
      return DataFailed(
          UiEvent(isError: true, message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
