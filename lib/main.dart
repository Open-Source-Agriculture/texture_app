import 'package:flutter/material.dart';
import 'package:texture_app/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:texture_app/models/user.dart';

void main() {
  runApp(MyApp(
    
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        child: MaterialApp(
          home: Wrapper(

          ),
        )
    );
  }
}
