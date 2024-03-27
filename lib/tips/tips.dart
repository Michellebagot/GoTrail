import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle titleStyle = TextStyle(
  fontFamily: GoogleFonts.balooBhaina2().fontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 24, //needs altering to accomodate mobile styling
  color: Colors.black,
  decoration: TextDecoration.none,
);

TextStyle detailStyle = TextStyle(
  fontFamily: GoogleFonts.lexendDeca().fontFamily,
  fontWeight: FontWeight.normal,
  fontSize: 18, //needs altering to accomodate mobile styling
  color: Colors.black,
  decoration: TextDecoration.none,
);

const tipLoadingObj = {
  'tipTitle': 'Tips Loading',
  'tipDetail': "Please wait a moment"
};

class RandomTip extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _RandomTipState createState() => _RandomTipState();
}

class _RandomTipState extends State<RandomTip> {
  List _tip = [];
  int _currentIndex = 0;

  Future<void> _getRandomTip(loadingObj) async {
    _tip.add(loadingObj);
    final tipsCollection = FirebaseFirestore.instance.collection('tips');
    final querySnapshot = await tipsCollection.get();
    final allTips = querySnapshot.docs.map((tip) => _tip.add(tip.data()));
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        print(allTips);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getRandomTip(tipLoadingObj);
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (Random().nextInt(_tip.length)) % _tip.length;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //TODO : fix height when in home/app with other widgets

  @override
  Widget build(BuildContext context) {
    var tip = _tip[_currentIndex]; 

    if (_currentIndex == 0) {
      _currentIndex + 1;
    }
 
    return Card(
        margin: EdgeInsets.all(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        color: Color.fromRGBO(166, 159, 119, 1),
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(tip['tipTitle'],
                      textAlign: TextAlign.center, style: titleStyle),
                ),
                Flexible(
                  child: Text(
                    tip['tipDetail'],
                    textAlign: TextAlign.center,
                    style: detailStyle,
                  ),
                ),
              ],
            )));
  }
}
