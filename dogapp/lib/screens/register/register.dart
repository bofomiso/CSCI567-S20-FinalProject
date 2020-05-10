import 'package:dogapp/services/auth.dart';
import 'package:dogapp/shared/constants.dart';
import 'package:dogapp/shared/loading.dart';
import 'package:flutter/material.dart';


class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthServices _auth  = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Sign up to DogWalker"),
        actions: <Widget>[
          FlatButton.icon(onPressed: (){
            widget.toggleView();
          },
              icon: Icon(Icons.person),
              label: Text("Sign in"))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Email',
                ),
                validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Password',
                ),
                validator: (val) => val.length < 6 ? 'Password must be six or more characters long' : null,
                obscureText: true,
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _auth.registerWithEmailAndPassword(email,password);
                    if(result == null ){
                      setState(() {
                        error = 'Please supply a valid email';
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 20.0,),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
