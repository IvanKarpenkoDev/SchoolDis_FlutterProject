import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:flutter_application_1/screens/connect_curss.dart';
import 'package:flutter_application_1/screens/cursePage.dart';
import 'package:flutter_application_1/screens/curse_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/favoritiesScreen.dart';
import 'package:flutter_application_1/screens/settingsScreen.dart';
import 'package:flutter_application_1/screens/updateCurse.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String?> getDocumentUid() async {
    final firestoreInstance = FirebaseFirestore.instance;
    final uidUser = FirebaseAuth.instance.currentUser?.uid;

    // Выполняем запрос к Firestore для получения документа, где поле 'uidUser' равно 'uid' текущего пользователя
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection('Profile')
        .where('uid', isEqualTo: uidUser)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Если документ найден, получаем его uid
      String documentUid = querySnapshot.docs[0].id;
      return documentUid;
    }

    return null; // Если документ не найден, возвращаем null
  }

  //signout function

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 50,
        titleTextStyle: const TextStyle(fontSize: 18, letterSpacing: 1),
        title: const Text('Schooldis'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bookmark_border_outlined),
            iconSize: 35,
            tooltip: 'Профиль',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()));
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
              padding: EdgeInsets.only(top: 30, left: 20),
              child: Text(
                'Schooldis',
                style: TextStyle(fontSize: 24, letterSpacing: 2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border_outlined),
              title: const Text(' Избранное '),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' Курсы '),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(' Настройки '),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage1()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
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
          final firestoreInstance = FirebaseFirestore.instance;
          String? documentUid = await getDocumentUid();

          final docRef =
              firestoreInstance.collection("Profile").doc(documentUid);
          // ignore: unused_local_variable
          final uidUser = FirebaseAuth.instance.currentUser?.uid;
          // ignore: unused_local_variable
          CollectionReference profiles =
              FirebaseFirestore.instance.collection('Profile');
          //  QuerySnapshot querySnapshot =  await profiles.where('uid', isEqualTo: uidUser).get();
          docRef.get().then((doc) {
            if (doc.exists) {
              if (doc.data()!["role"] == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Curse_add()),
                );
              } else if (doc.data()!["role"] == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinCoursePage()),
                );
              } else {
                print("object");
              }
            } else {}
          }).catchError((error) {
            // Обработать ошибку получения данных.
          });
        },
        child: const Icon(Icons.add),
      ),
      // backgroundColor: Theme.of(context).primaryColor,
      body: ClassList(),
    );
  }

  Widget logo() {
    return const Padding(
      padding: EdgeInsets.only(top: 59),
      child: SizedBox(
        child: Align(
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

// ignore: use_key_in_widget_constructors
class ClassList extends StatefulWidget {
  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  Map<String, bool> _favorites = {};
  final uidUser = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
    // load the initial values of _favorites from SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _favorites = Map<String, bool>.from(
          json.decode(prefs.getString('favorites') ?? '{}'),
        );
      });
    });
  }

  @override
  void dispose() {
    // save the current values of _favorites to SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('favorites', json.encode(_favorites));
    });
    super.dispose();
  }

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
          Future<int?> getRole() async {
            final uidUser1 = FirebaseAuth.instance.currentUser?.uid;
            final profile = Profiles(uid: uidUser1);

            int? role = await profile.getRole();
            return role;
          }

          return FutureBuilder<int?>(
              future: getRole(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final roleUser = snapshot.data;
                if (roleUser == 1) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Curss')
                          .where('prepod',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, i) {
                              final course = snapshot?.data?.docs[i];
                              final id = course!.id;
                              final name = (course?.data()
                                  as Map<String, dynamic>)['Name'];
                              final image = (course?.data()
                                  as Map<String, dynamic>)['image'];
                              final description = (course?.data()
                                  as Map<String, dynamic>)['Description'];

                              return Stack(
                                children: [
                                  Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      _showConfirmationAlert(context, id);
                                    },
                                    background: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: const Icon(
                                          Icons.delete,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    child: Card(
                                      elevation: 5.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CursePage(
                                                idCurs: id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(image),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration:
                                                    const BoxDecoration(),
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15,
                                                          vertical: 30),
                                                  title: Text(
                                                    (name),
                                                    style: const TextStyle(
                                                      fontSize: 23,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    (description),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  top: 10,
                                                  right: 10,
                                                  child:
                                                      PopupMenuButton<String>(
                                                    itemBuilder:
                                                        (BuildContext context) {
                                                      return [
                                                        const PopupMenuItem<
                                                            String>(
                                                          value: 'favorite',
                                                          child: SizedBox(
                                                              child: Text(
                                                            'В Избранное',
                                                          )),
                                                        ),
                                                        const PopupMenuItem<
                                                            String>(
                                                          value: 'delete',
                                                          child: SizedBox(
                                                            child: Text(
                                                              'Удалить',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                        ),
                                                        const PopupMenuItem<
                                                            String>(
                                                          value: 'update',
                                                          child: SizedBox(
                                                            child: Text(
                                                              'Изменить',
                                                              style: TextStyle(
                                                                ),
                                                            ),
                                                          ),
                                                        ),
                                                      ];
                                                    },
                                                    onSelected: (value) {
                                                      switch (value) {
                                                        case 'delete':
                                                          _showConfirmationAlert(
                                                              context,
                                                              course.id);
                                                          break;
                                                        case 'favorite':
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'favorites')
                                                              .doc(course.id)
                                                              .set(course.data()
                                                                  as Map<String,
                                                                      dynamic>);
                                                          break;
                                                        case 'update':
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Curse_Update(idCurs1: id,)));
                                                          break;
                                                      }
                                                    },
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      });
                } else {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Curss')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        final currentUserUID =
                            FirebaseAuth.instance.currentUser?.uid;
                        final courses = snapshot.data?.docs;
                        final userCourses = courses
                            ?.where((course) =>
                                (course.data()
                                        as Map<String, dynamic>)['students']
                                    ?.contains(currentUserUID) ??
                                false)
                            ?.toList();

                        return ListView.builder(
                            itemCount: userCourses?.length,
                            itemBuilder: (context, index) {
                              final course = userCourses![index];
                              final isFavorite = _favorites[course.id] ?? false;

                              return Stack(
                                children: [
                                  Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      _showConfirmationAlert(
                                          context, course.id);
                                    },
                                    background: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: const Icon(
                                          Icons.delete,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    child: Card(
                                      elevation: 5.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CursePage(
                                                idCurs: course.id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage((course.data()
                                                      as Map<String, dynamic>)[
                                                  'image']),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration:
                                                    const BoxDecoration(),
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15,
                                                          vertical: 30),
                                                  title: Text(
                                                    (course.data() as Map<
                                                        String,
                                                        dynamic>)['Name'],
                                                    style: const TextStyle(
                                                      fontSize: 23,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    (course.data() as Map<
                                                            String, dynamic>)[
                                                        'Description'],
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
                                  ),
                                  Positioned(
                                      top: 10,
                                      right: 10,
                                      child: PopupMenuButton<String>(
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            const PopupMenuItem<String>(
                                              value: 'favorite',
                                              child: SizedBox(
                                                  child: Text(
                                                'В Избранное',
                                              )),
                                            ),
                                          
                                          ];
                                        },
                                        onSelected: (value) {
                                          switch (value) {
                                           
                                            case 'favorite':
                                              FirebaseFirestore.instance
                                                  .collection('favorites')
                                                  .doc(course.id)
                                                  .set(course.data()
                                                      as Map<String, dynamic>);
                                              break;
                                          }
                                        },
                                      ))
                                ],
                              );
                            });
                      });
                }
              });
        });
  }
}

_showConfirmationAlert(BuildContext context, String uuid) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: const Text("Вы действильно хотите удалить?"),
      content: const Text("Подтвердите удаление"),
      actions: <Widget>[
        BasicDialogAction(
          title: const Text("Отменить"),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        BasicDialogAction(
          title: const Text("Принять"),
          onPressed: () async {
            final batch = FirebaseFirestore.instance.batch();
            final refCurss =
                await FirebaseFirestore.instance.collection('Curss').doc(uuid);
            final refCardCurs = await FirebaseFirestore.instance
                .collection('Curss')
                .doc(uuid)
                .collection('card_curss')
                .get();

            batch.delete(refCurss);
            refCardCurs.docs.forEach((element) {
              batch.delete(element.reference);
            });

            final refCurss1 = await FirebaseFirestore.instance
                .collection('favorites')
                .doc(uuid);
            final refCardCurs1 = await FirebaseFirestore.instance
                .collection('favorites')
                .doc(uuid)
                .collection('card_curss')
                .get();

            // Удаление документа "curss" и его связанных документов
            batch.delete(refCurss1);
            refCardCurs1.docs.forEach((element) {
              batch.delete(element.reference);
            });
            batch.commit();

            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

Future confirmDialog(BuildContext context, String uuid) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Подтвердите удаление'),
        titlePadding: const EdgeInsets.only(top: 30, left: 15, bottom: 50),
        actions: <Widget>[
          TextButton(
            child: const Text('Отменить'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 17),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          TextButton(
            child: const Text(
              'Удалить',
              style: TextStyle(fontSize: 17),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () async {
              final batch = FirebaseFirestore.instance.batch();
              final refCurss =
                  FirebaseFirestore.instance.collection('Curss').doc(uuid);
              final refCardCurs = FirebaseFirestore.instance
                  .collection('Curss')
                  .doc(uuid)
                  .collection('card_curss');

              // Удаление документа "curss" и его связанных документов
              batch.delete(refCurss);
              final cardCursSnapshot = await refCardCurs.get();
              cardCursSnapshot.docs.forEach((element) {
                batch.delete(element.reference);
              });
              final batch1 = FirebaseFirestore.instance.batch();
              final refCurss1 =
                  FirebaseFirestore.instance.collection('favorites').doc(uuid);
              final refCardCurs1 = FirebaseFirestore.instance
                  .collection('favorites')
                  .doc(uuid)
                  .collection('card_curss');

              // Удаление документа "curss" и его связанных документов
              batch1.delete(refCurss1);
              final cardCursSnapshot1 = await refCardCurs1.get();
              cardCursSnapshot1.docs.forEach((element) {
                batch1.delete(element.reference);
              });

              await batch.commit();
              await batch1.commit();

              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

class Profiles {
  final String? uid;

  Profiles({required this.uid});

  Future<String?> getDocumentUid() async {
    final firestoreInstance = FirebaseFirestore.instance;

    // Выполняем запрос к Firestore для получения документа, где поле 'uidUser' равно 'uid' текущего пользователя
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection('Profile')
        .where('uid', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Если документ найден, получаем его uid
      String documentUid = querySnapshot.docs[0].id;
      return documentUid;
    }

    return null; // Если документ не найден, возвращаем null
  }

  Future<int?> getRole() async {
    final firestoreInstance = FirebaseFirestore.instance;
    String? documentUid = await getDocumentUid();

    if (documentUid != null) {
      final docRef = firestoreInstance.collection("Profile").doc(documentUid);
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return data["role"] as int?;
        }
      }
    }
    return null;
  }
}
