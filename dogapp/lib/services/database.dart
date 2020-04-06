import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('usersDogApp');

  Future updateUserData(int dogCount, String dogID) async{
    return await userCollection.document(uid).setData({
      'dogCount': dogCount,
      'dogID': dogID,
    });
  }

}