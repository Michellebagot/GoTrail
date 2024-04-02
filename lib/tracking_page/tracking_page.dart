import 'dart:async';
import 'package:flutter/material.dart';
import 'package:GoTrail/classes/trail.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class TrackingPage extends StatefulWidget {
  final Trail trail;

  TrackingPage(this.trail);

  @override
  TrackingPageState createState() => TrackingPageState();
}

class TrackingPageState extends State<TrackingPage> {
  MapController mapController = MapController();
  bool isTracking = false;
  double distance = 0.0;
  double displayDistance = 0.0;
  late StreamSubscription<Position> positionStream;
  late LocationSettings locationSettings;
  LatLng? lastLocation;
  String? userId;

  @override
  void initState() {
    super.initState();
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );

    userId = getCurrentUserId();

    _requestLocationPermission();

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');

      if (isTracking) {
        print('updating position stream and tracking location...');
        if (lastLocation != null) {
          print("$lastLocation, <lastLocation");
          double diff = Geolocator.distanceBetween(lastLocation!.latitude,
              lastLocation!.longitude, position!.latitude, position.longitude);
          print(diff);
          setState(() {
            displayDistance += diff;
            distance += diff;
          });
          if (distance >= 10) {
            _updatePoints();
            distance = 0;
            print("resetting distance to 0 and updating firestore");
          }
        }
      }
      lastLocation = LatLng(position!.latitude, position.longitude);
    });
  }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }

  void startTracking() {
    setState(() {
      isTracking = true;
      displayDistance = 0.0;
    });
  }

  void stopTracking() {
    setState(() {
      isTracking = false;
      lastLocation = null;
    });
  }

  void _requestLocationPermission() async {
    await Geolocator.requestPermission();
  }

  void _updatePoints() {
    DocumentReference userDocumentRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    userDocumentRef.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        int currentPoints = data?['pointsEarned'] ?? 0;
        int newValue = currentPoints + 100;

        userDocumentRef.update({
          'pointsEarned': newValue,
        }).then((value) {
          print("added 100 points");
        }).catchError((error) {
          print(error);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(
            context,
            BoxConstraints(
              minWidth: double.infinity,
              maxWidth: double.infinity,
              minHeight: 30,
              maxHeight: 50,
            ),
            0,
          ),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: widget.trail.coordinates[0],
                initialZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  maxZoom: 19,
                ),
                CurrentLocationLayer(
                  alignPositionOnUpdate: AlignOnUpdate.always,
                  style: LocationMarkerStyle(
                    marker: const DefaultLocationMarker(
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                    ),
                    markerSize: const Size(40, 40),
                  ),
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: widget.trail.coordinates,
                      color: Colors.blue,
                      strokeWidth: 3,
                    ),
                  ],
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
            heroTag: "toggle-tracking",
            onPressed: isTracking ? stopTracking : startTracking,
            backgroundColor: isTracking ? Colors.blueGrey[800] : null,
            tooltip: isTracking ? 'Stop tracking' : 'Start tracking',
            child: isTracking ? Icon(Icons.pause) : Icon(Icons.play_arrow)),
        SizedBox(height: 16),
        Text(
            isTracking ? '${(displayDistance).toStringAsFixed(0)}m' : "paused"),
        SizedBox(height: 32),
      ]),
    );
  }
}
