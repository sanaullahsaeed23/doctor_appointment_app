import 'package:flutter/material.dart';

import '../users/profile.dart';
import '../users/search.dart';
import '../users/userHome.dart';

class UserBottomNavi extends StatefulWidget {
  const UserBottomNavi({Key? key}) : super(key: key);

  @override
  State<UserBottomNavi> createState() => _UserBottomNaviState();
}

class _UserBottomNaviState extends State<UserBottomNavi> {
  List pages= [
    const UserHome(),
    Search(),
    const Profile(),
  ];

  int currentindex=0;
  void onTap(int index){
    setState(() {
      currentindex= index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: onTap,
        currentIndex: currentindex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(label: "Home",icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Search",icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: "Account",icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }
}