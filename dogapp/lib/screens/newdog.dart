import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogapp/services/auth.dart';
import 'package:dogapp/shared/constants.dart';
import 'package:dogapp/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class NewDog extends StatefulWidget {
  @override
  _NewDogState createState() => _NewDogState();
}

class _NewDogState extends State<NewDog> {
  File _path;
  final AuthServices _auth  = AuthServices();
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool  loading = false;

 

  String dogName = "";
  String dogBreed = "";
  String dogSize = "";
  String dogAge = "";
  String error = "";
  String url;
  String picUrl;
  

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
                  keyboardType: TextInputType.phone,
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
                SafeArea(
                  child:  Column(
                    children: <Widget>[
                      _path == null ? Image.asset('assets/dog.png', width: 200, height: 200,) : Image.file(_path, width: 200, height: 200,)
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    typeOfPic(context);
                  }, 
                  child: Text('Picture'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
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
                          //toUpload(_path);
                            int randomNum = Random().nextInt(100000);
                            String imageLocation = 'images/images$randomNum.jpg';

                            StorageReference storageRef = FirebaseStorage.instance.ref().child(imageLocation);
                            StorageUploadTask uploadTask = storageRef.putFile(_path);
                            StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    
                            url = await(taskSnapshot).ref.getDownloadURL();
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
      DocumentReference ref = await db.collection('dog').add({'name':'$dogName', 'breed':'$dogBreed', 'age':'$dogAge', 'size':'$dogSize', 'userId':'$uid', 'pictureURL': '$url'});
      print(ref.documentID);
      Navigator.pop(context);
    }
  }

  void typeOfPic(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Container(
          height: 150,
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () {
                  goToCamera();
                  Navigator.pop(context);
                },
                leading: Icon(Icons.photo_camera),
                title: Text('Take a picture'),
              ),
              ListTile(
                onTap: (){
                  goToLibrary();
                  Navigator.pop(context);
                },
                leading: Icon(Icons.photo_library),
                title: Text('Choose from library'),
              ),
            ],
          ),
        );
      }
    );
  }

  void goToLibrary() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(file.path);

    setState(() {
      _path = file;
    });
    
  }

  void goToCamera() async {
    final file = await ImagePicker.pickImage(source: ImageSource.camera);
    print(file.path);

    setState(() {
      _path = file;
    });
  }

 upload(BuildContext context) async {
    //String filename = _path.path;
    if(_path != null){
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(_path.toString());
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_path);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      url = await (taskSnapshot).ref.getDownloadURL();
    }
  }
  
  toUpload(File imageFile) async {
    int randomNum = Random().nextInt(100000);
    String imageLocation = 'images/images$randomNum.jpg';

    StorageReference storageRef = FirebaseStorage.instance.ref().child(imageLocation);
    StorageUploadTask uploadTask = storageRef.putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    
    url = await(taskSnapshot).ref.getDownloadURL();
    //print(url);
    picUrl = url.toString();
    print(picUrl);

    
  }

}
