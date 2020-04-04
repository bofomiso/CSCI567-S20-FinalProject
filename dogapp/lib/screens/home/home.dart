import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog App'),
        centerTitle: true,
      ),
      body: Center(
        child: Image.asset('assets/dog.png'),
      ),
      bottomNavigationBar:ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              child: Text('Play'),
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