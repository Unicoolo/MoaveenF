import 'package:flutter/material.dart';

import '../Services/global_variables.dart';

class Feedbackapp extends StatefulWidget {
  const Feedbackapp({Key? key}) : super(key: key);

  @override
  State<Feedbackapp> createState() => _FeedbackappState();
}

class _FeedbackappState extends State<Feedbackapp> {
  TextEditingController nameController = TextEditingController();
  String feedback = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'FeedBack',
            style: TextStyle(color: appBarTitleColor),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradient1, gradient2],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
        ),
        body: Center(child: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your comments',
                ),
                onChanged: (text) {
                  setState(() {
                    feedback = text;

                  });
                },
              )),
          MaterialButton(
            onPressed: (){},
            color: buttonColor,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'Submit',
                style: TextStyle(
                  color: buttonTextColor,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                ),
              ),
            ),
          )
        ])));
  }
}

