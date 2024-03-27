import 'package:flutter/material.dart';
import 'map_widget.dart';
import 'package:GoTrail/header_bar/header_bar.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
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
            child:
                MapWidget(), // Assuming you want MapWidget to take remaining space
          ),
        ],
      ),
    );
  }
}
