import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moaveen/Services/global_methods.dart';
import 'package:moaveen/Services/global_variables.dart';
import 'package:moaveen/Widgets/comments_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class requestDetailsScreen extends StatefulWidget {
  final String uploadedBy;
  final String requestID;

  const requestDetailsScreen(
      {required this.uploadedBy, required this.requestID});

  @override
  _requestDetailsScreenState createState() => _requestDetailsScreenState();
}

class _requestDetailsScreenState extends State<requestDetailsScreen> {

  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  String? authorName;
  String? authorPosition;
  String? authorNum;
  String? userImageUrl;
  String? _loggedInUserImageUrl;
  String? requestCategory;
  String? requestDescription;
  String? requesttitle;
  bool? _isDone;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  bool isDeadlineAvailable = false;
  String? _loggedUserName;
  bool dataLoaded = false;
  bool isLoading = false;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      isLoading = true;
    });
    getrequestData().then((value) => setState(() => isLoading = false));
  }

  Future<void> getrequestData() async {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    print("User ID : ${_uid}");
    final DocumentSnapshot getCommenterInfoDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (getCommenterInfoDoc == null) {
      return;
    } else {
      setState(() {
        _loggedUserName = getCommenterInfoDoc.get('name');
        _loggedInUserImageUrl = getCommenterInfoDoc.get('userImage');
      });
    }
    //
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();
    if (userDoc == null) {
      print("request Not Found");
      return;
    } else {
      setState(() {
        print("USer Name : ${userDoc.get('name')}");
        authorName = userDoc.get('name');
        authorPosition = userDoc.get('location');
        authorNum = userDoc.get('phoneNumber');
        userImageUrl = userDoc.get('userImage');
      });
    }
    final DocumentSnapshot requestDatabase = await FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.requestID)
        .get();
    if (requestDatabase == null) {
      print("request NOt Found");
      return;
    } else {
      setState(() {
        requesttitle = requestDatabase.get('requestTitle');
        requestDescription = requestDatabase.get('requestDescription');
        requestCategory = requestDatabase.get('requestCategory');
        _isDone = requestDatabase.get('isDone');
        postedDateTimeStamp = requestDatabase.get('createdAt');
        deadlineDateTimeStamp = requestDatabase.get('deadlineDateTimeStamp');
        deadlineDate = requestDatabase.get('deadlineDate');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
        print("request Title : ${requesttitle}");
      });

      var date = deadlineDateTimeStamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Request Details',
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      Text(
                        requesttitle == null ? '' : requesttitle!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,

                        ),
                      ),
                      dividerWidget(),
                      const Text(
                        'Details',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        requestDescription == null
                            ? ''
                            : requestDescription!,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          const Icon(Icons.add_box_outlined,size: 16,color: Colors.black,),
                          Text(
                            requestCategory == null
                                ? ''
                                : requestCategory!,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      dividerWidget(),
                      const SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            postedDate == null ? '' : postedDate!,
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                          Text(
                            deadlineDate == null ? '' : deadlineDate!,
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Center(
                        child: Text(
                          isDeadlineAvailable
                              ? 'Deadline is not finished yet'
                              : ' Deadline passed',
                          style: TextStyle(
                              color: isDeadlineAvailable
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      ),
                      dividerWidget(),
                      const Text(
                        'Request status:',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              User? user = _auth.currentUser;
                              final _uid = user!.uid;
                              if (_uid == widget.uploadedBy) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('requests')
                                      .doc(widget.requestID)
                                      .update({'isDone': true});
                                } catch (err) {
                                  GlobalMethod.showErrorDialog(
                                      error: 'Action cant be performed',
                                      ctx: context);
                                }
                              } else {
                                GlobalMethod.showErrorDialog(
                                    error: 'You cant perform this action',
                                    ctx: context);
                              }
                              getrequestData();
                            },
                            child: const Text(
                              'Completed',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                  color: Colors.black45,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Opacity(
                            opacity: _isDone == true ? 1 : 0,
                            child: const Icon(
                              Icons.check_box,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          TextButton(
                            onPressed: () {
                              User? user = _auth.currentUser;
                              final _uid = user!.uid;
                              if (_uid == widget.uploadedBy) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('requests')
                                      .doc(widget.requestID)
                                      .update({'isDone': false});
                                } catch (err) {
                                  GlobalMethod.showErrorDialog(
                                      error: 'Action cant be performed',
                                      ctx: context);
                                }
                              } else {
                                GlobalMethod.showErrorDialog(
                                    error: 'You cant perform this action',
                                    ctx: context);
                              }

                              getrequestData();
                            },
                            child: const Text(
                              'Not Complete',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                  color: Colors.black45,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Opacity(
                            opacity: _isDone == false ? 1 : 0,
                            child: const Icon(
                              Icons.check_box,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                      dividerWidget(),
                      Row(
                        children: [
                          const SizedBox(width: 10,),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: buttonColor,
                              ),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(userImageUrl == null
                                      ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                      : userImageUrl!),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          const SizedBox(width: 15,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authorName == null ? '' : authorName!,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,size: 18,color: Colors.black45,),
                                  Text(
                                    authorPosition == null
                                        ? ''
                                        : authorPosition!,
                                    style: const TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),

                      dividerWidget(),

                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        child: _isCommenting
                            ? Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: TextField(
                                controller: _commentController,
                                style: const TextStyle(color: Colors.black54),
                                maxLength: 200,
                                keyboardType: TextInputType.text,
                                maxLines: 6,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: buttonColor2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: buttonColor),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (_commentController
                                              .text.length <
                                              7) {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                'Comment cant be less than 7 characteres',
                                                ctx: context);
                                          } else {
                                            User? user =
                                                _auth.currentUser;
                                            final _uid = user!.uid;
                                            // print('Uid is $_uid');
                                            // print(
                                            //     'uploaded by id is ${widget.uploadedBy}');

                                            final _generatedId =
                                            Uuid().v4();
                                            await FirebaseFirestore
                                                .instance
                                                .collection('requests')
                                                .doc(widget.requestID)
                                                .update({
                                              'requestComments':
                                              FieldValue.arrayUnion([
                                                {
                                                  //There was a bug here we should upload the current logged in user
                                                  //instead of the uploader ID
                                                  'userId': _uid,
                                                  'commentId':
                                                  _generatedId,
                                                  //and for the name it was the author name
                                                  //it should be the current logged in username
                                                  'name': _loggedUserName,
                                                  //Also we need to change the image
                                                  'userImageUrl':
                                                  _loggedInUserImageUrl,
                                                  'commentBody':
                                                  _commentController
                                                      .text,
                                                  'time': Timestamp.now(),
                                                }
                                              ]),
                                            });
                                            await Fluttertoast.showToast(
                                                msg:
                                                "Your comment has been added",
                                                toastLength:
                                                Toast.LENGTH_LONG,
                                                // gravity: ToastGravity.,
                                                backgroundColor:
                                                Colors.grey,
                                                fontSize: 18.0);
                                            _commentController.clear();
                                          }
                                          setState(() {});
                                        },
                                        color: buttonColor,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8)),
                                        child: Text(
                                          'Post',
                                          style: TextStyle(
                                              color: buttonTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isCommenting =
                                            !_isCommenting;
                                          });
                                        },
                                        child: const Text('Cancel'))
                                  ],
                                ))
                          ],
                        )
                            : Row(
                              children: [
                                MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    _isCommenting = !_isCommenting;
                                  });
                                },
                                color: buttonColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(13)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  child: Text(
                                    'Add a Comment',
                                    style: TextStyle(
                                        color: buttonTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                          ),
                                Spacer(),
                                const Text('Or Direct Use '),
                                _contactBy(
                                  color: Colors.green,
                                  fct: () {
                                    _openWhatsAppChat();
                                  },
                                  icon: FontAwesome.whatsapp,
                                ),
                                const SizedBox(width: 15,),
                              ],
                            ),

                      ),
                      const SizedBox(height: 40,),
                      FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('requests')
                              .doc(widget.requestID)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              if (snapshot.data == null) {
                                const Center(
                                    child: Text(
                                        'No Comment for this request'));
                              }
                            }
                            return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CommentWidget(
                                    commentId:
                                    snapshot.data!['requestComments']
                                    [index]['commentId'],
                                    commenterId:
                                    snapshot.data!['requestComments']
                                    [index]['userId'],
                                    commentBody:
                                    snapshot.data!['requestComments']
                                    [index]['commentBody'],
                                    commenterImageUrl:
                                    snapshot.data!['requestComments']
                                    [index]['userImageUrl'],
                                    commenterName:
                                    snapshot.data!['requestComments']
                                    [index]['name'],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    thickness: 1,
                                  );
                                },
                                itemCount: snapshot
                                    .data!['requestComments'].length);
                          })
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget dividerWidget() {
    return Column(
      children: const [
        SizedBox(
          height: 5,
        ),
        Divider(
          thickness: 1,
        ),
      ],
    );
  }

  void _openWhatsAppChat() async {
    var url = 'https://wa.me/$authorNum?text=HelloWorld';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Erorr');
      throw 'Error occured';
    }
  }

  Widget _contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              icon,
              color: color,
            ),
            onPressed: () {
              fct();
            },
          )),
    );
  }
}
