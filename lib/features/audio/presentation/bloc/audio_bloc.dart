import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../audio_export.dart';

part 'audio_event.dart';
part 'audio_state.dart';

@injectable
class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final GetAudioUrl _getAudioUrl;

  AudioBloc({required GetAudioUrl getAudioUrl})
      : _getAudioUrl = getAudioUrl,
        super(const AudioState()) {
    on<ResolveAudioSource>(_onResolve);
  }

  Future<void> _onResolve(
    ResolveAudioSource event,
    Emitter<AudioState> emit,
  ) async {
    emit(state.copyWith(status: AudioSourceStatus.loading));

    try {
      if (event.bytes != null && event.bytes!.isNotEmpty) {
        final uri = Uri.dataFromBytes(
          event.bytes!,
          mimeType: 'audio/mpeg',
        );
        emit(state.copyWith(
          status: AudioSourceStatus.ready,
          sourceUri: uri,
        ));
      } else if (event.fileId != null && event.fileId!.isNotEmpty) {
        final response = await _getAudioUrl(audioFileId: event.fileId!);

        if (response is DataSuccess) {
          emit(state.copyWith(
            status: AudioSourceStatus.ready,
            sourceUri: Uri.parse(response.data!.audioUrl),
          ));
        } else {
          emit(state.copyWith(
            status: AudioSourceStatus.error,
            errorMessage: response.uiEvent?.message ?? 'Nieznany błąd',
            uiEvent: response.uiEvent,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        status: AudioSourceStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
