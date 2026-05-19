import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/response/response.dart';
import '../../audio_export.dart';

@Singleton(as: AudioRepository)
class AudioRepositoryImpl implements AudioRepository {
  final AudioDataSource audioDataSource;

  AudioRepositoryImpl({required this.audioDataSource});

  @override
  Future<DataState<AudioUrlData>> getAudioUrl(
      {required String audioFileId}) async {
    final response = audioDataSource.getAudioUrl(audioFileId: audioFileId);
    return response;
  }
}
