import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:flutter_application_1/screens/cursePage.dart';
import 'package:flutter_application_1/screens/curse_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/screens/settingsScreen.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';

import '../domain/class.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Curse_add()),
          );
        },
        child: Icon(Icons.add),
      ),
      // backgroundColor: Theme.of(context).primaryColor,
      body: ClassList(),
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

class ClassList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Curss').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ignore: avoid_unnecessary_containers
          return Container(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, i) {
                    return Stack(
                      children: [
                        Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            confirmDialog(
                                context,
                                snapshot.data!.docs[i]
                                    .id); // Handle the left swipe event here
                          },
                          background: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Icon(
                                  Icons.delete,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              )),
                          child: Card(
                            elevation: 5.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CursePage(
                                              idCurs:
                                                  (snapshot.data?.docs[i].id)!,
                                            )));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 30),
                                      title: Text(
                                        snapshot.data?.docs[i].data()['Name'],
                                        style: const TextStyle(
                                          fontSize: 23,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        snapshot.data?.docs[i]
                                            .data()['Description'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            color: const Color.fromRGBO(84, 84, 84, 1),
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              confirmDialog(context, snapshot.data!.docs[i].id);
                            },
                          ),
                        ),
                      ],
                    );
                  }),
            ),
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
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
            onPressed: () async {
              final batch = FirebaseFirestore.instance.batch();
              final refCurss = await FirebaseFirestore.instance
                  .collection('Curss')
                  .doc(uuid);
              final refCardCurs = await FirebaseFirestore.instance
                  .collection('Curss')
                  .doc(uuid)
                  .collection('card_curss')
                  .get();

              batch.delete(refCurss);
              refCardCurs.docs.forEach((element) {
                batch.delete(element.reference);
              });

              batch.commit();

              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
