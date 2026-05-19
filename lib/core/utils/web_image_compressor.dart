import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

Future<Uint8List> compressImageForWeb(Uint8List bytes) async {
  final blob = web.Blob([(bytes.toJS) as JSAny].toJS);
  final url = web.URL.createObjectURL(blob);

  final imgEl = web.HTMLImageElement();
  final imgLoad = Completer<void>();
  imgEl.addEventListener('load', (() => imgLoad.complete()).toJS);
  imgEl.src = url;
  await imgLoad.future;
  web.URL.revokeObjectURL(url);

  int w = imgEl.naturalWidth;
  int h = imgEl.naturalHeight;
  const maxDim = 1280;

  if (w > maxDim || h > maxDim) {
    if (w >= h) {
      h = (h * maxDim / w).round();
      w = maxDim;
    } else {
      w = (w * maxDim / h).round();
      h = maxDim;
    }
  }

  final canvas = web.HTMLCanvasElement()
    ..width = w
    ..height = h;
  final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;
  (ctx as JSObject).callMethodVarArgs(
    'drawImage'.toJS,
    [imgEl, 0.toJS, 0.toJS, w.toJS, h.toJS],
  );

  final blobCompleter = Completer<web.Blob>();
  canvas.toBlob(
    ((web.Blob? b) => blobCompleter.complete(b!)).toJS,
    'image/jpeg',
    0.8.toJS,
  );
  final resultBlob = await blobCompleter.future;

  final reader = web.FileReader();
  final readCompleter = Completer<Uint8List>();
  reader.addEventListener('loadend', (() {
    readCompleter.complete(
      (reader.result as JSArrayBuffer).toDart.asUint8List(),
    );
  }).toJS);
  reader.readAsArrayBuffer(resultBlob);
  return readCompleter.future;
}
