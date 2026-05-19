import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

Future<int?> getAudioDurationSeconds(Uint8List bytes) async {
  String? url;
  web.HTMLAudioElement? audio;
  StreamSubscription? metaSub;
  StreamSubscription? errorSub;

  debugPrint('[getAudioDurationSeconds] starting, bytes=${bytes.length}');
  try {
    final blob = web.Blob([(bytes.toJS) as JSAny].toJS);
    url = web.URL.createObjectURL(blob);

    audio = web.HTMLAudioElement();
    audio.preload = 'metadata';
    web.document.body?.append(audio);

    final completer = Completer<double>();

    metaSub = audio.onLoadedMetadata.listen((_) {
      debugPrint('[getAudioDurationSeconds] onLoadedMetadata: duration=${audio!.duration}');
      if (!completer.isCompleted) completer.complete(audio.duration);
    });

    errorSub = audio.onError.listen((_) {
      debugPrint('[getAudioDurationSeconds] onError fired');
      if (!completer.isCompleted) completer.completeError('audio error');
    });

    audio.src = url;
    debugPrint('[getAudioDurationSeconds] src set, waiting for metadata...');

    final rawDuration = await completer.future.timeout(
      const Duration(seconds: 10),
    );

    debugPrint('[getAudioDurationSeconds] rawDuration=$rawDuration');

    if (rawDuration.isNaN || rawDuration.isInfinite || rawDuration <= 0) {
      debugPrint('[getAudioDurationSeconds] invalid duration → returning null');
      return null;
    }

    final result = rawDuration.ceil();
    debugPrint('[getAudioDurationSeconds] returning $result');
    return result;
  } catch (e) {
    debugPrint('[getAudioDurationSeconds] CAUGHT: $e → returning null');
    return null;
  } finally {
    metaSub?.cancel();
    errorSub?.cancel();
    audio?.remove();
    if (url != null) web.URL.revokeObjectURL(url);
  }
}
