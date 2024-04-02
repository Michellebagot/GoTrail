import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GoTrail/trail_view/trail_details_page.dart';
import 'package:GoTrail/classes/trail.dart';

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

        String docId = doc.id;

        return Trail(
          trailId: docId,
          name: doc['name'] ?? '',
          description: doc['description'] ?? '',
          coordinates: latLngList,
          image: doc['image'] ?? '',
        );
      }).toList();

      return trails;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: stainland,
        initialZoom: 12,
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
                          title: Text('Trail Details'),
                          content: IntrinsicWidth(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(trail.name),
                                  Text(trail.description),
                            
                                ]),
                          ),
                          actions: [
                            ElevatedButton(onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop('dialog');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrailDetailsPage(trail),
                                ),
                              );
                            },
                            child: Text("View more details",                 
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            )
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close',                
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              ),
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
            color: Colors.blue,
            strokeWidth: 3,
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
