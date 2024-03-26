import 'package:latlong2/latlong.dart';

class Trail {
  final String name;
  final String description;
  final List<LatLng> coordinates;

  Trail({
    required this.name,
    required this.description,
    required this.coordinates,
  });
}