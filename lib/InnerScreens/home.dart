import 'package:flutter/material.dart';
import 'package:moaveen/Services/global_variables.dart';
import 'package:moaveen/Widgets/bottom_nav_bar.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum:0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Home',style: TextStyle(color: appBarTitleColor),),
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
      ),
    );
  }
}
