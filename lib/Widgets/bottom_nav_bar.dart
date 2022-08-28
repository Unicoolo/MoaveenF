import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moaveen/RequestScreens/request_screen.dart';
import 'package:moaveen/RequestScreens/upload_request.dart';
import 'package:moaveen/InnerScreens/home.dart';
import 'package:moaveen/InnerScreens/profile_screen.dart';
import 'package:moaveen/InnerScreens/all_users.dart';
import 'package:moaveen/user_state.dart';

class BottomNavigationBarForApp extends StatelessWidget {

  int indexNum=0;

  BottomNavigationBarForApp({required this.indexNum});


  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.deepOrange.shade400,
      backgroundColor: Colors.lightGreenAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: 50,
      index: indexNum,
      items: const [
        Icon(Icons.home,size: 19,color: Colors.black,),
        Icon(Icons.list,size: 19,color: Colors.black,),
        Icon(Icons.add,size: 19,color: Colors.black,),
        Icon(Icons.search,size: 19,color: Colors.black,),
        Icon(Icons.person_pin,size: 19,color: Colors.black,),

      ],
      animationDuration: const Duration(microseconds: 300,),
      animationCurve: Curves.bounceInOut,
      onTap: (index)
      {
        if(index==0)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> homeScreen()));
        }
        else if(index==1)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> requestsScreen()));
        }
        else if(index==2)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> Uploadrequest()));
        }
        else if(index==3)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> AllWorkersScreen()));
        }
        else if(index==4)
        {
          final User? user = _auth.currentUser;
          final String uid = user!.uid;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> ProfileScreen(userID:uid)));
        }

      },
    );
  }
}
