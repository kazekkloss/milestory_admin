import 'dart:async';
import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../audio_export.dart';

@injectable
class GetAudioUrl {
  final AudioRepository repository;

  GetAudioUrl(this.repository);

  Future<DataState<AudioUrlData>> call({required String audioFileId}) async {
    return await repository.getAudioUrl(audioFileId: audioFileId);
  }
}
