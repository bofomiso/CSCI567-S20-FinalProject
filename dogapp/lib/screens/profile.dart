import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogapp/screens/newdog.dart';
import 'package:dogapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'editdog.dart';

class Profile extends StatefulWidget {
  final String uid;

  const Profile({Key key, this.uid}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

InkWell buildItem(context, DocumentSnapshot doc) {
  return InkWell(
      onTap: () => updatePage(context, doc),
      splashColor: Colors.pink,
      child: 
      Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.blue,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: 
        Container(
          width: double.infinity,
            child: Row(          
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
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
                ],
              ),
              Column(
                children: <Widget>[
                  Image.network(
                    doc.data['pictureURL'],
                    height: 110,
                    width: 110,
                  ),
                ],
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

final db = Firestore.instance;

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Dogs'), actions: <Widget>[
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
          stream: Firestore.instance
              .collection('dog')
              .where('userId', isEqualTo: widget.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Loading();
            return 
            ListView.builder(
              itemCount: snapshot.data.documents.length ,
              itemBuilder: (context, index){
                return buildItem(context, snapshot.data.documents[index]);
              },
            );
          }),
    );
  }
}

void updatePage(context, document) {
  Navigator.push(context,MaterialPageRoute(
                      builder: (BuildContext context) => EditDog(uid:document.documentID,
                      dogAge: document['age'],
                      dogName: document['name'],
                      dogSize: document['size'],
                      dogBreed: document['breed'],
                      picUrl: document['pictureURL'],)));
                      print(document['name']);
}

  void deleteDog(DocumentSnapshot doc) async{
    await db.collection('dog').document(doc.documentID).delete();
  }