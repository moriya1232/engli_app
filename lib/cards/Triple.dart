import 'package:flutter/cupertino.dart';

class Triple {
  String english;
  String hebrew;
  Image image;

  Triple(String en, String he, String im) {
    this.english = en;
    this.hebrew = he;
    if (im == null || im == "")
      this.image = null;
    else {
      this.image = Image(
        image: AssetImage(im),
      );
    }
  }
}
