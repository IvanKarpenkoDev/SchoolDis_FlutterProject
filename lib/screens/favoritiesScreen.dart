import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/cursePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

 List<QueryDocumentSnapshot<Map<String, dynamic>>> _favorites = [];

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // late List<DocumentSnapshot> _favorites;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    var favorites = await FirebaseFirestore.instance
        .collection('favorites')
        .get()
        .then((snapshot) => snapshot.docs);
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, bool> _favorite = {};
    if (_favorites == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Избранные курсы'),
        ),
        body: _favorites.isEmpty
            ? Center(
                child: Text('Список избранного пуст'),
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('favorites')
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

                  // ignore: avoid_unnecessary_containers
                  return Container(
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, i) {
                            final doc = snapshot.data!.docs[i];
                            final isFavorite = _favorite[doc.id] ?? false;
                            return Stack(
                              children: [
                                Card(
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
                                                    idCurs: (snapshot
                                                        .data?.docs[i].id)!,
                                                  )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(snapshot
                                              .data?.docs[i]
                                              .data()['image']),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 30),
                                              title: Text(
                                                snapshot.data?.docs[i]
                                                    .data()['Name'],
                                                style: const TextStyle(
                                                  fontSize: 23,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                          const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: SizedBox(
                                              child: Text(
                                                'Удалить',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ),
                                        ];
                                      },
                                      onSelected: (value) {
                                        switch (value) {
                                          case 'delete':
                                          FirebaseFirestore.instance
                                                .collection('favorites')
                                                .doc(doc.id)
                                                .delete();
                                            break;
                                          case 'favorite':
                                            
                                            break;
                                        }
                                      },
                                    ))
                              ],
                            );
                          }),
                    ),
                  );
                }),
      );
    }
  }
}
