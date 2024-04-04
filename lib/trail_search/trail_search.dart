import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:GoTrail/trail_view/trail_details_page.dart';
import 'package:GoTrail/classes/trail.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  dynamic dropdown;
  List<String> list = <String>['Easy', 'Medium', 'Hard'];
  String _searchText = "";
  String dropdownValue = '';
  List<Trail> _allTrails = [];
  List<Trail> _filteredTrails = [];

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    dropdownValue = list.first;
    _fetchTrails();
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
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search local trails...',
            ),
            onChanged: (text) {
              setState(() {
                _searchText = text;
                _filterTrails(_searchText);
              });
            },
          ),
          ////////////////////////////
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text('Filter your difficulty: '),
                DropdownMenu<String>(
                  initialSelection: list.first,
                  onSelected: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      _filteredTrails = _allTrails
                          .where((trail) =>
                              trail.difficulty == value.toLowerCase())
                          .toList();
                      print(value);
                      print(_filteredTrails);
                    });
                  },
                  dropdownMenuEntries:
                      list.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                )
              ],
            ),
          ),
          Expanded(
            child: _filteredTrails.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredTrails.length,
                    itemBuilder: (context, index) =>
                        TrailListItem(_filteredTrails[index]),
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
      final trailList =
          trails.docs.map((doc) => Trail.fromSnapshot(doc)).toList();
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
      _filteredTrails = _allTrails
          .where((trail) =>
              trail.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }
}

class TrailListItem extends StatelessWidget {
  final Trail trail;

  const TrailListItem(this.trail);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrailDetailsPage(trail),
          ),
        );
      },
      child: ListTile(
        leading: trail.image != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(trail.image),
              )
            : Placeholder(child: Icon(Icons.image_not_supported)),
        title: Text(trail.name),
        subtitle: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrailDetailsPage(trail),
                  ),
                );
              },
              child: Text(trail.description),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrailDetailsPage(trail),
                  ),
                );
              },
              child: Text(
                "View trail",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/////

