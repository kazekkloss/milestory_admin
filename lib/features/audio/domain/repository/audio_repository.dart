import '../../../../core/core_export.dart';
import '../../audio_export.dart';

abstract class AudioRepository {
  Future<DataState<AudioUrlData>> getAudioUrl({required String audioFileId});
}
