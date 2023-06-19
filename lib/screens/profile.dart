import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';
import 'curse_add.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}
// final FirebaseFirestore firestore = FirebaseFirestore.instance;

// final CollectionReference fioCollection = firestore.collection('profile');

class _ProfileState extends State<Profile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _fio = TextEditingController();
  final _email = TextEditingController();
  final _class = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    

    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final TextEditingController _fioController = TextEditingController();

// Получение UID текущего пользователя.
    final String? uid = auth.currentUser?.uid;

// Получение ссылки на документ пользователя в коллекции "users".
    final DocumentReference userDocRef =
        firestore.collection('Profile').doc(uid);
        

// Получение данных пользователя из документа.
final userDocSnapshot = await userDocRef.get();
final userData = userDocSnapshot.data();

// // Получение ФИО текущего пользователя из данных пользователя.
// final String currentUserFio = userData['name'];
   

// Установка ФИО текущего пользователя в качестве значения по умолчанию для виджета TextField.
  //   // _fioController.text = currentUserFio;
  //     Widget _qwe() {
  //   return TextField(
  //     controller: _fioController,
  //     decoration: InputDecoration(
  //       labelText: 'ФИО',
  //       hintText: 'Введите ФИО',
  //     ),
  //   );
  // }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Text('Это вылезающее меню'),
          padding: EdgeInsets.all(16.0),
        );
      },
    );
  }



  Widget _input(
    Icon icon,
    String hint,
    TextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        controller: controller,
        // style: const TextStyle(fontSize: 20, color: Colors.black),
        decoration: InputDecoration(
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
              //color: Colors.black54
            ),
            // hintText: hint,
            labelText: hint,
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

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    TextEditingController _fio = TextEditingController();
    TextEditingController _email = TextEditingController();
    // ignore: prefer_final_fields
    TextEditingController _class = TextEditingController();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 270,
        title: const Icon(Icons.account_circle_outlined, size: 180.0),
        titleTextStyle: TextStyle(fontSize: 18, letterSpacing: 1),
        leading: IconButton(
          padding: EdgeInsets.only(top: 180),
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(82, 179, 253, 1),
                image: DecorationImage(
                  image: AssetImage(
                      '/Users/ivan/Documents/FlutterTest/flutter_application_1/bg.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                'Schooldis',
                style: TextStyle(fontSize: 24, letterSpacing: 2),
              ),
              padding: EdgeInsets.only(top: 30, left: 20),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text(' Профиль '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: const Text(' Курсы '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text(' Настройки '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text(' Выход '),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Autorization()),
                  (t) => false,
                );
              },
            ),
          ],
        ),
      ),
      // backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: 50, top: 30), //apply padding to all four sides
              child: Text("Профиль", style: TextStyle(fontSize: 23)),
            ),
            _input(Icon(Icons.account_circle_outlined), "ФИО", _fio),
            _input(Icon(Icons.email_outlined), "Email", _email),
            _input(Icon(Icons.class_outlined), "Класс", _class),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () async {
                  buttonAction();
                },
                child: Container(
                  height: 55,
                  width: 190,
                  child: Center(
                    child: Text(
                      'Сохранить',
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
