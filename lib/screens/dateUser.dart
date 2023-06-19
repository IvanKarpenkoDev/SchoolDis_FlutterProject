import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

final CollectionReference profileCollection =
    FirebaseFirestore.instance.collection('Profile');

class _MyPageState extends State<MyPage> {
  bool toggleValue = false;

  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SchoolDis'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "ФИО",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Text(
              "Выберите роль: ",
              style: TextStyle(fontSize: 18),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Teacher"),
                CupertinoSwitch(
                  value: toggleValue,
                  onChanged: (bool value) {
                    setState(() {
                      toggleValue = value;
                    });
                  },
                ),
                Text("Student"),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (toggleValue == false) {
                  profileCollection.doc().set({
                    'name': nameController.text,
                    'role': 1,
                    'uid': "/user/${FirebaseAuth.instance.currentUser?.uid}",
                  });
                } else {
                  profileCollection.doc().set({
                    'name':  nameController.text,
                    'role': 2,
                    'uid': "/user/${FirebaseAuth.instance.currentUser?.uid}",
                  });
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
