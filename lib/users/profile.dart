import 'dart:convert';
import 'dart:typed_data';
import 'package:doctorappotments/ath/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Bottom Navigation/UserBottomNav.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  Uint8List? _imageBytes;
  ImagePicker picker = ImagePicker();

  void _loadImageBytes() async {
    final prefs = await SharedPreferences.getInstance();
    final imageBytesString = prefs.getString('imageBytes');
    if (imageBytesString != null) {
      final imageBytes = base64Decode(imageBytesString);
      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  void _saveImageBytes(Uint8List imageBytes) async {
    final prefs = await SharedPreferences.getInstance();
    final imageBytesString = base64Encode(imageBytes);
    prefs.setString('imageBytes', imageBytesString);
  }

  Future _getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final bytes = await image!.readAsBytes();
    _saveImageBytes(bytes);
    setState(() {
      _imageBytes = bytes;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
  }

  @override
  Widget build(BuildContext context) {
    final chooseProfile = Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 70,
              child: _imageBytes != null ? CircleAvatar(
                radius: 65,
                backgroundImage: MemoryImage(_imageBytes!),
              )  :
              const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
              left: 103,
              top: 90,
              width: 37,
              // height: 37,
              child: GestureDetector(
                onTap: () async {
                  // var image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50,);
                  _getImage();
                },
                child: const CircleAvatar(
                    backgroundColor: Color(0xFFe7edeb),
                    child: Icon(Icons.camera)),
              )),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: const Text('My Account'),
          leading:InkWell(
              onTap: ()=>Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserBottomNavi()),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white,)
          )
      ),
      body: Column(
        children: [
          const SizedBox(
            height:20,
          ),
          chooseProfile,
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async =>{
                    logout(context),
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.white,),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Text("LOG OUT", style: TextStyle(
                        color: Colors.white
                      ),))
                      // Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
    // );
  }
}
