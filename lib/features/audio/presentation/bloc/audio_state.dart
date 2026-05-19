part of 'audio_bloc.dart';

enum AudioSourceStatus { initial, loading, ready, error }

class AudioState extends Equatable {
  final AudioSourceStatus status;
  final Uri? sourceUri; 
  final String? errorMessage;
  final UiEvent? uiEvent;

  const AudioState({
    this.status = AudioSourceStatus.initial,
    this.sourceUri,
    this.errorMessage,
    this.uiEvent,
  });

  AudioState copyWith({
    AudioSourceStatus? status,
    Uri? sourceUri,
    String? errorMessage,
    UiEvent? uiEvent,
  }) {
    return AudioState(
      status: status ?? this.status,
      sourceUri: sourceUri ?? this.sourceUri,
      errorMessage: errorMessage ?? this.errorMessage,
      uiEvent: uiEvent ?? this.uiEvent,
    );
  }

  @override
  List<Object?> get props => [status, sourceUri, errorMessage, uiEvent];
}
