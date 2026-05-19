import '../core_export.dart';

abstract class DataState<T> {
  final T? data;
  final UiEvent? uiEvent;

  const DataState({this.data, this.uiEvent});

  bool? get isEmpty => null;
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess([T? data]) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(UiEvent uiEvent) : super(uiEvent: uiEvent);
}
