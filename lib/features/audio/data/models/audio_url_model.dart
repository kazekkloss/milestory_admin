import '../../audio_export.dart';

class AudioUrlDataModel extends AudioUrlData {
  const AudioUrlDataModel({
    required super.audioUrl,
    required super.duration,
  });

  factory AudioUrlDataModel.fromJson(Map<String, dynamic> json) {
    return AudioUrlDataModel(
      audioUrl: json['audioUrl'] as String,
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audioUrl': audioUrl,
      'duration': duration,
    };
  }

  static AudioUrlData toEntity(AudioUrlDataModel audioUrlDataModel) {
    return AudioUrlDataModel(
      audioUrl: audioUrlDataModel.audioUrl,
      duration: audioUrlDataModel.duration,
    );
  }
}
