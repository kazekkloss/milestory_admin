import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../guide_application_export.dart';

@lazySingleton
class DeleteGuideApplication {
  final GuideApplicationRepository repository;

  DeleteGuideApplication(this.repository);

  Future<DataState> call({required String guideApplicationId}) async {
    return await repository.deleteGuideApplication(guideApplicationId: guideApplicationId);
  }
}
