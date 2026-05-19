import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../audio_export.dart';

abstract class AudioDataSource {
  Future<DataState<AudioUrlDataModel>> getAudioUrl(
      {required String audioFileId});
}

@LazySingleton(as: AudioDataSource)
class AudioDataSourceImpl implements AudioDataSource {
  final ApiClient apiClient;

  AudioDataSourceImpl(this.apiClient);

  @override
  Future<DataState<AudioUrlDataModel>> getAudioUrl(
      {required String audioFileId}) async {
    try {
      debugPrint("WYSYŁANIE ŻĄDANIA O AUDIO URL DLA audioFileId: $audioFileId");

      final response = await apiClient.request(
        url: ApiConstants.getAudioUrl,
        method: RequestMethod.get,
        queryParameters: {
          'audioFileId': audioFileId,
          'platform': ApiConstants.platform,
        },
      );

      if (response is DataSuccess) {
        final audioUrlData = AudioUrlDataModel.fromJson(response.data);
        return DataSuccess(audioUrlData);
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }
}
