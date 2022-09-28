import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moaveen/InnerScreens/about_us.dart';
import 'package:moaveen/InnerScreens/dedication_to.dart';
import 'package:moaveen/InnerScreens/donation.dart';
import 'package:moaveen/InnerScreens/feedBack.dart';
import 'package:moaveen/Services/global_variables.dart';
import 'package:moaveen/Widgets/bottom_nav_bar.dart';
import 'package:carousel_pro/carousel_pro.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white,Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const[0.2,0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum:0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Moaveen App',style: TextStyle(color: appBarTitleColor),),
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
        body: Container(
          child: Center(
            child: ListView(
              children: [
                SizedBox(
                  height: 200.0,
                  width: double.infinity,
                  child: Carousel(
                    images: [
                      Image.asset('assets/images/3.png', fit:BoxFit.cover,),
                      Image.asset('assets/images/2.png', fit:BoxFit.cover,),
                      Image.asset('assets/images/1.png', fit:BoxFit.cover,),
                      Image.asset('assets/images/4.png', fit:BoxFit.cover,),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(28),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orangeAccent, width: 3)),
                        child: Column(
                          children: [
                            Text(
                              "A Step Towards",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              " Accessible World ",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 20,),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AboutUs(),
                      ),
                    );
                  },
                  color: buttonColor,//green
                  //elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'About Us',
                          style: TextStyle(
                            color: buttonTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Dedication(),
                      ),
                    );
                  },
                  color: buttonColor,//green
                  //elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dedication',
                          style: TextStyle(
                            color: buttonTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Donation(),
                      ),
                    );
                  },
                  color: buttonColor,//green
                  //elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Donation',
                          style: TextStyle(
                            color: buttonTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Feedbackapp(),
                      ),
                    );
                  },
                  color: buttonColor,//green
                  //elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'FeedBack',
                          style: TextStyle(
                            color: buttonTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
