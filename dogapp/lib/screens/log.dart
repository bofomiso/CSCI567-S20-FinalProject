import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogapp/shared/loading.dart';


class Logs extends StatefulWidget {
  final String dogId;
  final String dogName;


  const Logs({Key key, this.dogId, this.dogName}) : super(key: key);
 
  @override
  _LogsState createState() => _LogsState();
}

InkWell buildItem(context, DocumentSnapshot doc) {
  return InkWell(
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
                  child: Column(          
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                doc.data['name'],
                style: TextStyle(fontSize: 28),
              ),
              Text(
                'Date: ${doc.data['date']}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Time: ${doc.data['time']}',
                style: TextStyle(fontSize: 20),
              ),
               Text(                 
                awardPicker(doc.data['time']),
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

  String awardPicker(String time){
    String temp = time.replaceAll(RegExp(r"[^\s\w]"),'');
    int temp1 = int.parse(temp);
    if(temp1>0&&temp1<1000){
      return "Play Rating: Bronze";
    }else if(temp1>=1000&&temp1<2000){
      return "Play Rating: Silver";
    }else if(temp1>=2000){
      return "Play Rating: Gold";
    }else{
      return "";
    }
  }

class _LogsState extends State<Logs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs'),
      ),
       body: StreamBuilder(                    
          stream: Firestore.instance.collection('log').where('dogId', isEqualTo: widget.dogId).snapshots(),
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