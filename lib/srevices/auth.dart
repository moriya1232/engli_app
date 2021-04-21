import 'package:engli_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
//creat new user that based om the firebase user
  MyUser _createUser(User user) {
    if (user != null) {
      return MyUser(uniqeID: user.uid);
    } else {
      return null;
    }
  }

  //stream to know if memeber login/logout
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
