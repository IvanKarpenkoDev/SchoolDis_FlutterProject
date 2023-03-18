import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home.dart';

class Curse_add extends StatefulWidget {
  const Curse_add({super.key});

  @override
  State<Curse_add> createState() => _Curse_addState();
}

late String _email;
// ignore: unused_field
late String _password;

TextEditingController _name = TextEditingController();
// ignore: prefer_final_fields
TextEditingController _description = TextEditingController();

void buttonAction() {
  _email = _name.text;
  _password = _description.text;

  _name.clear();
  _description.clear();
}

Widget _input(String hint, TextEditingController controller) {
  return Container(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w300, fontSize: 20, color: Colors.black54),
        hintText: hint,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.5)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 0.5)),
      ),
    ),
  );
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween( end: end,begin: begin).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class _Curse_addState extends State<Curse_add> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Color.fromRGBO(82, 179, 253, 1),
          titleTextStyle: TextStyle(fontSize: 18, letterSpacing: 1),
          title: Text('Schooldis'),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              iconSize: 35,
              tooltip: 'Профиль',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Тут будет профиль')));
              },
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          children: [
            _input("Название курса", _name),
            _input("Описание", _description),
            ElevatedButton(
              onPressed: () async {
                FirebaseFirestore.instance.collection('Curss').add({
                  "Description": _description.text,
                  "Name": _name.text,
                  "prepod": "/user/${FirebaseAuth.instance.currentUser?.uid}"
                }).then((value) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Курс добавлен')));
                });
                buttonAction();
              },
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}
