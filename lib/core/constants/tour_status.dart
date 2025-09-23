import 'package:flutter/material.dart';

enum TourStatus {
  private,
  public,
  verify,
  edited,
}

class TourStatusData {
  final List<String> statusStrings;
  final List<Widget> statusIcons;

  TourStatusData()
      : statusStrings = TourStatus.values.map((status) => mapStatusEnumToString(status)).toList(),
        statusIcons = TourStatus.values.map((status) => mapStatusEnumToIcon(status)).toList();

  static String mapStatusEnumToString(TourStatus status) {
    switch (status) {
      case TourStatus.private:
        return 'Prywatna';
      case TourStatus.public:
        return 'Publiczna';
      case TourStatus.verify:
        return 'Do weryfikacji';
      case TourStatus.edited:
        return 'Edytowana';
    }
  }

  static Icon mapStatusEnumToIcon(TourStatus status) {
    switch (status) {
      case TourStatus.private:
        return const Icon(Icons.lock_outline);
      case TourStatus.public:
        return const Icon(Icons.public);
      case TourStatus.verify:
        return const Icon(Icons.lock_outline);
      case TourStatus.edited:
        return const Icon(Icons.public);
    }
  }

static TourStatus fromApiString(String value) {
  switch (value) {
    case 'private':
      return TourStatus.private;
    case 'public':
      return TourStatus.public;
    case 'verify':
      return TourStatus.verify;
    case 'edited':
      return TourStatus.edited;
    default:
      return TourStatus.private;
  }
}

  static String mapStatusEnumToApiString(TourStatus status) {
    switch (status) {
      case TourStatus.private:
        return 'private';
      case TourStatus.public:
        return 'public';
      case TourStatus.verify:
        return 'verify';
      case TourStatus.edited:
        return 'edited';
    }
  }

  TourStatus getStatusFromString(String value) {
    final index = statusStrings.indexOf(value);
    return index != -1 ? TourStatus.values[index] : TourStatus.private;
  }
}
