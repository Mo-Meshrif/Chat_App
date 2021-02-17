import '../../../providers/usersProv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatAndFriendsButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chUser=Provider.of<UsersProv>(context).chUser;
    return Row(
      children: [
        Container(
          width: 65,
          // ignore: deprecated_member_use
          child: RaisedButton(
            color: !chUser?Colors.blue[800]:Colors.grey[200],
            onPressed: () {
              Provider.of<UsersProv>(context,listen: false).changeChUser();
            },
            child: Text(
              'Chat',
              style: TextStyle(color:!chUser? Colors.white:Colors.black),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Container(
          width: 75,
          // ignore: deprecated_member_use
          child: RaisedButton(
            color: chUser?Colors.blue[800]:Colors.grey[200],
            onPressed: () {
              Provider.of<UsersProv>(context,listen: false).changeChUser();
            },
            child: Text(
              'Users',
              style: TextStyle(color: chUser? Colors.white:Colors.black),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )
      ],
    );
  }
}
