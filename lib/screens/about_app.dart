import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 90)),
            Text(
              "SchoolDis",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
              
            ),
            Padding(padding: EdgeInsets.only(top: 50)),
            Text("data")
          ],
        ),
      ),
    );
  }
}
