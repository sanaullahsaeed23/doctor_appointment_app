import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class searchdetail extends StatefulWidget {
  String id;
  searchdetail(this.id, {Key? key}) : super(key: key);
  @override
  State<searchdetail> createState() => _searchdetailState();
}
class _searchdetailState extends State<searchdetail> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detail'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('Doctor Profiles')
              .doc(widget.id)
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
            var specialization = data['Specialization '];
            var hospitalName = data['HospitalName '];
            var description = data['Description '];

            return Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const[
                        Text('Doctor Detail', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 20
                        ),),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Name', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    Text(name , style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),),
                    const SizedBox(
                      height: 20,
                    ),

                    const Text('DoctorEmail', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    Text(email, style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),),
                    const SizedBox(
                      height: 20,
                    ),

                    const Text('Hospital Detail', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    Text(hospitalDetail.toString() , style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),),
                    const SizedBox(
                      height: 20,
                    ),

                    const Text('Hospital Name ', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    Text(hospitalName.toString() , style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),),
                    const SizedBox(
                      height: 20,
                    ),

                    const Text('specialization', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    Text(specialization.toString() , style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),),
                    const SizedBox(
                      height: 20,
                    ),

                    const Text('Contact', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    Text(contact.toString() , style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),),
                    const SizedBox(
                      height: 20,
                    ),

                    const Text('Description', style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),),
                    Text(description.toString() , style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
