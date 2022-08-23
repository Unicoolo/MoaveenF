import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moaveen/Services/global_methods.dart';
import 'package:moaveen/Services/global_variables.dart';
import 'package:moaveen/Widgets/bottom_nav_bar.dart';
import 'package:moaveen/constants/constants.dart';
import 'package:uuid/uuid.dart';

class UploadTask extends StatefulWidget {
  @override
  _UploadTaskState createState() => _UploadTaskState();
}

class _UploadTaskState extends State<UploadTask> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _taskCategoryController = TextEditingController(text: 'Choose category');
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  final TextEditingController _deadlineDateController = TextEditingController(text: 'Choose Deadline date');

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _taskCategoryController.dispose();
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    _deadlineDateController.dispose();
  }

  void _uploadTask() async {
    final taskID = Uuid().v4();
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_deadlineDateController.text == 'Choose Deadline date' ||
          _taskCategoryController.text == 'Choose category') {
        GlobalMethod.showErrorDialog(
            error: 'Please Fill Everything', ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('tasks').doc(taskID).set({
          'taskId': taskID,
          'uploadedBy': _uid,
          'taskTitle': _taskTitleController.text,
          'taskDescription': _taskDescriptionController.text,
          'deadlineDate': _deadlineDateController.text,
          'deadlineDateTimeStamp': deadlineDateTimeStamp,
          'taskCategory': _taskCategoryController.text,
          'taskComments': [],
          'isDone': false,
          'createdAt': Timestamp.now(),
        });
        await Fluttertoast.showToast(
            msg: "The Request has been uploaded",
            toastLength: Toast.LENGTH_LONG,
            // gravity: ToastGravity.,
            backgroundColor: Colors.grey,
            fontSize: 18.0);
        _taskTitleController.clear();
        _taskDescriptionController.clear();
        setState(() {
          _taskCategoryController.text = 'Choose category';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.darkBlue),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      //drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(7),
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'All Field are required',
                      style: TextStyle(
                        color: Constants.darkBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 1,
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
                            valueKey: 'TaskCategory',
                            controller: _taskCategoryController,
                            enabled: false,
                            fct: () {
                              _showTaskCategoriesDialog(size: size);
                            },
                            maxLength: 100),
                        //title
                        _textTitles(label: 'Title*'),
                        _textFormFields(
                            valueKey: 'TaskTitle',
                            controller: _taskTitleController,
                            enabled: true,
                            fct: () {},
                            maxLength: 100),
                        //description
                        _textTitles(label: 'Description*'),
                        _textFormFields(
                            valueKey: 'TaskDescription',
                            controller: _taskDescriptionController,
                            enabled: true,
                            fct: () {},
                            maxLength: 1000),
                        //deadline date
                        _textTitles(label: 'Deadline date*'),
                        _textFormFields(
                            valueKey: 'Taskdeadline',
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
                            onPressed: _uploadTask,
                            color: buttomColor,
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
          style: TextStyle(
              color: Constants.darkBlue,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          maxLines: valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.pink),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Category',
              style: TextStyle(fontSize: 20, color: Colors.pink.shade800),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.taskCategoryList.length,
                  itemBuilder: (ctxx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _taskCategoryController.text =
                              Constants.taskCategoryList[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.red.shade200,
                          ),
                          // SizedBox(width: 10,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.taskCategoryList[index],
                              style: TextStyle(
                                  color: Constants.darkBlue,
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
          color: Colors.pink[800],
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
