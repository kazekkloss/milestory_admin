import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../guide_application_export.dart';

@LazySingleton(as: GuideApplicationRepository)
class GuideApplicationRepositoryImpl implements GuideApplicationRepository {
  final GuideApplicationDataSource guideApplicationDataSource;

  GuideApplicationRepositoryImpl({required this.guideApplicationDataSource});

  @override
  Future<DataState<GuideApplicationResponse>> getGuideApplications({int page = 1}) async {
    final response = await guideApplicationDataSource.getGuideApplications(page: page);
    if (response is DataSuccess) {
      GuideApplicationResponse guideApplicationResponse = GuideApplicationResponseModel.toEntity(response.data!);
      return DataSuccess(guideApplicationResponse);
    } else {
      return response;
    }
  }
  
  @override
  Future<DataState> deleteGuideApplication({required String guideApplicationId}) async {
    return await guideApplicationDataSource.deleteGuideApplication(guideApplicationId: guideApplicationId);
  }

    @override
  Future<DataState> setGuideApplication({required String guideApplicationId}) async {
    return await guideApplicationDataSource.setGuideApplication(guideApplicationId: guideApplicationId);
  }
}
