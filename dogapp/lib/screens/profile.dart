import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogapp/screens/newdog.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), actions: <Widget>[
        FlatButton.icon(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => NewDog()));
            },
            icon: Icon(Icons.person),
            label: Text("Add Dog"))
      ]),
      body: StreamBuilder(
          stream: Firestore.instance.collection('dog').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const Text("Loading...");
            return new ListView(
                children: snapshot.data.documents.map((document) {
              return new ListTile(
                title: Text(document['name']),
                subtitle: Text(document['breed']),
              );
            }).toList(),
            );
          }),
    );
  }
}
