import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Registertion extends StatefulWidget{
  @override
  _RegistarationState createState() => _RegistarationState();
}

class _RegistarationState extends State<Registertion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('הרשמה'),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column (
                    children: <Widget>[
                      Row(
                        children: <Widget> [
                          Text('First Name: '),
                          new Flexible( child: TextField())
                        ],
                      ),
                      Row(
                        children: <Widget> [
                          Text('Last Name: '),
                          new Flexible( child: TextField())
                        ],
                      ),
                      Row(
                        children: <Widget> [
                          Text('Mail Address:'),
                          new Flexible( child: TextField())
                        ],
                      ),
                      Row(
                        children: <Widget> [
                          Text('Username: '),
                          new Flexible( child: TextField())
                        ],
                      ),
                      Row(
                        children: <Widget> [
                          Text('Password:'),
                          new Flexible( child: TextField())
                        ],
                      ),
                    ])
            )
        )
    );
  }
}

