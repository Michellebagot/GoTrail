import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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
      appBar: AppBar(
        title: Text('Trail Search'),
      ),
      body: Column(
        children: [
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

class Trail {
  final String name;
  final String description;


  Trail.fromSnapshot(DocumentSnapshot snapshot)
      : this.name = snapshot.get('name'),
        this.description = snapshot.get('description');
}

class TrailListItem extends StatelessWidget {
  final Trail trail;

  const TrailListItem(this.trail);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(trail.name),
      subtitle: Text(trail.description),
    );
  }
}
