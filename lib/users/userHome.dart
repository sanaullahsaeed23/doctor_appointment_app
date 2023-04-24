import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'doctorDetail.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
final fireStore =
FirebaseFirestore.instance.collection('Doctors').orderBy('id', descending: true).snapshots();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Doctors List'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Doctor Profiles')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something Went Wrong'));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No Data'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Colors.blue,
                    )
                  // Text('Loading')
                );
              }
              // loggedInUser.email
              final data = snapshot.requireData;
              return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Container(
                        width: double.infinity,
                        height: 75,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade100,

                        ),
                        child: ListTile(
                          onTap: () {
                            String email = snapshot.data!.docs[index]['DoctorEmail'];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Doctordetail(email)));
                          },
                          //three properties of listile Have Added Here
                          title: Text(snapshot.data!.docs[index]['Name'].toString()),
                          subtitle: Text(snapshot.data!.docs[index]['Specialization'].toString()),
                          // leading: const CircleAvatar(child: Image(image: AssetImage(logo),)),
                          trailing:  Icon(Icons.arrow_forward_ios, color: Colors.blue,),
                          leading: snapshot.data!.docs[index]['Profile'] == "" ?
                          CircleAvatar(
                              backgroundColor: Colors.white54,
                              radius: 30,
                              child: Icon(Icons.person)) :
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(snapshot.data!.docs[index]['Profile']),
                              )
                          // tileColor: const Color(0xFFe7edeb)
                        ),
                      ),
                    );

                  });
                  // separatorBuilder: (BuildContext context, int index) {
                  //   return const Divider(
                  //     color: Colors.white,
                  //   );
                  // });
            }),
      ),
    );
  }
}
