
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moaveen/RequestScreens/request_details.dart';
import 'package:moaveen/Services/global_methods.dart';
import 'package:moaveen/Services/global_variables.dart';

class requestWidget extends StatefulWidget {
  final String requestTitle;
  final String requestDescription;
  final String requestId;
  final String uploadedBy;
  final String requestLocation;
  final bool isDone;

  const requestWidget(
      {required this.requestTitle,
      required this.requestDescription,
      required this.requestId,
      required this.uploadedBy,
      required this.requestLocation,
      required this.isDone});

  @override
  _requestWidgetState createState() => _requestWidgetState();
}

class _requestWidgetState extends State<requestWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => requestDetailsScreen(
                requestID: widget.requestId,
                uploadedBy: widget.uploadedBy,
              ),
            ),
          );
        },
        onLongPress: _deleteDialog,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 5),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 30,
            child: Image.network(widget.isDone
                ? requestCloseImage
                : requestOpenImage),
          ),
        ),
        title: Text(
          widget.requestTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 18,
          ),
        ),

        subtitle: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 5,),
            Text(
              widget.requestDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16,color: Colors.black45),
            ),
            const SizedBox(height: 5,),
            const Divider(thickness: 0.1,color: Colors.black,height: 2,),
            Row(
              children: [

                const Icon(Icons.location_on_outlined,size: 18,color: Colors.black45,),
                Text(
                  widget.requestLocation,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: buttonColor,
        ),
      ),
    );
  }

  _deleteDialog() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    if (widget.uploadedBy == _uid) {
                      await FirebaseFirestore.instance
                          .collection('requests')
                          .doc(widget.requestId)
                          .delete();
                      await Fluttertoast.showToast(
                          msg: "Request has been deleted",
                          toastLength: Toast.LENGTH_LONG,
                          // gravity: ToastGravity.,
                          backgroundColor: Colors.grey,
                          fontSize: 18.0);
                      Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                    } else {
                      GlobalMethod.showErrorDialog(
                          error: 'You cannot perfom this action', ctx: ctx);
                    }
                  } catch (error) {
                    GlobalMethod.showErrorDialog(
                        error: 'this Request can\'t be deleted', ctx: context);
                  } finally {}
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
