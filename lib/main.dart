import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/lending.dart';
import 'domain/class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaxFitApp());
}

class MaxFitApp extends StatelessWidget {
  bool isAuth = false;

  @override
  void initState() {
    isAuth = FirebaseAuth.instance.currentUser == null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classroom',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(255, 255, 255, 1),
        textTheme: TextTheme(titleSmall: TextStyle(color: Colors.white)),
      ),
      home: isAuth ? Autorization() : HomePage(),
    );
  }
}
