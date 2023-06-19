import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final CollectionReference curseStudentCollection = FirebaseFirestore.instance.collection('Curss');
final TextEditingController _idCourseController = TextEditingController();

class JoinCoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schooldis'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Присоединиться к курсу',
              style: TextStyle(fontSize: 24),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: _idCourseController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Введите ссылку курса',
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final courseDocRef = curseStudentCollection.doc(_idCourseController.text);
                courseDocRef.update({
                  'students': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
                });
                _idCourseController.clear();
                // Add your logic for joining the course here
              },
              child: const SizedBox(
                width: 150,
                height: 50,
                child: Text("Присоединиться"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
