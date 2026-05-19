import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/response/response.dart';
import '../../guide_user_export.dart';

@lazySingleton
class MarkOnboardingSeen {
  final GuideUserRepository repository;
  MarkOnboardingSeen(this.repository);

  Future<DataState> call({required String guideUserId}) =>
      repository.markOnboardingSeen(guideUserId: guideUserId);
}
