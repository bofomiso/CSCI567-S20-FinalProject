import 'package:dogapp/models/user.dart';
import 'package:dogapp/screens/direction.dart';
import 'package:dogapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthServices().user,
        child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blue),
          title: "Dog App",
          home: Direction(),
      ),
    );
  }
}
