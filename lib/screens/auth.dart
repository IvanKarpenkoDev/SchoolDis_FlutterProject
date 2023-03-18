// ignore_for_file: unused_element

import 'package:firebase_auth/firebase_auth.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home.dart';

class Autorization extends StatefulWidget {
  const Autorization({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AutorizationState createState() => _AutorizationState();
}

class _AutorizationState extends State<Autorization> {
  // ignore: prefer_final_fields
  TextEditingController _emailController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _passwordController = TextEditingController();

  // ignore: unused_field
  late String _email;
  // ignore: unused_field
  late String _password;
  bool showLogin = true;
  bool signInChek = true;

  @override
  Widget build(BuildContext context) {
    Widget logo() {
      return Padding(
        padding: const EdgeInsets.only(top: 59),

        // ignore: avoid_unnecessary_containers
        child: Container(
          child: const Align(
            child: Text(
              'SchoolDis',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
        ),
      );
    }

    Widget textAuth(String h1) {
      return Padding(
        padding: const EdgeInsets.only(top: 60),
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Align(
            child: Text(
              h1,
              style: const TextStyle(fontSize: 30, color: Colors.blue),
            ),
          ),
        ),
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers
    Widget _input(Icon icon, String hint, TextEditingController controller,
        bool obsecure) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: TextFormField(
          controller: controller,
          obscureText: obsecure,
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  color: Colors.black54),
              hintText: hint,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.5)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 0.5)),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: IconTheme(
                  data: const IconThemeData(color: Colors.black),
                  child: icon,
                ),
              )),
        ),
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers, use_function_type_syntax_for_parameters
    Widget _button(String text, void func()) {
      return ElevatedButton(
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w300, color: Colors.white, fontSize: 19),
        ),
        onPressed: () async {
          // showLogin showLogin проверка метода авторизации или регистраци

          try {
            showLogin
                ? await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text)
                : await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text);

            if (showLogin == true) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }
          } on FirebaseException catch (e) {
            final snackBar = SnackBar(
                content: const Text("Ошибка авторизации"),
                backgroundColor: (Colors.black26),
                action: SnackBarAction(
                  label: 'dismiss',
                  onPressed: () {},
                ));

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          func();
          if (signInChek) {
          } else {}
        },
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers
    Widget _bottomWave() {
      return Expanded(
        child: Align(
          // ignore: sort_child_properties_last
          child: ClipPath(
            // ignore: sort_child_properties_last
            child: Container(
              color: Colors.blue,
              height: 500,
            ),
            clipper: BottomWaveClipper(),
          ),
          alignment: Alignment.bottomCenter,
        ),
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers
    Widget _topWave() {
      return Expanded(
        child: Align(
            // ignore: sort_child_properties_last
            child: ClipPath(
              // ignore: sort_child_properties_last
              child: Container(
                color: Colors.blue,
                height: 500,
              ),
              clipper: TopWaveClipper(),
            ),
            alignment: Alignment.topCenter),
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers, use_function_type_syntax_for_parameters
    Widget _form(String label, void func()) {
      // ignore: avoid_unnecessary_containers
      return Container(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 90),
            child: _input(
                const Icon(Icons.email), "Email", _emailController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 85),
            child: _input(const Icon(Icons.password_rounded), "Password",
                _passwordController, true),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            // ignore: sized_box_for_whitespace
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _button(label, func),
            ),
          )
        ]),
      );
    }

    void buttonAction() {
      _email = _emailController.text;
      _password = _passwordController.text;

      _emailController.clear();
      _passwordController.clear();
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(216, 238, 255, 1),
      body: Column(
        children: <Widget>[
          // _topWave(),
          logo(),

          // ignore: prefer_const_constructors
          SizedBox(
            height: 20,
          ),
          showLogin
              ? Column(
                  children: <Widget>[
                    textAuth('Авторизация'),
                    _form('Вход', buttonAction),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: GestureDetector(
                          child: const Text(
                            'Не зарегистрированы? \n \t \t \t  \t Регистрация',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                          onTap: () {
                            setState(() {
                              showLogin = false;
                            });
                          }),
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    textAuth('Регистрация'),
                    _form('Регистрация', buttonAction),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: const Text(
                          'Уже зарегистрированы? Вход',
                          style: TextStyle(fontSize: 17, color: Colors.blue),
                        ),
                        onTap: () {
                          setState(() {
                            showLogin = true;
                          });
                        },
                      ),
                    )
                  ],
                ),

          _bottomWave()
        ],
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var firstControlPoint = new Offset(size.width / 7.5, size.height - 28);
    var firstEndPoint = new Offset(size.width / 9, size.height / 1.48);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width / 3, size.height / 3);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    var thirdControlPoint =
        Offset(size.width - (size.width / 5), size.height / 20);
    var thirdEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
