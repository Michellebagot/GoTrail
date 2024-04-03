import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:GoTrail/profile/trail_blazer_profile.dart';

class TrailBlazers extends StatefulWidget {
  @override
  TrailBlazersState createState() => TrailBlazersState();
}

class TrailBlazersState extends State<TrailBlazers> {
  var db = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> data = [];

  @override
  void initState() {
    super.initState();
  }

  var chosenTrailBlazer = '';
  var trailBlazerName = '';

  // Trailblazer sizing addressed

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        'Choose your TrailBlazer',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: IconButton(
                            icon: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.gif', 
                              image: 'assets/blue_type1.gif', 
                              width: 250.0, 
                              height: 250.0, 
                              fit: BoxFit.cover, 
                            ),
                            iconSize: 50.0, 
                            onPressed: () {
                              chosenTrailBlazer = 'water1';
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 250, width: 250,
                          child: IconButton(
                            icon: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.gif', 
                              image: 'assets/green_type1.gif', 
                              width: 250.0, 
                              height: 250.0, 
                              fit: BoxFit.cover, 
                            ),
                            iconSize: 50.0, 
                            onPressed: () {
                              chosenTrailBlazer = 'grass1';
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      height: 250, width: 250,
                      child: IconButton(
                        icon: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.gif', 
                          image: 'assets/brown_type1.gif', 
                          width: 250.0, 
                          height: 250.0, 
                          fit: BoxFit.cover, 
                        ),
                        iconSize: 50.0, 
                        onPressed: () {
                          chosenTrailBlazer = 'mountain1';

                          // Trailblazer sizing addressed
                 },
               ),
             )
           ),
           Center(
             child: Text('Give your TrailBlazer a name:', style: TextStyle(fontSize: 20),)),
           TextField(
             onChanged:(value){
               trailBlazerName = value;
             },
           decoration: InputDecoration(
             border: OutlineInputBorder(),
             hintText: 'Enter name here',
            
           ),
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ElevatedButton(
               onPressed: (){
                 if (chosenTrailBlazer.isEmpty || trailBlazerName.isEmpty){
                 showAlertDialog(context);


                 }else{
                 final userUpdate = db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid);
                 userUpdate.update({"trailBlazer": chosenTrailBlazer, "trailBlazerName": trailBlazerName}).then(
                   (value) =>   Navigator.push(
                   context,
                   MaterialPageRoute(
                          builder: (context) => TrailBlazerProfile()
                   )),
                 );
                 }
               },
               child: Text('Confirm'),
             ),
           ),   

         ],
         ),
         ),
         ]
      )
    )
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text("Please select your TrailBlazer and enter a Name."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
