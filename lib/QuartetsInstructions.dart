import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuartetsInstructions extends StatefulWidget {
  @override
  _QuartetsInstructionsState createState() => _QuartetsInstructionsState();
}

class _QuartetsInstructionsState extends State<QuartetsInstructions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('הוראות רביעיות'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
//          child: Flexible(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                getInstructionsString(),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Comix-h',
                  fontSize: 30,
                ),
              ),
            ),
//          ),
        ),
      ),
    );
  }

  String getInstructionsString() {
    String string =
        'כל משתתף מחזיק בתחילת המשחק ארבעה קלפים, ויתר הקלפים מונחים כקופה כאשר פניהם כלפי מטה. \n כל שחקן בתורו שואל שחקן אחר (לבחירתו) האם יש לו סדרת רבעיות מסוימת.\n במידה והתשובה חיובית, השחקן יוכל לשאול על קלף ספציפי ברביעייה זו.\n במידה ויש ליריב את הקלף המבוקש השחקן יזכה בתור נוסף. \n אם התשובה שלילית לגבי סדרת רביעיה מסוימת, על  השואל לקחת קלף מן הקופה והתור עובר לשחקן הבא. \n כאשר משתתף צובר את כל ארבעת הקלפים של רביעייה מסוימת – הוא זוכה בעשר נקודות ומשחק תור נוסף. \n\n המשחק נגמר כאשר כל הרביעיות התגלו. \n המנצח הוא המשתתף שצבר את מספר הנקודות הרב ביותר.\n\n תהנו!';
    return string;
  }
}
