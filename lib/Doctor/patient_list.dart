import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorappotments/Doctor/Appointment_Details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/textSize.dart';


class PatientsList extends StatefulWidget {
  var categoryName, complainStatus;
  PatientsList({Key? key, this.categoryName, this.complainStatus}) : super(key: key);

  @override
  State<PatientsList> createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  String? doctorEmail;
  @override
  void initState() {
    super.initState();
    setState((){
      doctorEmail = FirebaseAuth.instance.currentUser?.email;
    });
    print("DoctorEmail: $doctorEmail");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad
        },
      ),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: Text("Patient List"),
          ),
          body: Container(
              width: double.maxFinite,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Patient Appointments')
                      .where('doctor_id', isEqualTo: doctorEmail)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text('Loading...'));
                    }
                    if (snapshot.data!.size == 0) {
                      return const Center(
                          child: Text("No Patient Found...", style: headingSize,));
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something Went Wrong'));
                    }

                    final data = snapshot.requireData;

                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: ListTile(
                              // contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                              onTap: () {
                                String id = snapshot.data!.docs[index]['appointment_id'];
                                print("ComplainId: $id");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentDetails(
                                              appointmentId: id,
                                            )));

                              },
                              //three properties of listile Have Added Here
                              leading: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                child: Icon(Icons.list_alt_sharp),
                              ),
                              title: Text(
                                  snapshot.data!.docs[index]['Name'].toString()
                              ),
                              subtitle: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 4.0),
                                  Text(
                                    snapshot.data!.docs[index]['Disease'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(
                                    DateFormat('dd-MM-yyyy').format(
                                        snapshot.data!.docs[index]['Appointment_Time'].toDate()),
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('hh:mm a').format(
                                        snapshot.data!.docs[index]['Appointment_Time'].toDate()),
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              tileColor:
                              Colors.blue.withOpacity(0.2),
                            )


                        );
                        // }
                      },
                      // builder: (BuildContext context, int index) {
                      //   return Divider(color: Colors.white,);
                      // },
                    );
                  }))),
    );
  }
}
