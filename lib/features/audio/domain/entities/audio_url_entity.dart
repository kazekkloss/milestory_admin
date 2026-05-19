import 'package:equatable/equatable.dart';

class AudioUrlData extends Equatable {
  final String audioUrl;
  final int duration;

  const AudioUrlData({
    required this.audioUrl,
    required this.duration,
  });

  @override
  List<Object?> get props => throw [audioUrl, duration];
}
