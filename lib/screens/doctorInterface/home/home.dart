import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:design_project_1/services/authServices/auth.dart';
import '../../../utilities/gpt4.dart' as GPT;

void main() {
  runApp(Home());
}



class Home extends StatefulWidget {

  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // NotificationServices notificationServices = NotificationServices();
  final AuthService _auth = AuthService();
  var emergencyDoctor = false;
  String promptTesting ='';
  int _currentIndex = 2;
  @override
    void initState() {
    super.initState();
    setState(()  {
      _currentIndex = 2;
    });
    // notificationServices.requestNotificationPermission();
    // notificationServices.firebaseInit(context);
    // notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    // notificationServices.getDeviceToken().then((value) async {
    //   print("device   token");
    //   print(value);
    //   await FirebaseFirestore.instance.collection('doctors').doc(FirebaseAuth.instance.currentUser?.uid).update({
    //     'deviceToken': value,
    //   });
    // });
  }

  Stream<DocumentSnapshot> getUserData() {
    String userUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FirebaseFirestore.instance.collection('users').doc(userUID).snapshots();
  }
  Stream<DocumentSnapshot> getDoctorData() {
    String userUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FirebaseFirestore.instance.collection('doctors').doc(userUID).snapshots();

  }



  List<Widget> _buildScreens() {
    return [
      // ScheduleScreen(),
      // AppointmentScreen(),
      FutureBuilder<String>(
        future: GPT.promptTesting("Kidney Disease",['high blood pressure'],600,33), // replace with your async function
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return Text('Loaded: ${snapshot.data}');
          }
        },
      ),
      Text('Appointment'),
      Container(
        color: Colors.transparent,
        // child: Feed(),

      ),
      Container(
        color: Colors.transparent,
        child:
        StreamBuilder<DocumentSnapshot>(
          stream: getDoctorData(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            else if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else{
              Map<String, dynamic> data = snapshot.data?.data() as Map<String, dynamic>;
              if(data['emergency']== null || data['emergency'] == false){
                // return EnrollAsEmergencyDoctor();
                return Text('Enroll as Emergency Doctor');
              }
              else{
                // return EmergencyRequestList();
                return Text('Emergency Request List');
              }

            }

          },
        ),
      ),
      Container(
        color: Colors.transparent,
        // child: ProfileScreen(),
        child: Text('Profile'),
      ),

    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.schedule_outlined, color: Colors.pink.shade900),
        inactiveIcon: Icon(Icons.schedule_outlined, color: Colors.grey),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_month, color: Colors.pink.shade900),
        inactiveIcon: Icon(Icons.calendar_month, color: Colors.grey),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home, color: Colors.pink.shade900),
        inactiveIcon: Icon(Icons.home, color: Colors.grey),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.emergency_outlined, color: Colors.pink.shade900),
        inactiveIcon: Icon(Icons.emergency_outlined, color: Colors.grey),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person, color: Colors.pink.shade900),
        inactiveIcon: Icon(Icons.person, color: Colors.grey),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return 


         SafeArea(
           child: PersistentTabView(
            context,
            controller: PersistentTabController(initialIndex: 2),
            screens: _buildScreens(),
            items: _navBarItems(),
            backgroundColor: Colors.white,
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            navBarStyle: NavBarStyle.style14,
            onItemSelected: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
        ),
         );
    
  }
}
