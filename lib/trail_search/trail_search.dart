import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:GoTrail/trail_view/trail_details_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:GoTrail/classes/trail.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchText = "";
  List<Trail> _allTrails = []; 
  List<Trail> _filteredTrails = []; 

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchTrails();
  }

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
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search trails...',
            ),
            onChanged: (text) {
              setState(() {
                _searchText = text;
                _filterTrails(_searchText);
              });
            },
          ),
          Expanded(
            child: _filteredTrails.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredTrails.length,
                    itemBuilder: (context, index) => TrailListItem(_filteredTrails[index]),
                  )
                : Center(child: Text('No trails found!')),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchTrails() async {
    try {
      final trails = await _firestore.collection('trails').get();
      final trailList = trails.docs.map((doc) => Trail.fromSnapshot(doc)).toList();
      setState(() {
        _allTrails = trailList;
        _filteredTrails = trailList;
      });
    } catch (error) {
      print('Error fetching trails: $error');
    }
  }

  void _filterTrails(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        _filteredTrails = _allTrails; 
      });
      return;
    }
    setState(() {
      _filteredTrails = _allTrails.where((trail) => trail.name.toLowerCase().contains(searchText.toLowerCase())).toList();
    });
  }
}

// class Trail {
//   final String name;
//   final String description;
//   final String trailId;
//   final List<LatLng> coordinates; 

//   Trail.fromSnapshot(DocumentSnapshot snapshot)
//       : name = snapshot.get('name'),
//         description = snapshot.get('description'),
//         trailId = snapshot.get('trailId'),
//         coordinates = snapshot.get('coordinates');
// }

class TrailListItem extends StatelessWidget {
  final Trail trail;

  const TrailListItem(this.trail);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(trail.name),
      subtitle: Row(
        children: [
          Text(trail.description),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrailDetailsPage(trail),
                  ),
                );
              },
              child: Text("View more details")),
        ],
      ),
      
    );
  }
}
