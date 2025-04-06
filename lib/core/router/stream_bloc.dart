// Class to convert bloc stream for refreshListenable -----------------

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class RouterRefreshBloc<BLOC extends BlocBase<STATE>, STATE> extends ChangeNotifier {
  RouterRefreshBloc(BLOC bloc) {
    _blocStream = bloc.stream.listen(
      (STATE _) => notifyListeners(),
    );
  }

  late final StreamSubscription<STATE> _blocStream;

  @override
  void dispose() {
    _blocStream.cancel();
    super.dispose();
  }
}
