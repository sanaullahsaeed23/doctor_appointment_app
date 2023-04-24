import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorappotments/users/searchdetaul.dart';
import 'package:flutter/material.dart';

import 'doctorDetail.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}
class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Search"),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: searchOut());
                },
                icon: Icon(Icons.search))
          ],
        ),
      ),
    );
  }
}

class searchOut extends SearchDelegate {
  final Stream<QuerySnapshot> Admin = FirebaseFirestore.instance
      .collection('Doctors')
      .snapshots();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.arrow_back),
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Doctor Profiles')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          else {
            if (
                snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                element['City']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .isEmpty) {
              return const Center(child: Text("No Data Found"));
            } else {
              return ListView(
                  children: [
                    ...snapshot.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                    element['City']
                        .toString()
                        .toLowerCase()
                        == query.toLowerCase())
                        .map((QueryDocumentSnapshot<Object?> data) {
                      final String name = data.get('Name');
                      final String specialization  = data.get('Specialization');

                      return ListTile(
                        onTap: () {
                          String email = data.get('DoctorEmail');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Doctordetail(email)));
                        },
                        title: Text(name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 4.0),
                            Text(
                              specialization,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              specialization ,
                              style: TextStyle(),
                            ),
                          ],
                        ),
                        trailing:  const Icon(Icons.arrow_forward_ios, color: Colors.blue,),
                        tileColor: Colors.blue.shade100,
                      );
                    },
                    )]
              );
            }



          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text("Search any thing here"));
  }
}
