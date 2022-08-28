import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moaveen/Services/global_variables.dart';
import 'package:moaveen/Widgets/bottom_nav_bar.dart';
import 'package:moaveen/Widgets/task_widget.dart';

import 'package:moaveen/constants/constants.dart';


class requestsScreen extends StatefulWidget {
  @override
  _requestsScreenState createState() => _requestsScreenState();
}

class _requestsScreenState extends State<requestsScreen> {
  String? requestCategoryFilter;

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
          bottomNavigationBar: BottomNavigationBarForApp(indexNum:1),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Request Portal',style: TextStyle(color: appBarTitleColor),),
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
            actions: [
              IconButton(
                  onPressed: () {
                    _filterCategoriesDialog(size: size);
                  },
                  icon: Icon(Icons.filter_list_outlined, color: appBarTitleColor))
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: requestCategoryFilter == null
                ? FirebaseFirestore.instance
                    .collection('requests')
                    .orderBy('createdAt', descending: true)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('requests')
                    .where('requestCategory', isEqualTo: requestCategoryFilter)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return requestWidget(
                          requestTitle: snapshot.data!.docs[index]['requestTitle'],
                          requestDescription: snapshot.data!.docs[index]['requestDescription'],
                          requestId: snapshot.data!.docs[index]['requestId'],
                          uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                          requestLocation: snapshot.data!.docs[index]['requestLocation'],
                          isDone: snapshot.data!.docs[index]['isDone'],
                        );
                      });
                } else {
                  return const Center(
                    child: Text('There is no requests'),
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

  _filterCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Category',
              style: TextStyle(fontSize: 25, color: headingColor,fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.requestCategoryList.length,
                  itemBuilder: (ctxx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          requestCategoryFilter =
                              Constants.requestCategoryList[index];
                        });
                        Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                        print(
                            'requestCategoryList[index], ${Constants.requestCategoryList[index]}');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: iconColor,
                          ),
                          const SizedBox(width: 10,),
                          Expanded(

                              child: SingleChildScrollView(
                                child: Text(
                                  Constants.requestCategoryList[index],
                                  style: TextStyle(
                                      color: contentColor,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          const SizedBox(height: 40,),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                },
                child: Text('Close',style: TextStyle(color: buttonColor2,fontSize: 16),),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    requestCategoryFilter = null;
                  });
                  Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                },
                child: Text('Cancel filter',style: TextStyle(color: buttonColor2,fontSize: 16),),
              ),
            ],
          );
        });
  }
}
