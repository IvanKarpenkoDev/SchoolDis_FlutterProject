import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _fioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUserFio();
  }

  Future<void> _loadCurrentUserFio() async {
    // Получение UID текущего пользователя.

    final User? user = auth.currentUser;
    final String? uid = user?.uid;
    // Получение ссылки на документ пользователя в коллекции "users".
    final DocumentReference userDocRef = firestore.collection('Proifle').doc(uid);

    // Получение данных пользователя из документа.
    final userDocSnapshot = await userDocRef.get();
    final userData = userDocSnapshot.data();

    // Получение ФИО текущего пользователя из данных пользователя.
final String currentUserFio = (userData as Map<String, dynamic>)['name'] ?? '';


    // Установка ФИО текущего пользователя в качестве значения по умолчанию для виджета TextField.
    _fioController.text = currentUserFio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мой профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ФИО',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _fioController,
              decoration: InputDecoration(
                labelText: 'ФИО',
                hintText: 'Введите ФИО',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
