import 'package:GoTrail/profile/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class TrailBlazers extends StatefulWidget {
  @override
  TrailBlazersState createState() => TrailBlazersState();
}

class TrailBlazersState extends State<TrailBlazers> {
  var db = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> data = [];

  var chosenTrailBlazer = '';
  var trailBlazerName = '';

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
             child: Center(child: Text('Choose your TrailBlazer', style: TextStyle(fontSize: 20),))
             ),
           Row(
             children: [
               Expanded(
                 child: SizedBox(
                   child: IconButton(
                     icon: Image.asset('assets/blue_type1.gif'),
                     iconSize: 1,
                     onPressed: () {
                       chosenTrailBlazer = 'water1';
                       },
                     ),
                 )
               ),
               Expanded(
                child: SizedBox( height: 250, width: 250,
                  child: IconButton(
                   icon: Image.asset('assets/green_type1.gif'),
                   iconSize: 1,
                   onPressed: () {
                     chosenTrailBlazer = 'grass1';
                   },
                 ),
                )
               ),
             ],
           ),
           Container(
             padding: const EdgeInsets.all(5),
             child: SizedBox( height: 250, width: 250,
               child: IconButton(
                 icon: Image.asset('assets/brown_type1.gif'),
                 iconSize: 50,
                 onPressed: () {
                     chosenTrailBlazer = 'mountain1';
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
                   profilePage(),
                   )
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
    
    // Scaffold(
    //   backgroundColor: Color.fromRGBO(255, 246, 222, 1),
    //    appBar: AppBar( // TODO : need to extract this and replace with header_bar 
    //     ),

    //   body: Padding(
    //     padding: const EdgeInsets.all(25.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
          
    //       children: [
    //         Container(
    //           padding: const EdgeInsets.all(5),
    //           child: Center(child: Text('Choose your TrailBlazer', style: TextStyle(fontSize: 20),))
    //           ),
    //         Row(
    //           children: [
    //             Expanded(
    //               child: SizedBox( 
    //                 child: IconButton(
    //                   icon: Image.asset('assets/blue_type1.gif'),
    //                   iconSize: 1,
    //                   onPressed: () {
    //                     chosenTrailBlazer = 'water1';
    //                     },
    //                   ),
    //               )
    //             ),
    //             Expanded(
    //              child: SizedBox( height: 250, width: 250,
    //                child: IconButton(
    //                 icon: Image.asset('assets/green_type1.gif'),
    //                 iconSize: 1,
    //                 onPressed: () {
    //                   chosenTrailBlazer = 'grass1';
    //                 },
    //               ),
    //              )
    //             ),
    //           ],
    //         ),
    //         Container(
    //           padding: const EdgeInsets.all(5),
    //           child: SizedBox( height: 250, width: 250,
    //             child: IconButton(
    //               icon: Image.asset('assets/brown_type1.gif'),
    //               iconSize: 50,
    //               onPressed: () {
    //                   chosenTrailBlazer = 'mountain1';
    //               },
    //             ),
    //           )
    //         ),
    //         Center(
    //           child: Text('Give your TrailBlazer a name:', style: TextStyle(fontSize: 20),)),
    //         TextField(
    //           onChanged:(value){
    //             trailBlazerName = value;
    //           },
    //         decoration: InputDecoration(
    //           border: OutlineInputBorder(),
    //           hintText: 'Enter name here',
              
    //         ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: ElevatedButton(
    //             onPressed: (){
    //               if (chosenTrailBlazer.isEmpty || trailBlazerName.isEmpty){
    //               showAlertDialog(context);

    //               }else{
    //               final userUpdate = db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid);
    //               userUpdate.update({"trailBlazer": chosenTrailBlazer, "trailBlazerName": trailBlazerName}).then(
    //                 (value) =>   Navigator.push(
    //                 context,
    //                 profilePage(),
    //                 )
    //               );
    //               }
    //             },
    //             child: Text('Confirm'),
    //           ),
    //         ),    
    //       ],
    //     ),
    //   ),
    // );






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
