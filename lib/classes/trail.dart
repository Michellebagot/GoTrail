import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Trail {
  final String trailId;
  final String name;
  final String description;
  final List<LatLng> coordinates;
  final String image;
  final String difficulty;
  final int avgTime;
  final int distance;
  // final int elevation;

  Trail({
    required this.trailId,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.image,
    required this.difficulty,
    required this.avgTime,
    required this.distance,
    // required this.elevation,
  });

  Trail.fromSnapshot(DocumentSnapshot snapshot)
      : trailId = snapshot.id,
        name = snapshot.get('name'),
        description = snapshot.get('description'),
        coordinates = _convertToLatLng(snapshot.get('coordinates')),
        image = snapshot.get('image'),
        difficulty = snapshot.get('difficulty'),
        avgTime = snapshot.get('avgTime'),
        distance = snapshot.get('distance');
        // elevation = snapshot.get('elevation');
        

  static List<LatLng> _convertToLatLng(List<dynamic> coordinates){
    List<GeoPoint> geoPoints =
        (coordinates).map((point) => point as GeoPoint).toList();

    List<LatLng> latLngList = geoPoints
        .map((geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude))
        .toList();
    
    return latLngList;
  }

  Null get location => null;
}
