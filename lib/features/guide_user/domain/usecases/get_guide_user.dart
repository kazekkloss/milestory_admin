import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/response/response.dart';
import '../../guide_user_export.dart';

@lazySingleton
class GetGuideUser {
  final GuideUserRepository repository;

  GetGuideUser(this.repository);

  Future<DataState<GuideUser>> call({required String guideUserId}) async {
    return await repository.getGuideUser(guideUserId: guideUserId);
  }
}
