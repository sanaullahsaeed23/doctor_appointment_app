
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Doctor/account.dart';
import '../Doctor/dashboard_edit.dart';
import '../Doctor/patient_list.dart';


class BottomNaviDoctor extends StatefulWidget {
  const BottomNaviDoctor({Key? key}) : super(key: key);

  @override
  State<BottomNaviDoctor> createState() => _BottomNaviDoctorState();
}

class _BottomNaviDoctorState extends State<BottomNaviDoctor> {
  List pages=[
    PatientsList(),
    DashboardEdit(),
    Profile(),
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
          BottomNavigationBarItem(label: " ", icon: FaIcon(FontAwesomeIcons.list)),
          BottomNavigationBarItem(label: " ",icon: FaIcon(FontAwesomeIcons.dashboard)),
          BottomNavigationBarItem(label: " ",icon: FaIcon(FontAwesomeIcons.person)),
          // BottomNavigationBarItem(label: " ",icon: FaIcon(FontAwesomeIcons.solidCircleUser)),
          // BottomNavigationBarItem(label: " ",icon: Icon(Icons.list_alt_sharp)),
          // BottomNavigationBarItem(label: " ",icon: Icon(Icons.dashboard_customize)),
          // BottomNavigationBarItem(label: " ",icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}