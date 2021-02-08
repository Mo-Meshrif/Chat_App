import './providers/authProv.dart';
import './screens/chatScreen.dart';
import 'screens/authScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AuthProv()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home: Consumer<AuthProv>(
        builder: (context, auth, child) => auth.isAuth
            ? ChatScreen()
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? CircularProgressIndicator()
                        : AuthScreen()),
      ),
    );
  }
}
