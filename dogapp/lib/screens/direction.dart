import 'package:dogapp/models/user.dart';
import 'package:dogapp/screens/home/home.dart';
import 'package:dogapp/screens/register/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Direction extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    if(user == null){
      return Authenticate();
    }else{
      return Home(uid: user.email,);
    }

  }
}
