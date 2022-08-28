
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moaveen/Services/global_methods.dart';
import 'package:moaveen/constants/constants.dart';


import '../Services/global_variables.dart';

class SignUp extends StatefulWidget {

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {

  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _fullNameController = TextEditingController(text: '');
  final TextEditingController _emailTextController = TextEditingController(text: '');
  final TextEditingController _passTextController = TextEditingController(text: '');
  final TextEditingController _roleTextController = TextEditingController(text: '');
  final TextEditingController _phoneNumberController = TextEditingController(text: '');
  final TextEditingController _locationController = TextEditingController(text: '');


  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _roleFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _obscureText = true;
  bool _isLoading = false;

  final _signUpFormKey=GlobalKey<FormState>();
  File? imageFile;
  String? imageUrl;

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _locationFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _roleTextController.dispose();
    _roleFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
    CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  void _showImageDialog()
  {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Please choose an option'),
            content:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    _getFormCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: buttonColor,
                        ),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color:buttonColor),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    _getFormGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: buttonColor,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color:buttonColor),
                      )
                    ],
                  ),
                )

              ],
           ),
          );
        }
    );
  }

  void _getFormCamera() async
  {
    XFile? pickedFile= await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFormGallery() async
  {
    XFile? pickedFile= await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async
  {
    CroppedFile? croppedImage=await ImageCropper().cropImage(sourcePath: filePath,maxHeight: 1080,maxWidth: 1080);
    if(croppedImage!=null)
    {
      setState(() {
        imageFile=File(croppedImage.path);
      });
    }
  }

  void _submitFormSignUP() async
  {
    final isValid = _signUpFormKey.currentState!.validate();
    if(isValid)
    {
     if(imageFile==null)
     {
       GlobalMethod.showErrorDialog(error: 'Please pick and image', ctx: context);
       return;
     }
     setState(() {
       _isLoading=true;
     });

     try{
       await _auth.createUserWithEmailAndPassword(
           email: _emailTextController.text.trim().toLowerCase(),
           password: _passTextController.text.trim(),
       );
       final User? user = _auth.currentUser;
       final _uid= user!.uid;
       final ref= FirebaseStorage.instance.ref().child('UserImages').child(_uid+'.jpg');
       await ref.putFile(imageFile!);
       imageUrl=await ref.getDownloadURL();
       FirebaseFirestore.instance.collection('users').doc(_uid).set({
         'id': _uid,
         'name': _fullNameController.text,
         'email': _emailTextController.text,
         'password':_passTextController.text,
         'userImage' : imageUrl,
         'userRole': _roleTextController.text,
         'phoneNumber' : _phoneNumberController.text,
         'location' : _locationController.text,
         'createdAt' : Timestamp.now(),
       });
       Navigator.canPop(context ) ? Navigator.pop(context):null;
     }
     catch(error)
     {
       setState(() {
         _isLoading=false;
       });
       GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
     }
    }
    setState(() {
      _isLoading=false;
    });
  }

  void _roleCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Choose Role',
              style: TextStyle(fontSize: 20, color: headingColor),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.roleList.length,
                  itemBuilder: (ctxx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _roleTextController.text =
                          Constants.roleList[index];
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.roleList[index],
                              style: TextStyle(
                                  color: buttonColor2,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
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
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  void _addressCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Choose Address',
              style: TextStyle(fontSize: 20, color: headingColor),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.locationList.length,
                  itemBuilder: (ctxx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _locationController.text =
                          Constants.locationList[index];
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.locationList[index],
                              style: TextStyle(
                                  color: buttonColor2,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
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

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: signUpUrlImage,
            placeholder: (context, url) =>
                Image.asset(
                  signUpImage,
                  fit: BoxFit.fill,

                ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 80),
              child: ListView(
                children: [
                  Form(
                    key: _signUpFormKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              _showImageDialog();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: size.width*0.24,
                                height: size.width*0.24,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1,color: buttonColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: imageFile==null
                                      ? Icon(Icons.camera_enhance_sharp,color: buttonColor)
                                      :Image.file(imageFile!,fit: BoxFit.fill,),

                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode),
                            keyboardType: TextInputType.name,
                            controller: _fullNameController,
                            validator: (value) {
                              if (value!.isEmpty ) {
                                return 'This Field is Missing';
                              }
                              else {
                                return null;
                              }
                            },
                            style: TextStyle(color: fieldColor),
                            decoration:  InputDecoration(
                              hintText: 'Full Name',
                              hintStyle: TextStyle(color: fieldColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: fieldBorderColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: fieldFocusColor),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: fieldErrorColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context)
                                    .requestFocus(_passFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please Enter a valid Email Address';
                              }
                              else {
                                return null;
                              }
                            },
                            style: TextStyle(color: fieldColor),
                            decoration:  InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: fieldColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: fieldBorderColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: fieldFocusColor),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: fieldErrorColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context)
                                    .requestFocus(_roleFocusNode),
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passTextController,
                            obscureText: !_obscureText,
                            //change it dynamically
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please Enter a valid Password';
                              }
                              else {
                                return null;
                              }
                            },
                            style: TextStyle(color: fieldColor),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: fieldColor,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle:  TextStyle(color: fieldColor),
                              enabledBorder:  UnderlineInputBorder(
                                borderSide: BorderSide(color:fieldBorderColor),
                              ),
                              focusedBorder:  UnderlineInputBorder(
                                borderSide: BorderSide(color: fieldFocusColor),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: fieldErrorColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),

                          GestureDetector(
                            onTap: () {
                              _roleCategoriesDialog(size: size);
                            },
                            child: TextFormField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                              focusNode: _roleFocusNode,
                              keyboardType: TextInputType.name,
                              controller: _roleTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This field is missing";
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(color: fieldColor),
                              decoration: InputDecoration(
                                hintText: 'Role',
                                hintStyle: TextStyle(color: fieldColor),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: fieldBorderColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: fieldFocusColor),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: fieldErrorColor),
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: fieldBorderColor),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context)
                                    .requestFocus(_locationFocusNode),
                            keyboardType: TextInputType.phone,
                            controller: _phoneNumberController,
                            validator: (value) {
                              if (value!.isEmpty ) {
                                return 'Please Enter a valid Number';
                              }
                              else {
                                return null;
                              }
                            },
                            style:  TextStyle(color: fieldColor),
                            decoration:  InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(color: fieldColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: fieldBorderColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: fieldFocusColor),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: fieldErrorColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),

                          GestureDetector(
                            onTap: () {
                              _addressCategoriesDialog(size: size);
                            },
                            child: TextFormField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context)
                                      .requestFocus(_locationFocusNode),
                              keyboardType: TextInputType.text,
                              controller: _locationController,
                              validator: (value) {
                                if (value!.isEmpty ) {
                                  return 'Please Enter a valid Address';
                                }
                                else {
                                  return null;
                                }
                              },
                              style:  TextStyle(color: fieldColor),
                              decoration:  InputDecoration(
                                hintText: 'Address',
                                hintStyle: TextStyle(color: fieldColor),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: fieldBorderColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: fieldFocusColor),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: fieldErrorColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25,),
                          _isLoading
                          ?
                          Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              child: const CircularProgressIndicator(),
                            ),
                          )
                          :
                          MaterialButton(
                            onPressed: (){
                              _submitFormSignUP();
                            },
                            color: buttonColor,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [
                                  Text(
                                    'SignUp',
                                    style: TextStyle(
                                      color: buttonTextColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ) ,
                            ),
                          ),
                          const SizedBox(height: 40,),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                  children: [
                                     TextSpan(
                                      text: 'Already have a account ?',
                                      style: TextStyle(
                                        color: buttonTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const TextSpan(text: '      '),
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap=()=> Navigator.canPop(context)
                                        ? Navigator.pop(context)
                                        : null,
                                      text: 'Login',
                                      style: TextStyle(
                                        color: buttonColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          )

                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
