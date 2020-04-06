import 'package:dogapp/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog App'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async{
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text("Logout"))
        ],
      ),
      body: Center(
        child: Image.asset('assets/dog.png'),
      ),
      bottomNavigationBar:ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              child: Text('Sign Out'),
              onPressed: null,
            ),
            FloatingActionButton(
              child: Text('Profile'),
              onPressed: null,
            ),
            FloatingActionButton(
              child: Text('Log'),
              onPressed: null
            ),
            FloatingActionButton(
              child: Text('Park'),
              onPressed:null
            ),  
          ],
        ), 
    );
  }
}

