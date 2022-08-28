
// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moaveen/authScreens/forget_password_screen.dart';
import 'package:moaveen/Services/global_methods.dart';
import 'package:moaveen/Services/global_variables.dart';
import 'package:moaveen/authScreens/signup_screen.dart';


class Login extends StatefulWidget {


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {

  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _emailTextController = TextEditingController(
      text: '');
  final TextEditingController _passTextController = TextEditingController(
      text: '');

  final FocusNode _passFocusNode = FocusNode();
  bool _obscureText = true;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
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

  void _submitFormOnLogin() async
  {
    final isValid = _loginFormKey.currentState!.validate();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim(),
        );
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      }catch(error){
        setState(() {
          _isLoading=false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print('Error Occurred');
      }
    }
    setState(() {
      _isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            placeholder: (context, url) =>
                Image.asset(
                  logoInImage,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
              child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 80, right: 80),
                      child: Image.asset(logoImage),
                    ),
                    const SizedBox(height: 15,),
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
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
                            style:  TextStyle(color: fieldColor),
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
                          const SizedBox(height: 5,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _passFocusNode,
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
                              hintStyle:TextStyle(color: fieldColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: fieldBorderColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:fieldFocusColor),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: fieldErrorColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ForgetPassword()));
                              },
                              child: Text(
                                'Forget Password',
                                style: TextStyle(
                                  color: buttonTextColor,
                                  fontSize: 17,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          MaterialButton(
                            onPressed: _submitFormOnLogin,
                            color: buttonColor,//green
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Login',
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
                          const SizedBox(height: 40,),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                   TextSpan(
                                    text: 'Do not have a account ?',
                                    style: TextStyle(
                                      color: buttonTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const TextSpan(text: '      '),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                        ..onTap=()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp())),
                                    text: 'SignUp',
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
                      ),
                    ),
                  ]
              ),
            ),
          ),

        ],
      ),
    );
  }
}
