import '../../../providers/usersProv.dart';
import 'dismissibleDelete.dart';
import '../../../models/lastChat.dart';
import '../../../providers/authProv.dart';
import '../../../providers/chatsProv.dart';
import '../../../screens/messageScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MessagesBub extends StatefulWidget {
  @override
  _MessagesBubState createState() => _MessagesBubState();
}

class _MessagesBubState extends State<MessagesBub> {
  @override
  void initState() {
    Provider.of<ChatsProv>(context, listen: false).getSavedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProv>(context).userId;
    final List<LastChat> lastChats = Provider.of<ChatsProv>(context).lastChats;
    final DateFormat formatter = DateFormat('jm');
    return Container(
        child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 5),
            itemCount: lastChats.length,
            itemBuilder: (context, i) {
              if (lastChats[i].me.userId == userId ||
                  lastChats[i].notme.userId == userId) {
                return DismissibleDelete(
                  spacifickey: UniqueKey().toString(),
                  dir: DismissDirection.endToStart,
                  onDismissed: (_) {
                    Provider.of<ChatsProv>(context, listen: false).deleteChat(
                        userId,
                        lastChats[i].me.userId == userId
                            ? lastChats[i].notme.userId
                            : lastChats[i].me.userId);
                    final users =
                        Provider.of<UsersProv>(context, listen: false).users;
                    Provider.of<ChatsProv>(context, listen: false)
                        .getLastChat(users);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          lastChats[i].me.userId == userId
                              ? lastChats[i].notme.imageUrl
                              : lastChats[i].me.imageUrl),
                    ),
                    title: Text(lastChats[i].me.userId == userId
                        ? lastChats[i].notme.userName
                        : lastChats[i].me.userName),
                    subtitle: Text(lastChats[i].lastMessage),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MessageScreen(
                                friendId: lastChats[i].me.userId == userId
                                    ? lastChats[i].notme.userId
                                    : lastChats[i].me.userId,
                              )));
                    },
                    trailing: Text(
                      '${formatter.format(lastChats[i].messageTime)}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }
              return Padding(padding: EdgeInsets.all(0));
            }));
  }
}
