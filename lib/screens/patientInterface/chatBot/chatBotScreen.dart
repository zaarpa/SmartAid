import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_project_1/components/chatComponent/chatBubble.dart';
import 'package:design_project_1/components/chatComponent/textField.dart';
import 'package:design_project_1/screens/patientInterface/home/home.dart';
import 'package:design_project_1/services/chatServices/chatService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}


class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final _auth = FirebaseAuth.instance;
  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(_messageController.text);
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;




            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blue.shade900,
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Chat with SmartAid"),
                ),


              ),
              body: Column(
                children:[
                  Expanded(
                    child: _buildMessageList(),
                  ),
                  _buildMessageInput(),
                ],
              ),
            );


  }
  //build message list
  Widget _buildMessageList(){
    return StreamBuilder(
        stream: _chatService.getMessages(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Text('Loading...');
          }
          else {
            return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((document) => _buildMessageItem(document))
                  .toList(),
            );
          }
        }
    );
  }
  //build message input
  Widget _buildMessageInput(){
    return Row(
        children: [
          Expanded(
            child: ModifiedTextField(
              controller: _messageController,
              hintText: 'Type a message',
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            color: Colors.blue.shade900,
            icon: const Icon(Icons.arrow_upward,
              size: 40,
            ),
          ),
        ]
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = data['senderID'] == _auth.currentUser?.uid ? Alignment.centerRight : Alignment.centerLeft;
      return Container(
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: (data['senderID'] == _auth.currentUser?.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisAlignment: (data['senderID'] == _auth.currentUser?.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  data['senderID'] == 'Ai' ? Text('SmartAid') : Text('Me'),
                  ChatBubble(message: data['message']),
                ]
            ),
          )
      );
  }

}

