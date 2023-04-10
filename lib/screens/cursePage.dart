import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:flutter_application_1/screens/curse_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/screens/settingsScreen.dart';
import 'package:flutter_application_1/screens/task_add.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';

import '../domain/class.dart';
import 'home.dart';

class CursePage extends StatelessWidget {
  const CursePage({super.key, required this.idCurs});

  final String idCurs;

  //signout function

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color.fromRGBO(82, 179, 253, 1),
        titleTextStyle: TextStyle(fontSize: 18, letterSpacing: 1),
        title: Text('Schooldis'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            iconSize: 35,
            tooltip: 'Профиль',
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: const Text(' Курсы '),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text(' Настройки '),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage1()));
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

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          (await (FirebaseFirestore.instance.collection("Curss").doc(idCurs))
              .collection('card_curss')
              .snapshots());

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Task_add()),
          );
        },
        child: Icon(Icons.add),
      ),

      // backgroundColor: Theme.of(context).primaryColor,
      body: ClassList(idCurs),
    );
  }

  Widget logo() {
    return Padding(
      padding: EdgeInsets.only(top: 59),
      child: Container(
        child: const Align(
          child: Text(
            'SchoolDis',
            style: TextStyle(
                fontSize: 15, color: Color.fromARGB(255, 217, 217, 217)),
          ),
        ),
      ),
    );
  }
}

Widget _label(String curseUid) {
  return Container(
    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
    child: Container(
      height: 155,
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

class ClassList extends StatelessWidget {
  final String idCurs;
  ClassList(this.idCurs);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Curss')
            .doc(idCurs)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Container(
                child: Card(
                  color: Color.fromRGBO(243, 135, 28, 1),
                  elevation: 6.0,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SizedBox(
                    height: 140,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Text(
                          snapshot.data?['Name'],
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                shadowColor: Colors.black,
                child: const SizedBox(
                  child: Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 30),
                        child: Text(
                          //snapshot.data?.docs[i].data()['Name'],
                          "sdf",
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

Future confirmDialog(BuildContext context, String uuid) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Подтвердите удаление'),
        titlePadding: EdgeInsets.only(top: 30, left: 15, bottom: 50),
        actions: <Widget>[
          TextButton(
            child: Text('Отменить'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 17),
            ),
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => CursePage()));
            },
          ),
          TextButton(
            child: Text(
              'Удалить',
              style: TextStyle(fontSize: 17),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('Curss')
                  .doc(uuid)
                  .delete()
                  .then(
                    (doc) => print("Document deleted"),
                    onError: (e) => print("Error updating document $e"),
                  );
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
