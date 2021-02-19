import '../../../models/user.dart';
import '../../../providers/authProv.dart';
import '../../../providers/usersProv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserBar extends StatelessWidget {
  final IconData icon;
  final Function ontap;
  final User specificUser;
  UserBar({
    this.icon,
    this.ontap,
    this.specificUser,
  });
  @override
  Widget build(BuildContext context) {
    final signIn = Provider.of<AuthProv>(context).signInState;
    final image = Provider.of<UsersProv>(context).imageUrl;
    final userName = Provider.of<UsersProv>(context).userName;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: InkWell(
            onTap: ontap,
            child: CircleAvatar(
              backgroundColor: Colors.indigo[100],
              child: Icon(icon),
            ),
          ),
        ),
        Column(
          children: [
            CircleAvatar(
              backgroundImage: !signIn
                  ? FileImage(image)
                  : specificUser == null
                      ? AssetImage('assets/placeholder.jpg')
                      : NetworkImage(specificUser.imageUrl),
              backgroundColor: Colors.indigo[50],
              radius: 30,
            ),
            SizedBox(
              height: 5,
            ),
            Text(!signIn
                ? '$userName'
                : specificUser == null
                    ? 'user'
                    : specificUser.userName)
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: InkWell(
            onTap: () {
              Provider.of<AuthProv>(context, listen: false).logout();
              Provider.of<UsersProv>(context, listen: false).clear();
            },
            child: CircleAvatar(
              backgroundColor: Colors.indigo[100],
              child: Icon(Icons.logout),
            ),
          ),
        ),
      ],
    );
  }
}
