import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:doctorappotments/common/RoundButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../common/formhelper.dart';
import '../constants/textSize.dart';
import '../users/appoitement.dart';


class Doctordetail extends StatefulWidget {
  String email;
  Doctordetail(this.email, {Key? key}) : super(key: key);
  @override
  State<Doctordetail> createState() => _DoctordetailState();
}
class _DoctordetailState extends State<Doctordetail> {
  var fileName, downloadProgress = "0";
bool _isLoading = false;

  //Init State
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Doctor Detail'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15),
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('Doctor Profiles')
              .doc(widget.email)
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
            // Reading all the fields of the civil Processes
            var email = data!['DoctorEmail'];
            var name = data['Name'];
            var contact = data['Contact'];
            var hospitalDetail = data['HospitalDescription'];
            var specialization = data['Specialization'];
            var hospitalName = data['HospitalName'];
            var description = data['Description'];
            var mediaFiles = data['Hospital_Images'];;

            return Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    const Text('Name', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    TextFormField(
                      initialValue: name,
                      decoration: getInputDecoration(
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    const Text('DoctorEmail', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    TextFormField(
                      initialValue: email,
                      decoration: getInputDecoration(
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    const Text('Specialization', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    TextFormField(
                      initialValue: specialization.toString(),
                      decoration: getInputDecoration(
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    const Text('Contact', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    TextFormField(
                      initialValue: contact.toString(),
                      decoration: getInputDecoration(
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    const Text('Description', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    TextFormField(
                      initialValue: description,
                      minLines: 1,
                      maxLines: 16,
                      decoration: getInputDecoration(
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    const Text('Hospital Name', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    TextFormField(
                      initialValue: hospitalName,
                      decoration: getInputDecoration(
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    const Text('Hospital Details', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    TextFormField(
                      initialValue: hospitalDetail,
                      minLines: 1,
                      maxLines: 16,
                      decoration: getInputDecoration(
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //Image Code

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


                 RoundButton(
                   title: 'Book Appointment',
                   color: Colors.blue,
                   onTap: () { Navigator.of(context).push(MaterialPageRoute(builder:
                       (context) => Appointments(doctorEmailId: widget.email,))); },

              )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  String _getFileName(String url){
    RegExp regExp = RegExp(r'.+(\/|%2F)(.+)\?.+');
    //This Regex won't work if you remove ?alt...token
    var matches = regExp.allMatches(url);

    var match = matches.elementAt(0);
    print("${Uri.decodeFull(match.group(2)!)}");
    return Uri.decodeFull(match.group(2)!);
  }
}
