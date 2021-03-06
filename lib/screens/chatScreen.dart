import 'dart:io';
import '../widgets/chatScreen/upperBody/cutomSearch.dart';
import '../providers/chatsProv.dart';
import '../widgets/chatScreen/lowerBody/usersBody.dart';
import '../providers/authProv.dart';
import '../providers/usersProv.dart';
import '../widgets/chatScreen/upperBody/userBar.dart';
import '../widgets/chatScreen/upperBody/chatAndFriendsButtons.dart';
import '../widgets/chatScreen/lowerBody/messagesBub.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    try {
      Provider.of<UsersProv>(context, listen: false).getSavedData();
      Provider.of<ChatsProv>(context, listen: false).clearSavedDataIfNoChats();
      final sign = Provider.of<AuthProv>(context, listen: false).signInState;
      if (!sign) {
        Provider.of<UsersProv>(context, listen: false).setUsersData();
      }
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final chUser = Provider.of<UsersProv>(context).chUser;
    final userId = Provider.of<AuthProv>(context).userId;
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            height: Platform.isAndroid ? s.height * 0.19 : s.height * 0.16,
            padding: EdgeInsets.only(top: 43, left: 20, right: 20),
            child: UserBar(
              icon: Icons.search,
              ontap: () =>
                  showSearch(context: context, delegate: CustomSearch()),
              specificUser:
                  Provider.of<UsersProv>(context).findUserById(userId),
            ),
          ),
          Container(
            height: s.height * 0.07,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ChatAndFriendsButtons(),
          ),
          !chUser
              ? Expanded(child: MessagesBub())
              : Expanded(child: UsersBody())
        ],
      ),
    );
  }
}
