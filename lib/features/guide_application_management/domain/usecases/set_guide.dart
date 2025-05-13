import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../guide_application_export.dart';

@lazySingleton
class SetGuide {
  final GuideApplicationRepository repository;

  SetGuide(this.repository);

  Future<DataState> call({required String guideApplicationId}) async {
    return await repository.setGuideApplication(guideApplicationId: guideApplicationId);
  }
}
