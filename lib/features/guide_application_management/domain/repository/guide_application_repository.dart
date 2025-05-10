import '../../../../core/core_export.dart';
import '../../guide_application_export.dart';

abstract class GuideApplicationRepository {
  Future<DataState<GuideApplicationResponse>> getGuideApplications({int page});
  Future<DataState> deleteGuideApplication({required String guideApplicationId});
}
