import 'package:flutter/material.dart';
import 'package:moaveen/InnerScreens/profile_screen.dart';
import 'package:moaveen/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';


class AllWorkersWidget extends StatefulWidget {
  final String userID;
  final String userName;
  final String userEmail;
  final String userLocation;
  final String phoneNumber;
  final String userImageUrl;

  const AllWorkersWidget(
      {required this.userID,
      required this.userName,
      required this.userEmail,
      required this.userLocation,
      required this.phoneNumber,
      required this.userImageUrl});
  @override
  _AllWorkersWidgetState createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userID: widget.userID,
                ),
              ),
            );
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
            padding: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(width: 1),
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 25,
              child: Image.network(widget.userImageUrl == null
                  ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                  : widget.userImageUrl),
            ),
          ),
          title: Text(
            widget.userName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Divider(thickness: 0.1,color: Colors.black,),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,size: 18,color: Colors.black45,),
                  Text(
                    widget.userLocation,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.call,size: 18,color: Colors.black45,),
                  Text(
                    widget.phoneNumber,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

            ],
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.mail_outline,
              size: 30,
              color: Colors.black,
            ),
            onPressed: _mailTo,
          )),
    );
  }

  void _mailTo() async {
    var mailUrl = 'mailto:${widget.userEmail}';
    print('widget.userEmail ${widget.userEmail}');
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print('Erorr');
      throw 'Error occured';
    }
  }
}
