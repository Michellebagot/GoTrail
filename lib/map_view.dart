import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
// import 'package:http/http.dart' as http;
// import 'api/api_key.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class MapWidget extends StatefulWidget {
  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  LatLng stainland = LatLng(53.6717, -1.8837);
  GeoJsonParser myGeoJson = GeoJsonParser();
  List<Polyline> polylines = [];
  double radius = 0.1;
  List<Trail> trails = [];

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('trails');

  @override
  void initState() {
    super.initState();
    getTrails().then((fetchedTrails) {
      setState(() {
        trails = fetchedTrails;
      });
    });
  }

  Future<List<Trail>> getTrails() async {
    try {
      QuerySnapshot querySnapshot = await _collectionRef.get();

      List<Trail> trails = querySnapshot.docs.map((doc) {
        List<GeoPoint> geoPoints = (doc['coordinates'] as List)
            .map((point) => point as GeoPoint)
            .toList();

        List<LatLng> latLngList = geoPoints
            .map((geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude))
            .toList();

        return Trail(
          name: doc['name'] ?? '',
          description: doc['description'] ?? '',
          coordinates: latLngList,
        );
      }).toList();

      return trails;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // void fetchData() async {
  //   double minLongitude = stainland.longitude - radius;
  //   double minLatitude = stainland.latitude - radius;
  //   double maxLongitude = stainland.longitude + radius;
  //   double maxLatitude = stainland.latitude + radius;

  //   String bbox = "$minLongitude,$minLatitude,$maxLongitude,$maxLatitude";

  //   var url = Uri.https('osm.buntinglabs.com', '/v1/osm/extract', {
  //     'tags': 'highway=path&name=*',
  //     'api_key': osmApiKey,
  //     'bbox': bbox,
  //   });

  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     setState(() {
  //       myGeoJson.parseGeoJsonAsString(response.body);
  //       polylines = myGeoJson.polylines;
  //     });
  //   } else {
  //     print('Request failed, status: ${response.statusCode}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: stainland,
        initialZoom: 9.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
            markers: trails.map((trail) {
          return Marker(
            child: GestureDetector(
                child: Icon(Icons.push_pin),
                onTap: () {
                  print("tapped marker!");
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Trail details'),
                          content: IntrinsicWidth(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(trail.name),
                                  Text(trail.description)
                                ]),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      });
                }),
            point: trail.coordinates[0],
            width: 15,
            height: 15,
          );
        }).toList()),
        PolylineLayer(
            polylines: trails.map((trail) {
          return Polyline(
            points: trail.coordinates,
            color: Colors.blue, // Customize polyline color
            strokeWidth: 3, // Customize polyline width
          );
        }).toList()),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
    );
  }
}
