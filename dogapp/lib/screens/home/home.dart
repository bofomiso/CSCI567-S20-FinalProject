import 'package:dogapp/screens/newdog.dart';
import 'package:dogapp/screens/park.dart';
import 'package:dogapp/screens/profile.dart';
import 'package:dogapp/screens/choosedog.dart';
import 'package:dogapp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../chooselog.dart';

class Home extends StatefulWidget {
  final String uid;

  const Home({Key key, this.uid}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text("Logout"))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 130.0,
              child: UserAccountsDrawerHeader(
                accountName: Text(''),
                accountEmail: Text(
                  widget.uid,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Home'),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new Home(
                                uid: widget.uid,
                              )));
                },
              ),
            ),
            Card(
              child: ListTile(
                  title: Text('Profile'),
                  leading: Icon(Icons.person),
                  onTap: () {
                    userIdFunction(context);
                  }),
            ),
            Card(
              child: ListTile(
                  title: Text('Find Parks'),
                  leading: Icon(Icons.map),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MapSample()));
                  }),
            ),
            Card(
              child: ListTile(
                  title: Text('Play'),
                  leading: Icon(Icons.mood),
                  onTap: () {
                    chooseId(context);
                  }),
            ),
            Card(
              child: ListTile(
                  title: Text('Logs'),
                  leading: Icon(Icons.library_books),
                  onTap: () {
                    chooseLogId(context);
                  }),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  'assets/dog.png',
                  height: 150,
                  width: 150,
                ),
                Text('Already have a dog? Time his play session!'),
                Text('Add your dog if you havent!'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ButtonBar(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.green,
                          onPressed: () {
                            newDogActionBar(context);
                          },
                          child: Text('Add'),
                        ),
                        RaisedButton(
                          color: Colors.blueAccent,
                          onPressed: () {
                            gotoPlay(context);
                          },
                          child: Text('Play'),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //child: Image.asset('assets/dog.png'),

  void userIdFunction(context) async {
    final FirebaseUser user = await _auth.getUser();
    final uid = user.uid;
    Navigator.of(context).pop();
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new Profile(uid: uid)));
  }

  void chooseId(context) async {
    final FirebaseUser user = await _auth.getUser();
    final uid = user.uid;
    Navigator.of(context).pop();
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new Choose(uid: uid)));
  }

  void newDogActionBar(context) async {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) => new NewDog()));
  }

  void gotoPlay(context) async {
    final FirebaseUser user = await _auth.getUser();
    final uid = user.uid;
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new Choose(uid: uid)));
  }

  void chooseLogId(context) async {
    final FirebaseUser user = await _auth.getUser();
    final uid = user.uid;
    Navigator.of(context).pop();
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new ChooseLog(uid: uid)));
  }
}
