import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/curse_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/class.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Curse_add()));
          },
          child: Icon(
            Icons.add,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            toolbarHeight: 50,
            backgroundColor: Color.fromRGBO(82, 179, 253, 1),
            titleTextStyle: TextStyle(fontSize: 18, letterSpacing: 1),
            title: Text('Schooldis'),
            leading: Icon(Icons.menu),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.account_circle_outlined),
                iconSize: 35,
                tooltip: 'Профиль',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Тут будет профиль')));
                },
              ),
            ]),
        body: ClassList(),
      ),
    );
  }

  Widget logo() {
    return Padding(
      padding: EdgeInsets.only(top: 59),
      child: Container(
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            child: Container(
              child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, i) {
                    return Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      shape: RoundedRectangleBorder(
                        //<-- SEE HERE
                        side: BorderSide(
                          color: Color.fromARGB(255, 197, 197, 197),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(230, 230, 230, 0.8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
                          title: Text(snapshot.data?.docs[i].data()['Name'], style: TextStyle(fontSize: 19),
                          ),
                          
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Color.fromRGBO(116, 116, 116, 1),
                            size: 30,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }
}
