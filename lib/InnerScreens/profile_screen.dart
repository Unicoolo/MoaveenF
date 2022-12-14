import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:moaveen/Services/global_variables.dart';
import 'package:moaveen/Widgets/bottom_nav_bar.dart';
import 'package:moaveen/user_state.dart';
import 'package:url_launcher/url_launcher.dart';


class ProfileScreen extends StatefulWidget {
  final String userID;

  const ProfileScreen({required this.userID});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _titleTextStyle = const TextStyle(fontSize: 20, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
  var contentTextStyle =  const TextStyle(color: Colors.black54,
      fontSize: 18,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  bool _isLoading = false;
  String phoneNumber = "";
  String email = "";
  String? name;
  String role = '';
  String userLocation = '';
  String imageUrl = "";
  String joinedAt = " ";
  bool _isSameUser = false;
  void getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          email = userDoc.get('email');
          name = userDoc.get('name');
          role = userDoc.get('userRole');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          userLocation = userDoc.get('location');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    } catch (erorr) {} finally {
      _isLoading = false;
    }
  }

  void _logOut(context)
  {
    showDialog(
        context: context,
        builder: (context)
        {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'SignOut',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Do you want to LogOut ?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.canPop(context) ? Navigator.pop(context): null;
                },
                child: const Text('No',style: TextStyle(color: Colors.green,fontSize:18 ),),
              ),
              TextButton(
                onPressed: (){
                  _auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context): null;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> UserState()));
                },
                child: const Text('Yes',style: TextStyle(color: Colors.green,fontSize:18 ),),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum:4),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Stack(
            children: [
              Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text(name == null ? 'Name here' : name!,
                              style: _titleTextStyle)),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '$role ',
                          style: contentTextStyle,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'joined $joinedAt',
                          style: contentTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Contact Info',
                          style: _titleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: userInfo(title: 'Email   :', content: email),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: userInfo(
                            title: 'Ph No.  :', content: phoneNumber),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: userInfo(
                            title: 'Address :', content: userLocation),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _isSameUser
                          ? Container()
                          : const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                          _contactBy(
                            color: Colors.green,
                            fct: () {
                              _openWhatsAppChat();
                            },
                            icon: FontAwesome.whatsapp,
                          ),
                          _contactBy(
                              color: Colors.red,
                              fct: () {
                                _mailTo();
                              },
                              icon: Icons.mail_outline),
                          _contactBy(
                              color: Colors.purple,
                              fct: () {
                                _callPhoneNumber();
                              },
                              icon: Icons.call_outlined),
                        ],
                      ),
                      const SizedBox(height: 25,),
                      const Divider(thickness: 1,),
                      const SizedBox(height: 25,),
                      !_isSameUser
                          ? Container()
                          : Center(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(bottom: 30),
                          child: MaterialButton(
                            onPressed: () {
                              _logOut(context);
                            },
                            color: buttonColor,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(13)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: buttonTextColor,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                        color: buttonTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.26,
                    height: size.width * 0.26,
                    decoration: BoxDecoration(
                        color: buttonColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 8,
                          color:
                          Theme.of(context).scaffoldBackgroundColor,
                        ),
                        image: DecorationImage(
                            image: NetworkImage(imageUrl == null
                                ? personIconImage
                                : imageUrl),
                            fit: BoxFit.fill)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openWhatsAppChat() async {
    var url = 'https://wa.me/$phoneNumber?text=HelloWorld';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Erorr');
      throw 'Error occured';
    }
  }

  void _mailTo() async {
    var mailUrl = 'mailto:$email';
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print('Erorr');
      throw 'Error occured';
    }
  }

  void _callPhoneNumber() async {
    var url = 'tel://$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
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

  Widget userInfo({required String title, required String content}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 19,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
