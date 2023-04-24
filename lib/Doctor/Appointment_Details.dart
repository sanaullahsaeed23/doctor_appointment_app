// import 'dart:io';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../common/RoundButton.dart';
import '../common/formhelper.dart';
import '../constants/colors.dart';
import '../constants/size.dart';
import '../constants/textSize.dart';

class AppointmentDetails extends StatefulWidget {
  var appointmentId;

  AppointmentDetails({Key? key, this.appointmentId}) : super(key: key);

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {

  var appointmentId, patientName;
  TextEditingController feedbackController = TextEditingController();
  bool _isloading = false;
  TextEditingController appointmentTimeController = TextEditingController();
  DateTime? appointmentTimeValue;



  @override
  Widget build(BuildContext context) {
    final appointment_time = DateTimeField(
        validator: (value) {
          if (value! == null) {
            return ("Appointment Date cannot be Empty");
          }
          return null;
        },
        controller: appointmentTimeController,
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
    final divider = Divider(
      thickness: 3,
      color: Colors.grey.shade300,
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text("Appointment Details"),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(comDefaultSize),
          child: Container(
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('Patient Appointments')
                      .doc(widget.appointmentId)
                      .get(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      print("Something went wrong");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var data = snapshot.data!.data();

                    // Getting all the fields of the civil Processes
                    appointmentId = data!['appointment_id'];
                    patientName = data['Name'];
                    var mobileNumber = data['Mobile'];
                    var disease = data['Disease'];
                    var age = data['Age'];
                    var address = data['Address'];
                    var appointmentTime = DateFormat('dd-MMM-yyyy hh:mm:ss a')
                        .format(data['Appointment_Time'].toDate());

                    print("Name $patientName");
                    print("Category ${widget.appointmentId}");

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            const Text('Patient Name:', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:(formText),
                            ),),
                            TextFormField(
                              initialValue: patientName,
                              decoration: getInputDecoration(
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            const Text('Mobile #:', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:(formText),
                            ),),
                            TextFormField(
                              initialValue: mobileNumber,
                              decoration: getInputDecoration(
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            const Text('Disease:', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:(formText),
                            ),),
                            TextFormField(
                              initialValue: disease,
                              decoration: getInputDecoration(
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            divider,


                            const SizedBox(
                              height: 10,
                            ),
                            const Text('Age:', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:(formText),
                            ),),
                            TextFormField(
                              initialValue: age,
                              decoration: getInputDecoration(
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            const Text('Address:', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:(formText),
                            ),),
                            TextFormField(
                              initialValue: address,
                              decoration: getInputDecoration(
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            const Text('Appointment Time:', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:(formText),
                            ),),
                            TextFormField(
                              initialValue: appointmentTime,
                              decoration: getInputDecoration(
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            Column(
                              children: [

                                RoundButton(
                                    title:  data['Appointment_Status'] != 'Appointment Fixed' ?
                                    'Accept Appointment' : 'Appointment Fixed',
                                onTap: data['Appointment_Status'] == 'Appointment Fixed' ? (){} :
                                    (){
                                     setState(() {
                                        _isloading = true;
                                      });
                                     postToDatabase();

                                } ,
                                color: data['Appointment_Status'] != 'Appointment Fixed' ?
                                Colors.blue : Colors.grey,
                                  loading: _isloading,
                             ),
                                SizedBox(height: 6,),
                                data['Appointment_Status'] != 'Appointment Fixed' ? RoundButton(
                                    title: 'Change Appointment',
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return
                                            AlertDialog(
                                              title: const Text('Actions'),
                                              content: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      appointment_time,
                                                    ],
                                                  )
                                              ),
                                              actions: [
                                                RoundButtonClose(title: 'Submit', color: Colors.blue,
                                                    onTap: (){
                                                      FirebaseFirestore.instance
                                                          .collection('Patient Appointments')
                                                          .doc(widget.appointmentId)
                                                          .set(
                                                        {
                                                          'Appointment_Status': 'Appointment Fixed',
                                                          'Appointment_Time': appointmentTimeValue,
                                                        },
                                                        SetOptions(merge: true),
                                                      ).whenComplete(() {
                                                            Navigator.pop(context);
                                                        setState(() {
                                                          _isloading = false;
                                                        });
                                                        Fluttertoast.showToast(
                                                            msg: "Appointment with $patientName Accepted at $appointmentTimeValue",
                                                            toastLength: Toast.LENGTH_LONG,
                                                            gravity: ToastGravity.BOTTOM,
                                                            backgroundColor: Colors.teal,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0
                                                        );
                                                      });
                                                })
                                              ],
                                            );
                                        },
                                      );
                                    },
                                color: Colors.green,
                                ) : Container(),

                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
        ));
  }

  postToDatabase() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    firebaseFirestore
        .collection('Patient Appointments')
        .doc(widget.appointmentId)
        .set(
      {
        'Appointment_Status': 'Appointment Fixed',
      },
      SetOptions(merge: true),
    ).whenComplete(() {
      setState(() {
        _isloading = false;
      });
      Fluttertoast.showToast(
          msg: "Appointment with $patientName Accepted",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }




}



