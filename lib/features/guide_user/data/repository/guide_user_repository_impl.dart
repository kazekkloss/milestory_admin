import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/response/response.dart';
import '../../guide_user_export.dart';

@LazySingleton(as: GuideUserRepository)
class GuideUserRepositoryImpl implements GuideUserRepository {
  final GuideUserDataSource guideUserDataSource;

  GuideUserRepositoryImpl({required this.guideUserDataSource});

  @override
  Future<DataState<GuideUser>> getGuideUser(
      {required String guideUserId}) async {
    final response =
        await guideUserDataSource.getGuideUser(guideUserId: guideUserId);
    return response;
  }

  @override
  Future<DataState> updateGuideUser({required GuideUser guideUser}) async {
    GuideUserModel userModel = GuideUserModel.toModel(guideUser);
    final response =
        await guideUserDataSource.updateGuideUser(guideUser: userModel);
    return response;
  }

  @override
  Future<DataState> markOnboardingSeen({required String guideUserId}) async {
    return await guideUserDataSource.markOnboardingSeen(
        guideUserId: guideUserId);
  }
}
