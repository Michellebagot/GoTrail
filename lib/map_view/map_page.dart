import 'package:flutter/material.dart';
import 'map_widget.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: MapWidget(),
    );
  }
}
