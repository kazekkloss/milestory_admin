part of 'audio_bloc.dart';

sealed class AudioEvent extends Equatable {
  const AudioEvent();
  @override
  List<Object?> get props => [];
}

class ResolveAudioSource extends AudioEvent {
  final Uint8List? bytes;
  final String? fileId;

  const ResolveAudioSource({
    this.bytes,
    this.fileId,
  });

  @override
  List<Object?> get props => [bytes, fileId];
}