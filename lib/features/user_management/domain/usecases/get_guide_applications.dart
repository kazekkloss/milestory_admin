import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../users_export.dart';

@lazySingleton
class GetGuideApplications {
  final UsersRepository repository;

  GetGuideApplications(this.repository);

  Future<DataState<GuideApplicationResponse>> call({int page = 1}) async {
    return await repository.getGuideApplications();
  }
}
