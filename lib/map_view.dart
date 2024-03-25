import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:http/http.dart' as http;
import 'api/api_key.dart';


class MapWidget extends StatefulWidget {
  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  LatLng stainland = LatLng(53.6717, -1.8837);
  GeoJsonParser myGeoJson = GeoJsonParser();
  List<Polyline> polylines = [];
  double radius = 0.1;
  
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    double minLongitude = stainland.longitude - radius;
    double minLatitude = stainland.latitude - radius;
    double maxLongitude = stainland.longitude + radius;
    double maxLatitude = stainland.latitude + radius;

    String bbox = "$minLongitude,$minLatitude,$maxLongitude,$maxLatitude";

    var url = Uri.https('osm.buntinglabs.com', '/v1/osm/extract', {
      'tags': 'highway=path&name=*',
      'api_key': osmApiKey,
      'bbox': bbox,
    });

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        myGeoJson.parseGeoJsonAsString(response.body);
        polylines = myGeoJson.polylines;
      });
    } else {
      print('Request failed, status: ${response.statusCode}');
    }
  }

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
            markers: polylines.map((polyline) {
          return Marker(
              child: Icon(Icons.push_pin),
              point: LatLng(polyline.points.first.latitude,
                  polyline.points.first.longitude),
              width: 15,
              height: 15);
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
