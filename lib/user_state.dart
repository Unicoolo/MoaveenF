
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moaveen/InnerScreens/home.dart';
import 'package:moaveen/authScreens/login_screen.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx,userSnapshot)
        {
          if(userSnapshot.data==null)
          {
            print('User is not logged in yet');
            return Login();
          }
          else if(userSnapshot.hasData)
          {
            print('User is already logged in yet');
            return homeScreen();
          }
          else if(userSnapshot.hasError)
          {
            return const Scaffold(
              body: Center(
                child: Text('An error has been occured. Try again later'),
              ),
            );
          }
          else if(userSnapshot.connectionState==ConnectionState.waiting)
          {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text('Something went Wrong'),
            ),
          );
        },
    );
  }
}
