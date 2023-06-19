import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/favoritiesScreen.dart';
import 'package:flutter_application_1/screens/settingsScreen.dart';
import 'package:flutter_application_1/screens/task_add.dart';
import 'package:better_open_file/better_open_file.dart';

import 'package:url_launcher/url_launcher.dart';

import 'home.dart';

class CursePage extends StatelessWidget {
  const CursePage({super.key, required this.idCurs});

  final String idCurs;

  //signout function

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Curss')
            .doc(idCurs)
            .collection("card_curss")
            .snapshots(), // Замените yourStream на ваш поток данных для получения значения роли пользователя
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
            final roleUser = snapshot
                .data; // Замените 'role' на поле, содержащее значение роли пользователя в вашем снимке

            // ignore: unrelated_type_equality_checks
            if (roleUser == 1) {
              return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  toolbarHeight: 50,
                  titleTextStyle: TextStyle(fontSize: 18, letterSpacing: 1),
                  title: Text('Schooldis'),
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.bookmark_border_outlined),
                      iconSize: 35,
                      tooltip: 'Избранное',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoritesPage()));
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
                        leading: Icon(Icons.bookmark_border_outlined),
                        title: const Text(' Избранное '),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavoritesPage()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.book),
                        title: const Text(' Курсы '),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: const Text(' Настройки '),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsPage1()));
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
                            MaterialPageRoute(
                                builder: (context) => const Autorization()),
                            (t) => false,
                          );
                        },
                        
                      ),
                      
                    ],
                    
                  ),
                  
                ),
                

                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    (await (FirebaseFirestore.instance
                            .collection("Curss")
                            .doc(idCurs))
                        .collection('card_curss')
                        .snapshots());

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Task_add(idCurs: idCurs)),
                    );
                  },
                  child: Icon(Icons.add),
                ),

                // backgroundColor: Theme.of(context).primaryColor,
                body: ClassList(idCurs),
                
              );
              
              
            }
            else{
               return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  toolbarHeight: 50,
                  titleTextStyle: TextStyle(fontSize: 18, letterSpacing: 1),
                  title: Text('Schooldis'),
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.bookmark_border_outlined),
                      iconSize: 35,
                      tooltip: 'Избранное',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoritesPage()));
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
                        leading: Icon(Icons.bookmark_border_outlined),
                        title: const Text(' Избранное '),
                        onTap: () {
                          print(roleUser);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavoritesPage()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.book),
                        title: const Text(' Курсы '),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: const Text(' Настройки '),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsPage1()));
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
                            MaterialPageRoute(
                                builder: (context) => const Autorization()),
                            (t) => false,
                          );
                        },
                        
                      ),
                      
                    ],
                    
                  ),
                  
                ),
                 floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    (await (FirebaseFirestore.instance
                            .collection("Curss")
                            .doc(idCurs))
                        .collection('card_curss')
                        .snapshots());

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Task_add(idCurs: idCurs)),
                    );
                  },
                  child: Icon(Icons.add),
                ),

                

                body: ClassList(idCurs),
                
              );
            }
            
       
          }
           
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

class ClassList extends StatefulWidget {
  final String idCurs;
  ClassList(this.idCurs);

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = '';

  void _handleSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  launchUrl1(Uri urlString) async {
    if (!await launchUrl(urlString, mode: LaunchMode.inAppWebView)) {
      print('dfdf');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Curss')
                .doc(widget.idCurs)
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
                    elevation: 6.0,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: AssetImage(snapshot.data?['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 140,
                            width: double.infinity,
                          ),
                          Positioned(
                            top: 20,
                            left: 12,
                            right: 12,
                            child: Text(
                              snapshot.data?['Name'],
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              );
            }),
      ),
      Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: 40,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  // padding: EdgeInsets.only(left: 30.0),
                  child: Text(widget.idCurs),
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.idCurs));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ID скопирован в буфер обмена')),
                  );
                },
                icon: Icon(Icons.content_copy),
              ),
            ],
          ),
        ),
      ),
      Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Curss')
                  .doc(widget.idCurs)
                  .collection("card_curss")
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
                final roleUser = snapshot.data;
                if (roleUser == 1) {
                  // ignore: avoid_unnecessary_containers
                  return Column(
                    children: [
                      // ...
                      Expanded(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Curss')
                                .doc(widget.idCurs)
                                .collection("card_curss")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  filteredCards = [];
                              if (searchQuery.isNotEmpty) {
                                filteredCards =
                                    snapshot.data!.docs.where((card) {
                                  final name = card
                                      .data()['Name']
                                      .toString()
                                      .toLowerCase();
                                  final query = searchQuery.toLowerCase();
                                  return name.contains(query);
                                }).toList();
                              } else {
                                filteredCards = snapshot.data!.docs;
                              }

                              return Container(
                                child: ListView.builder(
                                    itemCount: filteredCards.length,
                                    itemBuilder: (context, i) {
                                      return Stack(
                                        children: [
                                          Dismissible(
                                            key: UniqueKey(),
                                            direction:
                                                DismissDirection.endToStart,
                                            onDismissed: (direction) {
                                              confirmDialog(
                                                  context,
                                                  widget.idCurs,
                                                  snapshot.data!.docs[i]
                                                      .id); // Handle
                                            },
                                            background: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Container(
                                                  color: Colors.red,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 35,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  child: ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 15,
                                                            vertical: 30),
                                                    title: Text(
                                                      snapshot.data?.docs[i]
                                                          .data()['Name'],
                                                      style: const TextStyle(
                                                        fontSize: 23,
                                                       
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 5.0,
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: ListTile(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 30),
                                                          title: Text(
                                                            snapshot
                                                                .data?.docs[i]
                                                                .data()['Name'],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 23,
                                                            
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          trailing: IconButton(
                                                            icon: const Icon(Icons
                                                                .file_download),
                                                            onPressed:
                                                                () async {
                                                              // download or open the file here
                                                              String fileUrl = snapshot
                                                                      .data
                                                                      ?.docs[i]
                                                                      .data()[
                                                                  'file_url'];

                                                              if (fileUrl !=
                                                                  null) {
                                                                await OpenFile
                                                                    .open(
                                                                        fileUrl);
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              );
                            }),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      // ...
                      Expanded(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Curss')
                                .doc(widget.idCurs)
                                .collection("card_curss")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  filteredCards = [];
                              if (searchQuery.isNotEmpty) {
                                filteredCards =
                                    snapshot.data!.docs.where((card) {
                                  final name = card
                                      .data()['Name']
                                      .toString()
                                      .toLowerCase();
                                  final query = searchQuery.toLowerCase();
                                  return name.contains(query);
                                }).toList();
                              } else {
                                filteredCards = snapshot.data!.docs;
                              }

                              return Container(
                                child: ListView.builder(
                                    itemCount: filteredCards.length,
                                    itemBuilder: (context, i) {
                                      return Stack(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(),
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15,
                                                          vertical: 30),
                                                  title: Text(
                                                    snapshot.data?.docs[i]
                                                        .data()['Name'],
                                                    style: const TextStyle(
                                                      fontSize: 23,
                                                     
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Card(
                                                elevation: 5.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 6),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: ListTile(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15,
                                                                vertical: 30),
                                                        title: Text(
                                                          snapshot.data?.docs[i]
                                                              .data()['Name'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 23,
                                                          
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        trailing: IconButton(
                                                          icon: const Icon(Icons
                                                              .file_download),
                                                          onPressed: () async {
                                                            // download or open the file here
                                                            String fileUrl =
                                                                snapshot.data
                                                                        ?.docs[i]
                                                                        .data()[
                                                                    'file_url'];

                                                            if (fileUrl !=
                                                                null) {
                                                              await OpenFile
                                                                  .open(
                                                                      fileUrl);
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                              );
                            }),
                      ),
                    ],
                  );
                }
              }))
    ]);
  }
}

Future confirmDialog(BuildContext context, String uuid, String uidCurse) async {
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
                  .collection("card_curss")
                  .doc(uidCurse)
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
