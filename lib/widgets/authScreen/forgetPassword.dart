import '../../providers/authProv.dart';
import '../../httpExcptions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  GlobalKey<FormState> _keyForget = GlobalKey<FormState>();

  TextEditingController _emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: s.height * 0.35),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Form(
                key: _keyForget,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'Enter your email !';
                          }
                          if (!val.trim().contains('@')) {
                            return 'Entered email is not valid';
                          }
                          return null;
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Enter your email address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.mail),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: s.width * 0.9,
                      height: 50,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        color: Colors.deepPurple[600],
                        onPressed: () async {
                          if (_keyForget.currentState.validate()) {
                            _keyForget.currentState.save();
                            try {
                              await Provider.of<AuthProv>(context,
                                      listen: false)
                                  .restPassword(_emailController.text)
                                  .then((_) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 24),
                                          title: Text('Well Done !'),
                                          content:
                                              Text('Check your mail inbox'),
                                          actions: [
                                            // ignore: deprecated_member_use
                                            RaisedButton(
                                              color: Colors.deepPurple[600],
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text(
                                                'Exit',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ));
                              });
                            } on HttpException catch (e) {
                              var errorMessage = "An undefined Error happened.";
                              if (e.toString().contains("EMAIL_NOT_FOUND")) {
                                errorMessage =
                                    "Could not find a user with that email.";
                              }
                              Toast.show("$errorMessage", context, duration: 2);
                            } catch (e) {
                              Toast.show("Contact the developer !", context,
                                  duration: 2);
                            }
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: () =>
                            Provider.of<AuthProv>(context, listen: false)
                                .checkClickedPass(),
                        child: Text(
                          'Back to login',
                          style: TextStyle(
                            color: Colors.deepPurple[600],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
