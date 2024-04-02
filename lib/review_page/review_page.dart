import 'package:flutter/material.dart';
import 'package:GoTrail/classes/trail.dart';
import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewPage extends StatefulWidget {
  final Trail trail;

  ReviewPage(this.trail);

  @override
  ReviewPageState createState() => ReviewPageState();
}

class ReviewPageState extends State<ReviewPage> {
  String? userId;
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  String _comment = '';

  @override
  void initState() {
    super.initState();
    userId = getCurrentUserId();
  }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  void _submitReview() {
    FirebaseFirestore.instance.collection('reviews').add({
      'userId': userId,
      'trailId': widget.trail.trailId,
      'rating': _rating,
      'comment': _comment,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Review submitted, thanks!'),
        ),
      );
      setState(() {
        _rating = 0;
        _comment = '';
      });
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Couldn't submit your review: $error"),
        ),
      );
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
            0),
        Text('Reviewing ${widget.trail.name} as $userId'),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Rate this trail:',
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Enter your comment',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _comment = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _submitReview();
                      }
                    },
                    child: Text('Submit',                 
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
