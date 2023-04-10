import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:motion_toast/motion_toast.dart';

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

Widget _input(String hint, TextEditingController controller,int maxL, int minL) {
  return Container(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: controller,
       maxLines: maxL, // <-- SEE HERE
      minLines: minL,
      //style: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w300, fontSize: 20, //color: Colors.black54
        ),
        //hintText: hint,
        labelText: hint,
        labelStyle: TextStyle(fontSize: 19),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.5)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 0.5)),
      ),
    ),
  );
}

class _Curse_addState extends State<Curse_add> {
  bool isLoad = false;

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
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              iconSize: 35,
              tooltip: 'Профиль',
              onPressed: () {
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('Тут будет профиль')));
                MotionToast.success(
                  title: Text("Success Motion Toast"),
                  description: Text("Example of success motion toast"),
                ).show(context);
              },
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 50,
              ), //apply padding to all four sides
              child: Text("Добавление курса", style: TextStyle(fontSize: 23)),
            ),
            // Text("Добавление курса", style: TextStyle(fontSize: 23),),
            _input("Название курса", _name,3,1),
            _input("Описание", _description,6,2),
            isLoad
                ? CircularProgressIndicator()
                : Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoad = true;
                        });
                        FirebaseFirestore.instance.collection('Curss').add({
                          "Description": _description.text,
                          "Name": _name.text,
                          "prepod":
                              "/user/${FirebaseAuth.instance.currentUser?.uid}"
                        }).then((value) {
                          Future.delayed(Duration(seconds: 2));
                          Navigator.pop(context);
                          MotionToast.success(
                            description: Text("Курс был успешно добавлен"),
                          ).show(context);
                          value.collection("/card_curs");

                        });
                        buttonAction();
                      },
                      child: Container(
                        height: 55,
                        width: 190,
                        child: Center(
                          child: Text(
                            'Добавить',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        primary: Colors.blue,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
