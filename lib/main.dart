import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/lending.dart';
import 'package:get/get.dart';
import 'domain/class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaxFitApp());
}

class MaxFitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Classroom',
      darkTheme: ThemeData.dark().copyWith(textTheme: TextTheme()),
      theme: ThemeData.light(),
      home: FirebaseAuth.instance.currentUser == null
          ? Autorization()
          : HomePage(),
    );
  }
}
