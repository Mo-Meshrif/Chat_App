import '../providers/usersProv.dart';
import '../screens/messageScreen.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class CustomSearch extends SearchDelegate<User> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<User> users = Provider.of<UsersProv>(context).users;
    final fitlteredUsers =
        users.where((user) => user.userName.startsWith(query)).toList();
    return fitlteredUsers.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              query.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 18, bottom: 10),
                      child: Text('SUGGESTED'),
                    )
                  : Padding(padding: EdgeInsets.only(bottom: 10)),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      query.isEmpty ? users.length : fitlteredUsers.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo[50],
                      radius: 25,
                      backgroundImage: NetworkImage(query.isEmpty
                          ? users[i].imageUrl
                          : fitlteredUsers[i].imageUrl),
                    ),
                    title: Text(
                        '${query.isEmpty ? users[i].userName : fitlteredUsers[i].userName}'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MessageScreen(
                                friendId: query.isEmpty
                                    ? users[i].userId
                                    : fitlteredUsers[i].userId,
                              )));
                    },
                  ),
                ),
              )
            ],
          )
        : Center(
            child: Text('There is no user !'),
          );
  }
}
