import 'dart:io';
import 'package:chat_app/providers/usersProv.dart';

import '../providers/authProv.dart';
import '../providers/chatsProv.dart';
import '../widgets/chatScreen/upperBody/callUserBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  final String friendId;
  
  MessageScreen({
    this.friendId,
    
  });

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController _messageController = new TextEditingController();
  String enteredMessage = '';

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final userId = Provider.of<AuthProv>(context).userId;
    final notMe = Provider.of<UsersProv>(context).findUserById(widget.friendId);
    final users=Provider.of<UsersProv>(context).users;
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            height: Platform.isAndroid ? s.height * 0.19 : s.height * 0.15,
            padding: EdgeInsets.only(top: 43, left: 20, right: 20),
            child: CallUserBar(
              icon: Icons.arrow_back,
              ontap: () => Navigator.of(context).pop(),
              specificUser: notMe,
            ),
          ),
          Expanded(
            child: Container(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, messageSnap) {
                if (messageSnap.hasData) {
                  return ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      reverse: true,
                      itemCount: messageSnap.data.docs.length,
                      itemBuilder: (context, i) {
                        if (messageSnap.data.docs[i]['from'] == userId) {
                          if (messageSnap.data.docs[i]['to'] ==
                              widget.friendId) {
                            return Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  constraints: BoxConstraints(
                                      minWidth: 40,
                                      maxWidth: 100,
                                      minHeight: 30,
                                      maxHeight: 100),
                                  decoration: BoxDecoration(
                                      color: Colors.blue[800],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  child: Text(
                                    '${messageSnap.data.docs[i]['message']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ));
                          }
                        } else if (messageSnap.data.docs[i]['from'] ==
                            widget.friendId) {
                          if (messageSnap.data.docs[i]['to'] == userId) {
                            return Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  constraints: BoxConstraints(
                                      minWidth: 40,
                                      maxWidth: 100,
                                      minHeight: 30,
                                      maxHeight: 100),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Text(
                                    '${messageSnap.data.docs[i]['message']}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ));
                          }
                        }
                        return Padding(padding: EdgeInsets.all(0));
                      });
                }
                return Center(child: CircularProgressIndicator());
              },
            )),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: TextFormField(
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: enteredMessage.trim().isEmpty
                      ? null
                      : () {
                          Provider.of<ChatsProv>(context, listen: false)
                              .uploadChat(
                                  widget.friendId,
                                  enteredMessage,users);
                          _messageController.clear();
                        },
                  child: Icon(Icons.send),
                ),
                hintText: 'Type a message',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              controller: _messageController,
              onChanged: (val) {
                setState(() {
                  enteredMessage = val;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
