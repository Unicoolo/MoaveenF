import 'package:flutter/material.dart';
import 'package:moaveen/Widgets/bottom_nav_bar.dart';

class UploadJobNow extends StatefulWidget {


  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade300,Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const[0.2,0.9],
        ),
      ),
      child:Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum:2),
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Upload job Now'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade300,Colors.blueAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const[0.2,0.9],
              ),
            ),
          ),
        ),
      ) ,
    );
  }
}
