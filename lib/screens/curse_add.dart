import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:motion_toast/motion_toast.dart';

import '../domain/customButton.dart';

class Curse_add extends StatefulWidget {
  const Curse_add({super.key});
  // final String _selectedImage = '';

  @override
  State<Curse_add> createState() => _Curse_addState();
}

late String _email;
// ignore: unused_fields
late String _password;
int a = 0;
late String _selectedImage = '';

List<String> images = [
  'assets/images/bg1.jpeg',
  'assets/images/bg2.jpeg',
  'assets/images/bg3.jpeg',
  'assets/images/bg4.jpeg',
  'assets/images/bg5.jpeg',
  'assets/images/bg6.jpeg',
  'assets/images/bg7.jpeg',
  'assets/images/bg8.jpeg',
  'assets/images/bg9.jpeg'
];

// Присваивание переменной image случайного значения из списка

TextEditingController _name = TextEditingController();
// ignore: prefer_final_fields
TextEditingController _description = TextEditingController();

void buttonAction() {
  _email = _name.text;
  _password = _description.text;

  _name.clear();
  _description.clear();
}

Widget _input(
    String hint, TextEditingController controller, int maxL, int minL) {
  return Container(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: controller,
      maxLines: maxL, // <-- SEE HERE
      minLines: minL,
      //style: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
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
  late final String currentImage1;

  void chooseRandomImage() {
    if (images.length == 1) {
      // если в списке осталось только одно изображение, перезаполним список
      images = [
        'assets/images/bg1.jpeg',
        'assets/images/bg2.jpeg',
        'assets/images/bg3.jpeg',
        'assets/images/bg4.jpeg',
        'assets/images/bg5.jpeg',
        'assets/images/bg6.jpeg',
        'assets/images/bg7.jpeg',
        'assets/images/bg8.jpeg',
        'assets/images/bg9.jpeg'
      ];
    }

    // выберем случайное изображение из списка и удалим его из списка
    final random = Random();
    final index = random.nextInt(images.length);
    currentImage1 = images[index];
    images.removeAt(index);

    setState(() {}); // обновим состояние приложения
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 50,
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
            _input("Название курса", _name, 3, 1),
            _input("Описание", _description, 6, 2),

            isLoad
                ? CircularProgressIndicator()
                : Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoad = true;
                        });

                        chooseRandomImage();

                        if (_name.text.isNotEmpty &&
                            _description.text.isNotEmpty) {
                          FirebaseFirestore.instance.collection('Curss').add({
                            "Description": _description.text,
                            "Name": _name.text,
                            "prepod": FirebaseAuth.instance.currentUser?.uid,
                            "image": currentImage1,
                            "students": null
                          }).then((value) {
                            Future.delayed(Duration(seconds: 2));
                            Navigator.pop(context);
                            MotionToast.success(
                              description: Text("Курс был успешно добавлен"),
                            ).show(context);
                            value.collection("/card_curss");
                          });
                        }
                        else{
                          Future.delayed(Duration(seconds: 2));
                            Navigator.pop(context);
                            MotionToast.error(
                              description: Text("Поля не должны быть пусты"),
                            ).show(context);
                        }
                        buttonAction();
                      },
                      // ignore: sized_box_for_whitespace, sort_child_properties_last
                      child: Container(
                        height: 55,
                        width: 190,
                        child: const Center(
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
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
