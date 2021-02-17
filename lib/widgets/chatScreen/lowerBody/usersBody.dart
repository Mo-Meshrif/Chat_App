import '../../../providers/authProv.dart';
import '../../../providers/usersProv.dart';
import '../../../screens/messageScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersBody extends StatefulWidget {
  @override
  _UsersBodyState createState() => _UsersBodyState();
}

class _UsersBodyState extends State<UsersBody> {
  @override
  void didChangeDependencies() {
    Provider.of<UsersProv>(context, listen: false).getSavedData();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Provider.of<UsersProv>(context, listen: false).getUsersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProv>(context).userId;
    final otherUsers =
        Provider.of<UsersProv>(context).findOtherUsersById(userId);
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          itemCount: otherUsers.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo[50],
                  radius: 25,
                  backgroundImage: NetworkImage(otherUsers[i].imageUrl),
                ),
                title: Text('${otherUsers[i].userName}'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MessageScreen(
                            friendId: otherUsers[i].userId,
                          )));
                },
              ),
            );
          }),
    );
  }
}
