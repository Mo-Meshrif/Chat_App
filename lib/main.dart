import 'package:firebase_core/firebase_core.dart';
import './providers/usersProv.dart';
import './providers/authProv.dart';
import './screens/chatScreen.dart';
import 'screens/authScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider.value(
        value: AuthProv(),
      ),
      ChangeNotifierProxyProvider<AuthProv, UsersProv>(
          create: (_) => UsersProv(),
          update: (_, authVal, userVal) =>
              userVal..getAuthParameters(authVal.userId)),
    ], child: MyApp()),
  );
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
