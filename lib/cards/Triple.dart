import 'package:flutter/cupertino.dart';

class Triple {
  final String _english;
  final String _hebrew;
  Image _image;

  Triple(String en, String he, String im) : this._english = en, this._hebrew = he{
//    if (im == null || im == "") {
//      this._image = Image(
//        image: AssetImage("images/logo.jpg"),
//      );
//    } else {
//      this._image = Image(
//        image: AssetImage(im),
//      );
//    }
  try {
    this._image = Image(image: AssetImage(im));
  } catch (e) {
    this._image = Image(image: AssetImage("images/logo.jpg"));
  }
    print("IMAGE:");
    print(im);
    print(this._image.toString());
  }

  String get hebrew => _hebrew;
  String get english => _english;
  Image get image => _image;
}
