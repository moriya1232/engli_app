import 'package:cloud_firestore/cloud_firestore.dart';

class UsersDatabase {
  final String uid;
  UsersDatabase({this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateData(String name) async {
    try {
      return await usersCollection.doc(uid).set({
        'name': name,
      });
    } catch (e) {
      print('PROBLEM!!!' + e.toString());
      return null;
    }

    return await usersCollection.doc(uid).set({
      'name': name,
    });
  }
}
