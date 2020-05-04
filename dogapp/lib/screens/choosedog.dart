import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogapp/screens/play.dart';
import 'package:dogapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:dogapp/screens/play.dart';

class Choose extends StatefulWidget {
  final String uid;
  final String dogName;

  const Choose({Key key, this.uid, this.dogName}) : super(key: key); 

  @override
  _ChooseState createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  //final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose your Dog'),
      ),
      body: StreamBuilder(                    
          stream: Firestore.instance.collection('dog').where('userId', isEqualTo: widget.uid).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Loading();
            return ListView(
              children: snapshot.data.documents.map((document) {
                return Card(
                  child: ListTile(
                    title: Text(document['name']),
                    subtitle: Text(document['breed']),
                    trailing: Icon(Icons.more_vert),
                    isThreeLine: true,
                    onTap: (){
                      print(document['name']);
                      Navigator.of(context).pop();
                      Navigator.push(context, new MaterialPageRoute(
                      builder: (BuildContext context) => new Plays(uid:document.documentID, dogName: document['name'],))
                      );
                    },
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
