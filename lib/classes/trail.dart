import 'package:latlong2/latlong.dart';

class Trail {
  final String trailId;
  final String name;
  final String description;
  final List<LatLng> coordinates;

  Trail({
    required this.trailId,
    required this.name,
    required this.description,
    required this.coordinates,
  });

  Null get location => null;
}