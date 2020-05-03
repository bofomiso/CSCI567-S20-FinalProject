import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogapp/shared/constants.dart';
import 'package:dogapp/shared/loading.dart';
import 'package:flutter/material.dart';

class EditDog extends StatefulWidget {
  final String uid;
  final String dogName;
  final String dogBreed;
  final String dogSize;
  final String dogAge;
  
  const EditDog({Key key, this.uid, this.dogAge, this.dogBreed, this.dogName, this.dogSize}) : super(key: key);
 

  @override
  _EditDogState createState() => _EditDogState();
}

class _EditDogState extends State<EditDog> {

  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool  loading = false;

  String dogBreed = "";
  String dogSize = "";
  String dogAge = "";
  String error = "";
  String dogName = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Edit Dog'),
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
                  initialValue: widget.dogName,
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
                  initialValue: widget.dogBreed,
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
                  initialValue: widget.dogSize,
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
                  initialValue: widget.dogAge,
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
                          editDog();
                          Navigator.pop(context);
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
  void editDog() async {
    if(dogSize.isEmpty){
      dogSize = widget.dogSize;
    }
    if(dogBreed.isEmpty){
      dogBreed = widget.dogBreed;
    }
    if(dogName.isEmpty){
      dogName = widget.dogName;
    }
    if(dogAge.isEmpty){
      dogAge = widget.dogAge;
    }
    await db.collection('dog').document(widget.uid).updateData({'name':'$dogName', 
    'breed':'$dogBreed', 'age':'$dogAge', 'size':'$dogSize',});
  }
}