import '../widgets/authScreen/forgetPassword.dart';
import '../providers/authProv.dart';
import 'package:provider/provider.dart';
import '../widgets/authScreen/authCardDetails.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final signIn = Provider.of<AuthProv>(context).signInState;
    final clickedPassword =
        Provider.of<AuthProv>(context).clickedForgetPassword;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: s.width,
          height: s.height * 0.5,
          decoration: BoxDecoration(color: Colors.deepPurple[600]),
        ),
        !clickedPassword
            ? Positioned(
                top: s.height * 0.14,
                left: s.width * 0.325,
                child: Column(
                  children: [
                    Text(
                      signIn ? 'Sign in' : 'Sign Up',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    Text(
                      signIn ? 'Login to your account' : 'Create a new account',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                  ],
                ))
            : Positioned(
                top: s.height * 0.29,
                left: s.width * 0.275,
                child: Text(
                  'Rest Password',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                )),
        !clickedPassword ? AuthCardDetails() : ForgetPassword(),
      ],
    ));
  }
}
