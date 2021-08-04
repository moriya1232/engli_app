import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //stream to know if memeber login/logout
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      print("IM HERE!!!!");
      //TODO: BUG: if I logout and after that login as anonymous user - name get NULL
      await user.updateProfile(
          displayName: "GUEST_" + user.uid.substring(0, 3), photoURL: null);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(
      String email, String pass, String name) async {
    try {
      print("Name:" + name);
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User user = result.user;
      await user.updateProfile(displayName: name);
      print(_auth.currentUser.displayName);
      //create new a document for the user
      // await UsersDatabase(uid: user.uid).updateData(name);
      return user;
    } catch (e) {
      print(e.toString());
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
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
