import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:design_project_1/screens/patientInterface/emergencyPortal/chat.dart';
import 'package:design_project_1/services/chatServices/chatService.dart';
import '../../../services/notificationServices/notification_services.dart';
import 'package:flutter_sound/flutter_sound.dart';
class RequestEmergencyScreen extends StatefulWidget {
  const RequestEmergencyScreen({super.key});

  @override
  State<RequestEmergencyScreen> createState() => _RequestEmergencyScreenState();
}

class _RequestEmergencyScreenState extends State<RequestEmergencyScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();
  NotificationServices notificationServices = NotificationServices();
  final String receiverID = FirebaseAuth.instance.currentUser!.uid;
  final String receiverEmail = FirebaseAuth.instance.currentUser!.email
      .toString();
  String initialMessage = "";
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    _recorder.openAudioSession();
  }
  @override
  void dispose() {
    _recorder.closeAudioSession();
    _recorder = FlutterSoundRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('patients').doc(
          _auth.currentUser!.uid).snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.exists && snapshot.data?['emergency']=='none') {

          return Scaffold(
            appBar: AppBar(
              title: Text('Request Emergency'),
              backgroundColor: Colors.blue.shade900,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [Colors.white70, Colors.blue.shade100],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: 3,
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: "Emergency Note",
                          hintText: "Include the health issue for better assistance",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade800,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        fixedSize: Size(100.0, 50.0),
                      ),
                      child: Icon(Icons.emergency_outlined,
                        size: 40.0,
                      ),
                      onPressed: () async {
                        initialMessage = _messageController.text;
                        await _chatService.requestEmergency(initialMessage);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              Chat(receiverUserID: receiverID,
                                initialMessage: initialMessage,)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // If the current user's ID does not exist in the 'emergencyRequests' collection, check the 'chatrooms' collection
          return StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('patients').doc(
                _auth.currentUser!.uid).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data!.exists && snapshot.data?['emergency']=='accepted') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        Chat(receiverUserID: receiverID,
                          initialMessage: initialMessage,)),
                  );
                });
                return Container(); // Return an empty container while the navigation is being performed
              } else {
                // If the current user's ID does not exist in the 'chatrooms' collection, return the current widget

                return Scaffold(
                  appBar: AppBar(
                    title: Text('Request Emergency'),
                    backgroundColor: Colors.blue.shade900,
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: 3,
                            controller: _messageController,
                            decoration: InputDecoration(
                              labelText: "Emergency Note",
                              hintText: "Include the health issue for better assistance",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade800,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            fixedSize: Size(100.0, 50.0),
                          ),
                          child: Icon(Icons.emergency_outlined,
                            size: 40.0,
                          ),
                          onPressed: () {
                            initialMessage = _messageController.text;
                            _chatService.requestEmergency(initialMessage);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  Chat(receiverUserID: receiverID,
                                    initialMessage: initialMessage,)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

}

