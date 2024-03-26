import 'package:flutter/material.dart';
import 'package:GoTrail/classes/trail.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

class TrailDetailsPage extends StatelessWidget {
  final Trail trail;

  TrailDetailsPage(this.trail);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trail Details'),
      ),
      body: Column(
        children: [
          Text(
            'Trail Name: ${trail.name}',
          ),
          SizedBox(height: 10),
          Text(
            'Description: ${trail.description}',
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: trail.coordinates[0],
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: trail.coordinates,
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
          ),
          Text('Rating: ####'),
          Text('Reviews:')
        ],
      ),
    );
  }
}
