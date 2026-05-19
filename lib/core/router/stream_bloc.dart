import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class RouterRefreshBloc<BLOC extends BlocBase<STATE>, STATE>
    extends ChangeNotifier {
  RouterRefreshBloc(BLOC bloc) {
    _blocStream = bloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<STATE> _blocStream;

  @override
  void dispose() {
    _blocStream.cancel();
    super.dispose();
  }
}

class RouterRefreshMultiBloc extends ChangeNotifier {
  RouterRefreshMultiBloc(List<ChangeNotifier> listenables) {
    for (final l in listenables) {
      l.addListener(notifyListeners);
    }
    _listenables = listenables;
  }

  late final List<ChangeNotifier> _listenables;

  @override
  void dispose() {
    for (final l in _listenables) {
      l.removeListener(notifyListeners);
      l.dispose();
    }
    super.dispose();
  }
}
