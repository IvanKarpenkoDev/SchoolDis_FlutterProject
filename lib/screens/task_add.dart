import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class Task_add extends StatefulWidget {
  const Task_add({super.key, required this.idCurs});
  final String idCurs;
  @override
  State<Task_add> createState() => _Task_addState(idCurs);
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

Widget _label(String curseUid) {
  return Container(
    padding: const EdgeInsets.only(bottom: 20),
    child: Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 0.5),
      ),
      child: Center(
        child: Text(
          curseUid,
          style: TextStyle(fontSize: 18),
        ),
      ),
    ),
  );
}

Widget _input(String hint, TextEditingController controller) {
  return Container(
    padding: const EdgeInsets.only(bottom: 20, top: 10),
    child: TextFormField(
      maxLines: 10, // <-- SEE HERE
      minLines: 2,
      controller: controller,
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

class _Task_addState extends State<Task_add> {
  final String idCurs;
  _Task_addState(this.idCurs);

  bool isLoad = false;
  File? _selectedFile;
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
                child:
                    Text("Добавление задания", style: TextStyle(fontSize: 23)),
              ),
              // Text("Добавление курса", style: TextStyle(fontSize: 23),),
              _input("Задание", _name),

              isLoad
                  ? CircularProgressIndicator()
                  : 
            
              ElevatedButton(
                onPressed: () async {
                  // Открываем диалоговое окно для выбора файла
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      _selectedFile = File(result.files.single.path!);
                    });
                    MotionToast.success(
                      description: Text("Файл был успешно выбран"),
                    ).show(context);
                  }
                },
                child: Container(
                  height: 40,
                  width: 140,
                  child: const Center(
                    child: Text(
                      'Выбрать файл',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  // primary: Colors.blue,
                ),
              ),
                SizedBox(height: 20),
              ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoad = true;
                        });
                        FirebaseFirestore.instance
                            .collection('Curss')
                            .doc(idCurs)
                            .collection("card_curss")
                            .add({
                          "Name": _name.text,
                          "prepod":
                              "/user/${FirebaseAuth.instance.currentUser?.uid}",
                          "file_url": _selectedFile != null
                              ? _selectedFile!.path
                              : null,
                        }).then((value) {
                          Future.delayed(Duration(seconds: 2));
                          Navigator.pop(context);
                          MotionToast.success(
                            description: Text("Курс был успешно добавлен"),
                          ).show(context);
                        });
                        buttonAction();
                      },
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
                        // primary: Colors.blue,
                      ),
                    ),
            ],
          ),
        ));
  }
}
