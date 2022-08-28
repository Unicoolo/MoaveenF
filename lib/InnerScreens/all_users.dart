import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moaveen/Widgets/all_workers_widget.dart';
import 'package:moaveen/Widgets/bottom_nav_bar.dart';

import '../Services/global_variables.dart';

class AllWorkersScreen extends StatefulWidget {
  @override
  _AllWorkersScreenState createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradient1,gradient2],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const[0.2,0.9],
        ),
      ),
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBarForApp(indexNum:3),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('All Users',style: TextStyle(color: appBarTitleColor),),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [gradient1,gradient2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const[0.2,0.9],
                ),
              ),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AllWorkersWidget(
                          userID: snapshot.data!.docs[index]['id'],
                          userName: snapshot.data!.docs[index]['name'],
                          userEmail: snapshot.data!.docs[index]['email'],
                          phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                          userLocation: snapshot.data!.docs[index]['location'],
                          userImageUrl: snapshot.data!.docs[index]['userImage'],
                        );
                      });
                } else {
                  return const Center(
                    child: Text('There is no users'),
                  );
                }
              }
              return const Center(
                  child: Text(
                    'Something went wrong',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ));
            },
          )),
    );
  }
}
