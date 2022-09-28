import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moaveen/Services/global_methods.dart';
import 'package:moaveen/Services/global_variables.dart';
import 'package:moaveen/Widgets/bottom_nav_bar.dart';
import 'package:moaveen/constants/constants.dart';
import 'package:uuid/uuid.dart';

class Uploadrequest extends StatefulWidget {
  @override
  _UploadrequestState createState() => _UploadrequestState();
}

class _UploadrequestState extends State<Uploadrequest> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _requestCategoryController = TextEditingController(text: 'Choose category');
  final TextEditingController _requestTitleController = TextEditingController();
  final TextEditingController _requestDescriptionController = TextEditingController();
  final TextEditingController _deadlineDateController = TextEditingController(text: 'Choose Deadline date');

  String? userLocation;

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _requestCategoryController.dispose();
    _requestTitleController.dispose();
    _requestDescriptionController.dispose();
    _deadlineDateController.dispose();
  }



  void _uploadrequest() async {
    final requestID = Uuid().v4();
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    final _location = user.uid;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .get();
    if (userDoc == null) {
      print("request Not Found");
      return;
    } else {
      setState(() {
        print("USer Name : ${userDoc.get('name')}");
        userLocation = userDoc.get('location');
      });
    }
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_deadlineDateController.text == 'Choose Deadline date' ||
          _requestCategoryController.text == 'Choose category') {
        GlobalMethod.showErrorDialog(
            error: 'Please Fill Everything', ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('requests').doc(requestID).set({
          'requestId': requestID,
          'uploadedBy': _uid,
          'requestLocation':userLocation,
          'requestTitle': _requestTitleController.text,
          'requestDescription': _requestDescriptionController.text,
          'deadlineDate': _deadlineDateController.text,
          'deadlineDateTimeStamp': deadlineDateTimeStamp,
          'requestCategory': _requestCategoryController.text,
          'requestComments': [],
          'isDone': false,
          'createdAt': Timestamp.now(),
        });
        await Fluttertoast.showToast(
            msg: "The Request has been uploaded",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.grey,
            fontSize: 18.0);
        _requestTitleController.clear();
        _requestDescriptionController.clear();
        setState(() {
          _requestCategoryController.text = 'Choose category';
          _deadlineDateController.text = 'Choose Deadline date';
        });
      } catch (error) {} finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('it is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum:2),
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(
          'Request Upload',
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
      body: Padding(
        padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                // SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textTitles(label: 'Category*'),
                        _textFormFields(
                            valueKey: 'requestCategory',
                            controller: _requestCategoryController,
                            enabled: false,
                            fct: () {
                              _showCategoriesDialog(size: size);
                            },
                            maxLength: 100),
                        //title
                        _textTitles(label: 'Title*'),
                        _textFormFields(
                            valueKey: 'requestTitle',
                            controller: _requestTitleController,
                            enabled: true,
                            fct: () {},
                            maxLength: 100),
                        //description
                        _textTitles(label: 'Description*'),
                        _textFormFields(
                            valueKey: 'requestDescription',
                            controller: _requestDescriptionController,
                            enabled: true,
                            fct: () {},
                            maxLength: 1000),
                        //deadline date
                        _textTitles(label: 'Deadline date*'),
                        _textFormFields(
                            valueKey: 'requestdeadline',
                            controller: _deadlineDateController,
                            enabled: false,
                            fct: () {
                              _pickDateDialog();
                            },
                            maxLength: 100),
                      ],
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : MaterialButton(
                            onPressed: _uploadrequest,
                            color: buttonColor,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Upload Request',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.upload_file,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),

      ),
    );
  }

  Widget _textFormFields(
      {required String valueKey,
      required TextEditingController controller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(

      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Value is missing";
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          // initialValue: 'heloo',
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          maxLines: valueKey == 'requestDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration:  InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black54),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: fieldFocusColor),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: fieldErrorColor),
            ),
          ),
        ),
      ),
    );
  }

  _showCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Category',
              style: TextStyle(fontSize: 20, color: headingColor,fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.requestCategoryList.length,
                  itemBuilder: (ctxx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _requestCategoryController.text =
                              Constants.requestCategoryList[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: iconColor,
                          ),
                          // SizedBox(width: 10,),

                             Expanded(
                               child: SingleChildScrollView(
                                 child: Text(
                                  Constants.requestCategoryList[index],
                                  style: TextStyle(
                                      color: contentColor,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic),
                                   maxLines: 2,
                            ),
                               ),
                             ),
                          const SizedBox(height: 40,),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 0),
      ),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _deadlineDateController.text =
            '${picked!.year}-${picked!.month}-${picked!.day}';
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
