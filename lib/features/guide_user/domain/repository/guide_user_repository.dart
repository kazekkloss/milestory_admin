import 'package:milestory_admin/core/response/response.dart';

import '../../guide_user_export.dart';

abstract class GuideUserRepository {
  Future<DataState<GuideUser>> getGuideUser({required String guideUserId});
  Future<DataState> updateGuideUser({required GuideUser guideUser});
  Future<DataState> markOnboardingSeen({required String guideUserId});
}
