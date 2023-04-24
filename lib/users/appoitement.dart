import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import '../common/RoundButton.dart';
import '../common/formhelper.dart';

class Appointments extends StatefulWidget {
  var doctorEmailId;
  Appointments({
    Key? key,
    this.doctorEmailId,
  }) : super(key: key);
  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  // form key
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();
  TextEditingController appointmentController = TextEditingController();

  String? from;
  String? userid = FirebaseAuth.instance.currentUser?.uid;

  var appointmentId;

  // Image Picker
  //image
  List<File> multpleImages = [];
  List<String?> names = [];
  //IMAGE URL
  List<String>? url;
  String? scholarshipId;
  var maskFormatter = MaskTextInputFormatter(
      mask: '#### #######',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );
DateTime? appointmentTimeValue;
  @override
  Widget build(BuildContext context) {
    final Name = TextFormField(
        autofocus: false,
        controller: nameController,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(r'^.{5,}$');
          if (!regex.hasMatch(value!)) {
            return ("Name cannot be Empty (Must be 5 Characters)");
          }

          return null;
        },
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: getInputDecoration(hintText: 'Enter Name'));
    final age = TextFormField(
        autofocus: false,
        controller: ageController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Age cannot be Empty ");
          }

          return null;
        },
        onSaved: (value) {
        ageController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: getInputDecoration(hintText: 'Enter Age'));
    final mobile = TextFormField(
        autofocus: false,
        controller: mobileController,
        keyboardType: TextInputType.phone,
        inputFormatters: [maskFormatter,],
        validator: (value) {
          RegExp regex = RegExp(r'^.{11,}$');
          if (value!.isEmpty) {
            return ("Contact Number cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Number(11 Characters)");
          }

          return null;
        },
        onSaved: (value) {
          mobileController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: getInputDecoration(hintText: '0300 0000000'));
    final address = TextFormField(
        autofocus: false,
        controller: addressController,
        minLines: 5,
        maxLines: 15,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(r'^.{5,}$');
          if (!regex.hasMatch(value!)) {
            return ("Address cannot be Empty (Must be 5Characters)");
          }

          return null;
        },
        onSaved: (value) {
          addressController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: getInputDecoration(hintText: 'Enter Address'));
    final appointmentTime = DateTimeField(
        validator: (value) {
          if (value! == null) {
            return ("Appointment Date cannot be Empty");
          }
          return null;
        },
        controller: appointmentController,
        format: DateFormat('EEEE, dd-MMMM-yyyy hh:mm:ss a'),
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.calendar_month_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              initialDate: currentValue ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
                context: context,
                initialTime:
                TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
            setState(() {
              appointmentTimeValue = DateTimeField.combine(date, time);
            });
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        });
    final disease = TextFormField(
        autofocus: false,
        controller: diseaseController,
        minLines: 5,
        maxLines: 15,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Disease cannot be Empty");
          }

          return null;
        },
        onSaved: (value) {
          diseaseController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: getInputDecoration(hintText: 'Enter Disease'));


    labels(String label) {
      return Text(
        label,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Dashboard"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: [


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labels("Name *"),
                    const SizedBox(
                      height: 10,
                    ),
                    Name,
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labels("Age *"),
                    const SizedBox(
                      height: 10,
                    ),
                    age,
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labels("Disease *"),
                    const SizedBox(
                      height: 10,
                    ),
                    disease,
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labels("Mobile # *"),
                    const SizedBox(
                      height: 10,
                    ),
                    mobile,
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labels("Appointment Time"),
                    const SizedBox(
                      height: 10,
                    ),
                    appointmentTime,
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labels("Address"),
                    const SizedBox(
                      height: 10,
                    ),
                    address,
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),

                RoundButton(
                  title: 'Submit',
                  loading: _isLoading,
                  onTap: (){
                    if (_formKey.currentState!.validate() ) {
                      setState(() {
                        _isLoading = true;
                      });
                      String d = DateTime.now().millisecondsSinceEpoch.remainder(10000).toString();
                      appointmentId = 'APN$d';
                      postToDatabase();

                    }
                  }, color: Colors.blue,
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }

  // Posting data to firebase function
  postToDatabase() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    firebaseFirestore
        .collection("Patient Appointments")
        .doc(appointmentId)
        .set(
      {
        'Name': nameController.text,
        'Age': ageController.text,
        'Disease': diseaseController.text,
        'Mobile': mobileController.text,
        'Address': addressController.text,
        'Appointment_Time':appointmentTimeValue,
        'Appointment_Status': 'Null',
        'appointment_id': appointmentId,
        'doctor_id': widget.doctorEmailId,
      },
      SetOptions(merge: true),
    ).whenComplete(() {
     setState(() {
       _isLoading = false;
     });
     Fluttertoast.showToast(
         msg: "Appointment Request Send to Doctor",
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.green,
         textColor: Colors.white,
         fontSize: 16.0
     );
    })
    .onError((error, stackTrace){
      setState((){
        _isLoading= false;
      });
      Fluttertoast.showToast(
          msg: "Something went wrong try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }
}
