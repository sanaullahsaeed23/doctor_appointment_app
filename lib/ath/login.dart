import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorappotments/Bottom%20Navigation/DoctorBottomNavigation.dart';
import 'package:doctorappotments/Bottom%20Navigation/UserBottomNav.dart';
import 'package:doctorappotments/ath/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
bool _isButtonLoading = false;
  String? designationDropdown;
  // Create storage
  // form key
  final _formKey = GlobalKey<FormState>();
  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // firebase
  final _auth = FirebaseAuth.instance;
  // string for displaying the error Message
  String? errorMessage;


  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        //most important
        //here we write validation which type data it will get
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //Button
    final loginButton = Material(
      elevation: 5, //shadow
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
      child:MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            setState(() {
              _isButtonLoading = true;
            });
            signIn(emailController.text, passwordController.text);
          },
          child: _isButtonLoading == true ? CircularProgressIndicator(color: Colors.white.withOpacity(0.8),) :
          const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //Scaffold
    return SafeArea(
      child: Scaffold(
        //UI START FROM HERE
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          reverse: true,
          child: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset(
                            "assets/logindoc.png",
                            fit: BoxFit.cover,
                          )),
                      const SizedBox(height: 20),
                      const Text('LOGIN PAGE',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),),
                      const SizedBox(height: 50),
                      SizedBox(
                        height: 60,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                // borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color:Colors.red),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              prefixIcon: Icon(Icons.person)

                          ),
                          validator: (value) => value == null
                              ? "Status can't be Empty" : null,
                          onSaved: (value) {
                            designationDropdown = value!;
                          },
                          onChanged: (String? newValue) {
                            // setState(() {
                            designationDropdown = newValue!;
                            // });
                          },
                          hint: const Text("Select Designation",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          items: <String>[
                            'Doctor',
                            'User',
                            'Representative',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      emailField,
                      const SizedBox(height: 15),

                      passwordField,
                      const SizedBox(height: 25),
                      loginButton,
                      const SizedBox(height: 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const signup()));
                              },
                              child: const Text(
                                "SignUp",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )
                          ])
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Login Main Function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) async => {
          if(designationDropdown == "Doctor"){
            await FirebaseFirestore.instance
                .collection("Doctors Accounts")
                .doc(_auth.currentUser!.uid)
                .get()
                .then((doc) {
              bool exist = doc.exists;
              if (exist) {
                setState(() {
                  _isButtonLoading = false;
                });
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const BottomNaviDoctor()));
                Fluttertoast.showToast(msg: "Login Successful");
              } else {
                setState(() {
                  _isButtonLoading = false;
                });
                Fluttertoast.showToast(
                    msg:
                    "No account found for this email. Register/Signup");
              }
            })
          },
          if(designationDropdown == "User"){
            await FirebaseFirestore.instance
                .collection("Users Accounts")
                .doc(_auth.currentUser!.uid)
                .get()
                .then((doc) {
              bool exist = doc.exists;
              if (exist) {
                setState(() {
                  _isButtonLoading = false;
                });
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const UserBottomNavi()));
                Fluttertoast.showToast(msg: "Login Successful");
              } else {
                setState(() {
                  _isButtonLoading = false;
                });
                Fluttertoast.showToast(
                    msg:
                    "No account found for this email. Register/Signup");
              }
            })
          },
          if(designationDropdown == "Representative"){
            await FirebaseFirestore.instance
                .collection("Representative Accounts")
                .doc(_auth.currentUser!.uid)
                .get()
                .then((doc) {
              bool exist = doc.exists;
              if (exist) {
                setState(() {
                  _isButtonLoading = false;
                });
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const UserBottomNavi()));
                Fluttertoast.showToast(msg: "Login Successful");
              } else {
                setState(() {
                  _isButtonLoading = false;
                });
                Fluttertoast.showToast(
                    msg:
                    "No account found for this email. Register/Signup");
              }
            })
          }
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}