import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:design_project_1/services/authServices/auth.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();

}


Stream<DocumentSnapshot> getUserData() {
  String userUID = FirebaseAuth.instance.currentUser?.uid ?? '';

  return FirebaseFirestore.instance.collection('users').doc(userUID).snapshots();

}

Stream<DocumentSnapshot> getDoctorData() {
  String userUID = FirebaseAuth.instance.currentUser?.uid ?? '';

  return FirebaseFirestore.instance.collection('doctors').doc(userUID).snapshots();
}


class _FeedState extends State<Feed> {

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade900,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('DocLinkr'),

          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white70, Colors.pink.shade50],
          ),
        ),

          child: Column(
            // // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: getUserData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final userData = snapshot.data?.data() as Map<String, dynamic>;
                    final username = userData['name'] as String;
                    return Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Welcome to DocLinkr,',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '$username',
                          style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,

                        ),
                      ],

                    );
                  },
                ),
              ),
      ],
          ),

      ),
    );
  }
}