import 'package:cloud_firestore/cloud_firestore.dart';
import './assets/gpx_data/beacon_hill.dart';
import './assets/gpx_data/byron_edge.dart';
import './assets/gpx_data/crow_hill.dart';
import './assets/gpx_data/gallows_pole_hill.dart';
import './assets/gpx_data/marsden_moors.dart';
import './assets/gpx_data/norland_moor.dart';
import './assets/gpx_data/pike_law.dart';
import './assets/gpx_data/sample.dart';
import './assets/gpx_data/wharmton.dart';

//database is seeded so no need to use this file again

Future<void> seedFirestoreWithTrails() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //should probably be refactored to use batching
  try {
    await addTrailToFirestore(firestore, 'Trail 1', trailData1);
    print('trail ${trailData1['name']} added to firestore.');
    await addTrailToFirestore(firestore, 'Trail 2', trailData2);
    print('trail ${trailData2['name']} added to firestore.');
    await addTrailToFirestore(firestore, 'Trail 3', trailData3);
    print('trail ${trailData3['name']} added to firestore.');
    await addTrailToFirestore(firestore, 'Trail 4', trailData4);
    print('trail ${trailData4['name']} added to firestore.');
    await addTrailToFirestore(firestore, 'Trail 5', trailData5);
    print('trail ${trailData5['name']} added to firestore.');
    await addTrailToFirestore(firestore, 'Trail 6', trailData6);
    print('trail ${trailData6['name']} added to firestore.');
    await addTrailToFirestore(firestore, 'Trail 7', trailData7);
    print('trail ${trailData7['name']} added to firestore.');
    await addTrailToFirestore(firestore, 'Trail 8', trailData8);
    print('trail ${trailData8['name']} added to firestore.');
    await addTrailToFirestore(firestore, 'Trail 9', trailData9);
    print('trail ${trailData9['name']} added to firestore.');
  } catch (e) {
    print("error seeding firestore: $e");
  }
}

Future<void> addTrailToFirestore(FirebaseFirestore firestore, String trailName,
    Map<String, dynamic> trailData) async {
  List<GeoPoint> geoPoints = [];
  for (List<dynamic> coordinate in trailData['coordinates']) {
    double latitude = double.parse(coordinate[0]);
    double longitude = double.parse(coordinate[1]);
    geoPoints.add(GeoPoint(latitude, longitude));
  }

  await firestore.collection('trails').add({
    'name': trailName,
    'description': '',
    'coordinates': geoPoints,
  });
}
