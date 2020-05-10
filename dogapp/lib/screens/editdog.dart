import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogapp/shared/constants.dart';
import 'package:dogapp/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditDog extends StatefulWidget {
  final String uid;
  final String dogName;
  final String dogBreed;
  final String dogSize;
  final String dogAge;
  final String picUrl;

  const EditDog(
      {Key key,
      this.uid,
      this.dogAge,
      this.dogBreed,
      this.dogName,
      this.dogSize,
      this.picUrl})
      : super(key: key);

  @override
  _EditDogState createState() => _EditDogState();
}

class _EditDogState extends State<EditDog> {
  File _path;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String dogBreed = "";
  String dogSize = "";
  String dogAge = "";
  String error = "";
  String dogName = "";
  String url = "";
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blueGrey,
            appBar: AppBar(
              title: Text('Edit Dog'),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: widget.dogName,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Name',
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter a Name' : null,
                          onChanged: (val) {
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
                          validator: (val) =>
                              val.isEmpty ? 'Enter a Breed' : null,
                          onChanged: (val) {
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
                          validator: (val) =>
                              val.isEmpty ? 'Small, Medium, Large' : null,
                          onChanged: (val) {
                            setState(() {
                              dogSize = val;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          initialValue: widget.dogAge,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Age'),
                          validator: (val) => val.isEmpty ? 'Age' : null,
                          onChanged: (val) {
                            setState(() {
                              dogAge = val;
                            });
                          },
                        ),
                        SafeArea(
                          child: Column(
                            children: <Widget>[
                              _path == null
                                  ? Image.network(
                                      widget.picUrl,
                                      width: 200,
                                      height: 200,
                                    )
                                  : Image.file(
                                      _path,
                                      width: 200,
                                      height: 200,
                                    )
                            ],
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
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
                        SizedBox(
                          height: 20.0,
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.blue,
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white70),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              color: Colors.red,
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.white70),
                              ),
                              onPressed: () async {
                                deleteDog();
                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              color: Colors.green,
                              child: Text(
                                "Save",
                                style: TextStyle(color: Colors.white70),
                              ),
                              onPressed: () async {
                                print("Before val");
                                if (_formKey.currentState.validate()) {
                                  print("After val");
                                  if (_path != null) {
                                    int randomNum = Random().nextInt(100000);
                                    String imageLocation =
                                        'images/images$randomNum.jpg';

                                    StorageReference storageRef =
                                        FirebaseStorage.instance
                                            .ref()
                                            .child(imageLocation);
                                    StorageUploadTask uploadTask =
                                        storageRef.putFile(_path);
                                    StorageTaskSnapshot taskSnapshot =
                                        await uploadTask.onComplete;
                                    url = await (taskSnapshot)
                                        .ref
                                        .getDownloadURL();
                                  }

                                  editDog();
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ])),
                ),
              ),
            ),
          );
  }

  void editDog() async {
    if (dogSize.isEmpty) {
      dogSize = widget.dogSize;
    }
    if (dogBreed.isEmpty) {
      dogBreed = widget.dogBreed;
    }
    if (dogName.isEmpty) {
      dogName = widget.dogName;
    }
    if (dogAge.isEmpty) {
      dogAge = widget.dogAge;
    }
    if (url.isEmpty) {
      url = widget.picUrl;
    }
    await db.collection('dog').document(widget.uid).updateData({
      'name': '$dogName',
      'breed': '$dogBreed',
      'age': '$dogAge',
      'size': '$dogSize',
      'pictureURL': '$url'
    });
  }

  void deleteDog() async {
    await db.collection('dog').document(widget.uid).delete();
  }

  void typeOfPic(BuildContext context) {
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
                  onTap: () {
                    goToLibrary();
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.photo_library),
                  title: Text('Choose from library'),
                ),
              ],
            ),
          );
        });
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
}
