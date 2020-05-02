import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogapp/services/auth.dart';
import 'package:dogapp/shared/constants.dart';
import 'package:dogapp/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewDog extends StatefulWidget {

  @override
  _NewDogState createState() => _NewDogState();
}

class _NewDogState extends State<NewDog> {
  final AuthServices _auth  = AuthServices();
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool  loading = false;

  String dogName = "";
  String dogBreed = "";
  String dogSize = "";
  String dogAge = "";
  String error = "";
  

  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Adding Dog'),
      ),
      body:SafeArea(
        child:SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                  SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Name',
                  ),
                  validator: (val) => val.isEmpty ? 'Enter a Name' : null,
                  onChanged: (val){
                    setState(() {
                      dogName = val;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Breed',
                  ),
                  validator: (val) => val.isEmpty ? 'Enter a Breed' : null,
                  onChanged: (val){
                    setState(() {
                      dogBreed = val;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Size',
                  ),
                  validator: (val) => val.isEmpty ? 'Small, Medium, Large' : null,
                  onChanged: (val){
                    setState(() {
                      dogSize = val;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Age'
                  ),
                  validator: (val) => val.isEmpty ? 'Age' : null,                
                  onChanged: (val){
                    setState(() {
                      dogAge = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[                    
                    RaisedButton(
                    color: Colors.red,
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white70),
                      ),
                      onPressed: () async{
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                    color: Colors.green,
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white70),
                      ),
                      onPressed: () async{
                        if(_formKey.currentState.validate()){
                          createDog();
                        }
                      },
                    ),
                  ],

                ),
                SizedBox(height: 20.0,),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ]
            )
          ),
        ),
        ),
      ),
    );
  }
  void createDog() async{
    if(_formKey.currentState.validate()){
      final FirebaseUser user = await _auth.getUser();
      final uid = user.uid;
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('dog').add({'name':'$dogName', 'breed':'$dogBreed', 'age':'$dogAge', 'size':'$dogSize', 'userId':'$uid'});
      print(ref.documentID);
      Navigator.pop(context);
    }
  }

}
