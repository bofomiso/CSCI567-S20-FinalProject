import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogapp/screens/log.dart';
import 'package:dogapp/screens/play.dart';
import 'package:dogapp/shared/loading.dart';
import 'package:flutter/material.dart';

class ChooseLog extends StatefulWidget {
  final String uid;
  final String dogName;

  const ChooseLog({Key key, this.uid, this.dogName}) : super(key: key); 

  @override
  _ChooseLogState createState() => _ChooseLogState();
}

InkWell buildItem(context, DocumentSnapshot doc) {
  return InkWell(
      onTap: () => goLog(context,doc),
      splashColor: Colors.pink,
      child: 
      Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.greenAccent,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: 
        Container(
          width: double.infinity,
                  child: Column(          
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                doc.data['name'],
                style: TextStyle(fontSize: 28),
              ),
              Text(
                'Breed: ${doc.data['breed']}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Size: ${doc.data['size']}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Age: ${doc.data['age']}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _ChooseLogState extends State<ChooseLog> {
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
                return buildItem(context, document);
              }).toList(),
            );
          }),
    );
  }
}

  void goLog(context, document) {
  Navigator.push(context,MaterialPageRoute(
                      builder: (BuildContext context) => Logs(dogId:document.documentID,                      
                      dogName: document['name'],
                      )));
                      print(document['name']);
  }