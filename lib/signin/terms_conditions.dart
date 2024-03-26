import 'package:flutter/material.dart';

 Widget termsConditions(context, action) {
     return const Padding(
       padding: EdgeInsets.only(top: 16),
       child: Text(
         'By signing in, you agree to our terms and conditions.',
         style: TextStyle(color: Colors.grey),
       ),
     );
   }