import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../guide_application_export.dart';


@lazySingleton
class GetGuideApplications {
  final GuideApplicationRepository repository;

  GetGuideApplications(this.repository);

  Future<DataState<GuideApplicationResponse>> call({int page = 1}) async {
    return await repository.getGuideApplications(page: page);
  }
}
