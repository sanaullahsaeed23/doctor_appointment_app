import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../common/RoundButton.dart';
import '../common/formhelper.dart';
import '../constants/textSize.dart';

class DashboardEdit extends StatefulWidget {
  DashboardEdit({Key? key}) : super(key: key);

  @override
  State<DashboardEdit> createState() => _DashboardEditState();
}

class _DashboardEditState extends State<DashboardEdit> {

  // Image Picker
  String _fileText = "";
  //image
  List<File> multpleImages = [];
  List<String?> names = [];
  //IMAGE URL
  List<String>? url;

  bool _isLoading = false;
  var uuid;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController specilizationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController hospitalNameController = TextEditingController();
  TextEditingController hospitalDescriptionController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();


  ImagePicker picker = ImagePicker();
  var _image;
  var fileName;
  String? doctorEmail;
  String profileUrl = '';
  var mediaFiles,  downloadProgress = "0";

  var maskFormatter = MaskTextInputFormatter(
      mask: '#### #######',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      doctorEmail = FirebaseAuth.instance.currentUser?.email;
    });
    FirebaseFirestore.instance.collection('Doctor Profiles').doc(doctorEmail).get()
        .then((documentSnapshot) {
      var data = documentSnapshot.data();
      nameController.text = data!['Name'];
      specilizationController.text = data['Specialization'];
      contactController.text = data['Contact'];
      descriptionController.text = data['Description'];
      hospitalNameController.text = data['HospitalName'];
      hospitalDescriptionController.text = data['HospitalDescription'];
      cityNameController.text = data['City'];
      profileUrl = data['Profile'];
      mediaFiles = data['Hospital_Images'];

      setState(() {

      });

  });
        }

  @override
  Widget build(BuildContext context) {
    final doctorName = TextFormField(
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
    final specilization = TextFormField(
        autofocus: false,
        controller: specilizationController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Specialization cannot be Empty ");
          }

          return null;
        },
        onSaved: (value) {
          specilizationController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: getInputDecoration(hintText: 'Enter Specialization'));
    final contactNo = TextFormField(
        autofocus: false,
        controller: contactController,
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
          contactController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: getInputDecoration(hintText: '0300 0000000'));
    final doctorDescription = TextFormField(
        autofocus: false,
        controller: descriptionController,
        minLines: 5,
        maxLines: 15,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(r'^.{5,}$');
          if (!regex.hasMatch(value!)) {
            return ("Specialization cannot be Empty (Must be 5Characters)");
          }

          return null;
        },
        onSaved: (value) {
          descriptionController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: getInputDecoration(hintText: 'Enter Specialization'));
    final hospitalName = TextFormField(
        autofocus: false,
        controller: hospitalNameController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Hospital cannot be Empty");
          }

          return null;
        },
        onSaved: (value) {
          hospitalNameController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: getInputDecoration(hintText: 'Enter Hospital Name'));
    final hospitalDescription = TextFormField(
        autofocus: false,
        controller: hospitalDescriptionController,
        minLines: 5,
        maxLines: 15,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(r'^.{5,}$');
          if (!regex.hasMatch(value!)) {
            return ("Specialization cannot be Empty (Must be 5Characters)");
          }

          return null;
        },
        onSaved: (value) {
          hospitalDescriptionController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: getInputDecoration(hintText: 'Enter Specialization'));
    final cityName = TextFormField(
        autofocus: false,
        controller: cityNameController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Hospital cannot be Empty");
          }

          return null;
        },
        onSaved: (value) {
          cityNameController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: getInputDecoration(hintText: 'Enter City Name'));

    print("ProfileUrl: $profileUrl");
    final choose_profile = Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade200,
              radius: 70,
              child:
              profileUrl != '' && _image == null ? CircleAvatar(
                radius: 65,
                backgroundImage: NetworkImage(profileUrl),
              ) : _image != null ? CircleAvatar(
                    radius: 65,
                    backgroundImage: _image,
                  ) :
              CircleAvatar(
                  backgroundColor: Colors.blue.shade200,
                child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey[800],
                        ),
              ),
            ),
          ),
          Positioned(
              left: 103,
              // // top: 30,
              width: 37,
              // height: 37,
              child: GestureDetector(
                onTap: () async {
                  var image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50,);
                  // final path = image!.path;
                  // final bytes = await File(path).readAsBytes();
                  setState(() {
                    _image = FileImage(File(image!.path));
                    fileName = image.name;
                    print("FileName: $fileName");
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                    child: const Icon(Icons.add_photo_alternate_outlined)),
              )),
        ],
      ),
    );

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
                        labels("Add Profile Picture"),
                        const SizedBox(
                          height: 10,
                        ),
                        choose_profile,
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labels("Name *"),
                        const SizedBox(
                          height: 10,
                        ),
                        doctorName,
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labels("Specialization *"),
                        const SizedBox(
                          height: 10,
                        ),
                        specilization,
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labels("Contact *"),
                        const SizedBox(
                          height: 10,
                        ),
                        contactNo,
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labels("Describe Yourself *"),
                        const SizedBox(
                          height: 10,
                        ),
                        doctorDescription,
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labels("Your Location/City"),
                        const SizedBox(
                          height: 10,
                        ),
                        cityName,
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labels("Hospital Name *"),
                        const SizedBox(
                          height: 10,
                        ),
                        hospitalName,
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labels("Describe Your Hospital *"),
                        const SizedBox(
                          height: 10,
                        ),
                        hospitalDescription,
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    //Images code
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Text("Previous Attachments: ",
                    //       style: headingSize,),
                    //     const SizedBox(height: 15,),
                    //     mediaFiles != null ?
                    //     SingleChildScrollView(
                    //       scrollDirection: Axis.horizontal,
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: mediaFiles
                    //             .map((fileurl) =>
                    //             Container(
                    //               margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    //               width: 150,
                    //               height: 125,
                    //               color: Colors.grey.shade400,
                    //               child: Stack(
                    //                 children: [
                    //                   Positioned(
                    //                     left: 8,
                    //                     top: 17,
                    //                     right: 0,
                    //                     bottom: 0,
                    //                     child: InkWell(
                    //                       onTap: () async {
                    //                         fileName = _getFileName(fileurl);
                    //
                    //                         // String filename = path.basename(url);
                    //                         print("FileName: $fileName");
                    //                         // String fileExtension = path.extension(url);
                    //                         // print("Extension: $fileExtension");
                    //                         // Create a Dio instance
                    //                         var dio = Dio();
                    //                         // Get the directory to save the file
                    //                         var dir =
                    //                         await getExternalStorageDirectory();
                    //                         print("Dir: $dir");
                    //                         // Create a custom folder in the directory
                    //                         var customDir =
                    //                         Directory('${dir!.path}/Doctor Appointment');
                    //                         print("Custom: $customDir");
                    //
                    //                         if (await File(
                    //                             '${customDir.path}/$fileName')
                    //                             .exists()) {
                    //                           print("File Already Present");
                    //
                    //                           var filepath =
                    //                               '${customDir.path}/$fileName';
                    //                           await OpenFile.open(filepath);
                    //                         } else {
                    //                           print("File Not Present");
                    //                           setState(() {
                    //                             _isLoading == true;
                    //                           });
                    //
                    //                           if (!await customDir.exists()) {
                    //                             customDir.create();
                    //                           }
                    //                           // Download the file
                    //                           var response = await dio.download(
                    //                               fileurl, '${customDir.path}/$fileName',
                    //                               onReceiveProgress:
                    //                                   (received, total) async {
                    //                                 if (total != -1) {
                    //                                   setState(() {
                    //                                     downloadProgress =
                    //                                         (received / total * 100)
                    //                                             .toStringAsFixed(0);
                    //                                   });
                    //                                 }
                    //                                 if (total != -1 &&
                    //                                     received == total) {
                    //                                   setState(() {
                    //                                     _isLoading == false;
                    //                                   });
                    //                                   //  Opening
                    //                                   var filepath =
                    //                                       '${customDir.path}/$fileName';
                    //                                   await OpenFile.open(filepath);
                    //                                 }
                    //                               });
                    //                           print(response.data);
                    //                         }
                    //                       },
                    //                       child: Column(
                    //                         children: [
                    //                           Visibility(
                    //                             visible: _isLoading == false,
                    //                             child:
                    //                             fileurl.contains('.pdf')
                    //                                 ? const Icon(
                    //                               Icons.picture_as_pdf,
                    //                               size: 70,
                    //                               color: Colors.green,
                    //                             )
                    //                                 : fileurl.contains('.mp4')
                    //                                 ? const Icon(
                    //                               Icons
                    //                                   .video_camera_back_outlined,
                    //                               size: 70,
                    //                               color: Colors.green,
                    //                             )
                    //                                 : fileurl.contains('.png')
                    //                                 ? const Icon(
                    //                               Icons.image,
                    //                               size: 70,
                    //                               color: Colors.green,
                    //                             )
                    //                                 : const Icon(
                    //                               Icons
                    //                                   .file_copy_outlined,
                    //                               size: 70,
                    //                               color: Colors.green,
                    //                             ),
                    //                           ),
                    //                           Visibility(
                    //                               visible: _isLoading == true,
                    //                               child: CircularProgressIndicator(
                    //                                 backgroundColor: Colors.teal[400],
                    //                                 valueColor: AlwaysStoppedAnimation(Colors.blue),
                    //                                 strokeWidth: 5.0,
                    //                               ))
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Positioned(
                    //                       left: 7,
                    //                       top: 103,
                    //                       right: 7,
                    //                       bottom: 0,
                    //                       child: Text(_getFileName(fileurl),
                    //                         style: const TextStyle(
                    //                             overflow: TextOverflow.ellipsis
                    //                         ),)),
                    //                 ],
                    //               ),
                    //             ))
                    //             .toList()
                    //             .cast<Widget>(),
                    //       ),
                    //     )
                    //         :
                    //     Center(
                    //       child: Text(
                    //         "No Files Attached !!",
                    //         style: lowErrorSize,
                    //       ),
                    //     )
                    //     ,
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Center(
                    //   child: names.isEmpty
                    //       ? const Text(
                    //     'No Attachments',
                    //     style: TextStyle(
                    //       color: Colors.red,
                    //       fontSize: 13,
                    //     ),
                    //   )
                    //       : SizedBox(
                    //     width: double.infinity,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //
                    //         const Text("Attachments", style: headingSize,),
                    //         SizedBox(height: 6,),
                    //
                    //
                    //         Wrap(
                    //           children: names
                    //               .map(
                    //                 (e) =>
                    //                 Column(
                    //                   children: [
                    //                     Text(e!,
                    //                       maxLines: 2,
                    //                       overflow: TextOverflow.ellipsis,),
                    //                     Divider(color: Colors.grey,)
                    //                   ],
                    //                 ),
                    //           ).toList(),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    //
                    //
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // Material(
                    //   elevation: 1, //shadow
                    //   borderRadius: BorderRadius.circular(5),
                    //   color: Colors.grey,
                    //   child: SizedBox(
                    //     width: 100,
                    //     child: TextButton(
                    //         onPressed: ()  async {
                    //           multpleImages =
                    //           await _pickMultipleFiles();
                    //           setState(() {
                    //             print(
                    //                 'UserComplaint image are: $multpleImages');
                    //           }
                    //           );
                    //         },
                    //         child: const Text(
                    //           "Attach File(s) ",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               fontSize: 16,
                    //               color: Colors.black,
                    //               fontWeight: FontWeight.bold),
                    //         )),
                    //   ),
                    // ),

                    const SizedBox(
                      height: 15,
                    ),

                    RoundButton(
                      title: 'Submit',
                      loading: _isLoading,
                      onTap: () async {
                        if (_formKey.currentState!.validate() ) {
                          setState(() {
                            _isLoading = true;
                          });
                          String d = DateTime.now().millisecondsSinceEpoch.remainder(10000).toString();
                          uuid = 'ADMIN$d';
                          url = await multiImageUploader(multpleImages);
                          // mediaFiles.map((e) => url?.add(e));
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

  uploadFiles() async {

      Reference reference =
      FirebaseStorage.instance.ref().child("Doctors/Profiles/${nameController.text}/$fileName");
      await reference.putFile(File(_image.file.path)).whenComplete(() async {
        await reference.getDownloadURL().then((url) {
          FirebaseFirestore.instance
              .collection("Admin Contacts")
              .doc(uuid)
              .set(
            {
              'Profile': url,
            },
            SetOptions(merge: true),
          ).whenComplete(() {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "Profile Updated Successfully !!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.teal,
                textColor: Colors.white,
                fontSize: 16.0
            );
          });
        });
      });


  }

  postToDatabase() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    firebaseFirestore
        .collection("Doctor Profiles")
        .doc(doctorEmail)
        .set(
      {
        'id': uuid,
        'Name': nameController.text,
        'Specialization': specilizationController.text,
        'DoctorEmail': doctorEmail,
        'Contact': contactController.text,
        'City': cityNameController.text,
        'Description': descriptionController.text,
        'HospitalName': hospitalNameController.text,
        'HospitalDescription': hospitalDescriptionController.text,
        'Hospital_Images': url,
        'Profile': "",

      },
      SetOptions(merge: true),
    ).whenComplete(() {
      if(_image != null){
      uploadFiles();}else{
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Profile Updated Successfully !!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  Future<List<File>> _pickMultipleFiles() async {
    List<File> files = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      names = result.names;

      print("NAMES : $names");
      setState(() {
        _fileText = files.toString();
      });
      print('Hasnain image folder is : $_fileText');
    } else {
      // User canceled the picker
    }
    return files;
  }

  /// Multiple image uploader
  Future<List<String>> multiImageUploader(List<File> list) async {
    List<String> _path = [];
    for (File _images in list) {
      _path.add(await UploadImage(_images));
    }
    return _path;
  }

  Future<String> UploadImage(File image) async {
    Reference db =
    FirebaseStorage.instance.ref("UserComplaindata/$uuid/${getImageName(image)}");
    await db.putFile(File(image.path));
    return await db.getDownloadURL();
  }
  //return Image name
  String getImageName(File image) {
    return image.path.split("/").last;
  }

  //Get file name from firebase storage url
  String _getFileName(String url){
    RegExp regExp = RegExp(r'.+(\/|%2F)(.+)\?.+');
    //This Regex won't work if you remove ?alt...token
    var matches = regExp.allMatches(url);

    var match = matches.elementAt(0);
    print("${Uri.decodeFull(match.group(2)!)}");
    return Uri.decodeFull(match.group(2)!);
  }
}
