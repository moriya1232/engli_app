import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //stream to know if user login/logout
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      await user.updateProfile(
          displayName: "guest_" + user.uid.substring(0, 3), photoURL: null);
      return user;
    } catch (e) {
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(
      String email, String pass, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User user = result.user;
      await user.updateProfile(displayName: name);
      return user;
    } catch (e) {
      return null;
    }
  }

//sign in with mail and password
  Future signInWithEmailAndPassword(String email, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
