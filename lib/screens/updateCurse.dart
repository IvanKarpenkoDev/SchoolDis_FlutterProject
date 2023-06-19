import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:motion_toast/motion_toast.dart';

abstract class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  CustomButton({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child:  SizedBox(
        height: 55,
        width: 190,
        child: Center(
          child: Text(
            buttonText,
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
    );
  }
}

class CurseUpdateButton extends CustomButton {
  CurseUpdateButton({required VoidCallback onPressed})
      : super(buttonText: 'Изменить', onPressed: onPressed);
}

class Curse_Update extends StatefulWidget {
  const Curse_Update({Key? key, required this.idCurs1});

  final String idCurs1;

  @override
  State<Curse_Update> createState() => _Curse_UpdateState(idCurs1);
}

class _Curse_UpdateState extends State<Curse_Update> {
  bool isLoad = false;
  late final String currentImage1;
  late final String idCurs;
  late TextEditingController _name;
  late TextEditingController _description;

  _Curse_UpdateState(this.idCurs);

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _description = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void buttonAction() {
    _name.text = '';
    _description.text = '';
  }

  Widget _input(String hint, TextEditingController controller, int maxL, int minL) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxL,
        minLines: minL,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w300, fontSize: 20,
          ),
          labelText: hint,
          labelStyle: const TextStyle(fontSize: 19),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 0.5),
          ),
        ),
      ),
    );
  }

  void _updateCourse() async {
    setState(() {
      isLoad = true;
    });

    if (_name.text.isNotEmpty && _description.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('Curss')
          .doc(idCurs)
          .update({
        "Description": _description.text,
        "Name": _name.text,
      })
          .then((value) {
        return Future.delayed(Duration(seconds: 2));
      })
          .then((_) {
        Navigator.pop(context);
        MotionToast.success(
          description: const Text("Курс был успешно изменен"),
        ).show(context);
      });
    } else {
      return Future.delayed(Duration(seconds: 2))
          .then((_) {
        Navigator.pop(context);
        MotionToast.error(
          description: const Text("Поля не должны быть пусты"),
        ).show(context);
      });
    }

    buttonAction();
  }

  @override
  Widget build(BuildContext context) {
    final titleText = Text("Добавление курса", style: TextStyle(fontSize: 23));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        titleTextStyle: TextStyle(fontSize: 18, letterSpacing: 1),
        title: const Text('Schooldis'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            iconSize: 35,
            tooltip: 'Профиль',
            onPressed: () {
              MotionToast.success(
                title: const Text("Success Motion Toast"),
                description: const Text("Example of success motion toast"),
              ).show(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: titleText,
            ),
            _input("Название курса", _name, 3, 1),
            _input("Описание", _description, 6, 2),
            isLoad
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: CurseUpdateButton(
                      onPressed: _updateCourse,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
