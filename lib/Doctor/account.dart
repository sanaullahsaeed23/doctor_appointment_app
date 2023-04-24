import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorappotments/Bottom%20Navigation/DoctorBottomNavigation.dart';
import 'package:doctorappotments/ath/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  Uint8List? _imageBytes;
  ImagePicker picker = ImagePicker();
  var _image;
  var fileName;
  String? id ;
  String? doctorName, doctorEmail;
  String profileUrl = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      doctorEmail = FirebaseAuth.instance.currentUser?.email;
    });


    FirebaseFirestore.instance.collection('Doctor Profiles').doc(doctorEmail).get()
        .then((documentSnapshot) {
      var data = documentSnapshot.data();
      profileUrl = data!['Profile'];
      setState(() {

      });

    });

  }
  @override
  Widget build(BuildContext context) {
    final choose_profile = Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: CircleAvatar(
        backgroundColor: Colors.blue.shade200,
        radius: 70,
        child:
        profileUrl != '' ? CircleAvatar(
          radius: 65,
          backgroundImage: NetworkImage(profileUrl),
        )
            :
        CircleAvatar(
          backgroundColor: Colors.blue.shade200,
          child: Icon(
            Icons.person,
            size: 40,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Setting'),
          elevation: 0,
          leading: IconButton(
              onPressed: () =>Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BottomNaviDoctor()),
              ),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
                children: [
                  const SizedBox(
                    height:20,
                  ),

                  choose_profile,
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [

                        const SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Color(0xFFF5F6F9),
                          ),
                          onPressed: () {
                              FirebaseAuth.instance.signOut();

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()));
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.logout),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("LOG OUT")),
                              // Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

        ),
      ),
    );
  }

}
