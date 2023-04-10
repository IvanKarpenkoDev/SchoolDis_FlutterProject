import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "SchoolDis",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
        ),
       
      ),
    );
  }
}
