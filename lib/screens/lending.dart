import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:flutter_application_1/screens/home.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggenIn = false;

    return isLoggenIn ? HomePage() : Autorization();

  }
}