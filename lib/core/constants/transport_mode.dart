import 'package:flutter/material.dart';

enum TransportMode {
  none,
  car,
  train,
  publicTransport,
  bike,
  walk,
}

String mapRouteEnumToString(TransportMode route) {
  switch (route) {
    case TransportMode.none:
      return 'Wybierz z listy';
    case TransportMode.car:
      return 'Samochodem';
    case TransportMode.train:
      return 'Pociągiem';
    case TransportMode.publicTransport:
      return 'Komunikacją miejską';
    case TransportMode.bike:
      return 'Rowerem';
    case TransportMode.walk:
      return 'Spacerkiem';
  }
}

Icon mapRouteEnumToIcon(TransportMode route) {
  switch (route) {
    case TransportMode.none:
      return const Icon(Icons.add_road);
    case TransportMode.car:
      return const Icon(Icons.directions_car);
    case TransportMode.train:
      return const Icon(Icons.train);
    case TransportMode.publicTransport:
      return const Icon(Icons.directions_bus);
    case TransportMode.bike:
      return const Icon(Icons.directions_bike);
    case TransportMode.walk:
      return const Icon(Icons.directions_walk);
  }
}
