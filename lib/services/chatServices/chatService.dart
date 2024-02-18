import 'dart:convert';
import 'package:design_project_1/utilities/gpt4.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:design_project_1/services/chatServices/ServerKey.dart';
import '../../models/Message.dart';
import '../profileServices/database.dart';
class ChatService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> dismissEmergencyChat() async {
    final String currentUserID = _auth.currentUser!.uid;
    await _firestore.collection('patients').doc(currentUserID).update({
      'emergency': 'none',
    });

    notifyListeners();
  }


  //send message
  Future<void> sendMessage(String message) async {
    try {
      // Get current user info
      final String currentUserID = _auth.currentUser!.uid;
      final currentUserData = await _firestore.collection('users').doc(currentUserID).get();
      final String currentUserName = currentUserData['name'] ?? 'CurrentUser';
       Timestamp timestamp = Timestamp.now();

      // Create a new message from the user
      Message userMessage = Message(
        senderID: currentUserID,
        message: message,
        timestamp: timestamp,
      );

      // Add the user's message to Firestore
      DocumentReference userMessageRef = await _firestore.collection('chatrooms').doc(currentUserID).collection('messages').add(userMessage.toMap());

      // Get the response from the AI
      List<Map<String, dynamic>> context = await buildChatContext();
      var response = await chatWithAi(context, message); // Provide the context as an argument

      // Create a new message from the AI
      timestamp = Timestamp.now();
      Message aiMessage = Message(
        senderID: 'Ai',
        message: response, // Use the response from the AI as the message
        timestamp: timestamp,
      );

      // Add the AI's message to Firestore
      await _firestore.collection('chatrooms').doc(currentUserID).collection('messages').add(aiMessage.toMap());
    } catch (e) {
      print('Error sending message: $e');
      // Handle any errors that occur during the process
    }
  }



  //get messages
    Stream<QuerySnapshot> getMessages(){

      String chatroomID = _auth.currentUser!.uid;

      return _firestore.collection('chatrooms').doc(chatroomID).collection('messages').orderBy('timestamp', descending: false).snapshots();
    }

  Future<List<Map<String,dynamic>>>  buildChatContext() async {
      String currentUserId = _auth.currentUser!.uid;
      var db = FirebaseFirestore.instance;
      String existingDisease = '';
      DocumentSnapshot kidneyDisease = await _firestore.collection('KidneyDiseases').doc(currentUserId).get();
      if(kidneyDisease.exists){
         existingDisease = 'KidneyDiseases';
      }

      QuerySnapshot querySnapshot = await _firestore.collection('chatrooms').doc(currentUserId).collection('messages').orderBy('timestamp', descending: true).limit(10).get();

      List<Map<String, dynamic>> previousMessages = [];
      previousMessages.add({
        'role': 'user',
        'content': 'Please keep in mind these contexts if relevant to my question.I suffer from ${existingDisease}\n',
      });
      for (var messageDoc in querySnapshot.docs) {
        var messageData = messageDoc.data() as Map<String, dynamic>;
        String? senderId = messageData['senderId'];
        String? messageText = messageData['message'];


          String role = (senderId == 'Ai') ? 'assistant' : 'user';
          previousMessages.add({
            'role': role,
            'content': messageText,
          });

      }

      print(previousMessages);
      return previousMessages;

    }

    Stream<DocumentSnapshot> getChatroomData() {
      String userUID = FirebaseAuth.instance.currentUser?.uid ?? '';

      return FirebaseFirestore.instance.collection('users').doc(userUID).snapshots();
    }

}