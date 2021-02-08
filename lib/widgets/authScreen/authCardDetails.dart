import 'package:chat_app/httpExcptions.dart';
import 'package:chat_app/providers/authProv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AuthCardDetails extends StatefulWidget {
  @override
  _AuthCardDetailsState createState() => _AuthCardDetailsState();
}

class _AuthCardDetailsState extends State<AuthCardDetails> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _userNameController = new TextEditingController();
  bool isVisibil = false;
  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final signIn = Provider.of<AuthProv>(context).signInState;
    return Padding(
      padding: EdgeInsets.only(top: s.height * 0.23),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: signIn
                  ? EdgeInsets.symmetric(horizontal: 15, vertical: 50)
                  : EdgeInsets.all(15),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    !signIn
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: InkWell(
                              onTap: null,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 40,
                              ),
                            ),
                          )
                        : Padding(padding: EdgeInsets.all(0)),
                    buildCustomField(
                        controller: _emailController,
                        valKey: 'email',
                        label: 'Enter your email address',
                        prefIcon: Icons.mail,
                        suffIcon: null,
                        secure: false,
                        valid: (val) {
                          if (val.trim().isEmpty) {
                            return 'Enter your email !';
                          }
                          if (!val.trim().contains('@')) {
                            return 'Entered email is not valid';
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    !signIn
                        ? buildCustomField(
                            controller: _userNameController,
                            valKey: 'name',
                            label: 'Enter your name ',
                            prefIcon: Icons.person,
                            suffIcon: null,
                            secure: false,
                            valid: (val) {
                              if (val.trim().isEmpty) {
                                return 'Enter your username !';
                              }
                              return null;
                            })
                        : Padding(padding: EdgeInsets.all(0)),
                    !signIn
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    buildCustomField(
                        controller: _passwordController,
                        valKey: 'password',
                        label: 'Enter the password',
                        prefIcon: Icons.vpn_key,
                        suffIcon:
                            isVisibil ? Icons.visibility : Icons.visibility_off,
                        secure: isVisibil ? false : true,
                        valid: (val) {
                          if (val.isEmpty) {
                            return 'Enter your password !';
                          }
                          if (val.length < 6) {
                            return 'Password must be greater than six';
                          }
                          return null;
                        }),
                    !signIn
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    !signIn
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: buildCustomField(
                                valKey: 'confirm password',
                                label: 'Confirm the password',
                                prefIcon: Icons.vpn_key,
                                suffIcon: isVisibil
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                secure: isVisibil ? false : true,
                                valid: (val) {
                                  if (val.isEmpty) {
                                    return 'Enter your password !';
                                  }
                                  if (val.length < 6) {
                                    return 'Password must be greater than six';
                                  }
                                  if (val != _passwordController.text) {
                                    return 'The password is not the same';
                                  }
                                  return null;
                                }),
                          )
                        : Padding(padding: EdgeInsets.all(0)),
                    signIn
                        ? InkWell(
                            onTap: null,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: Text('Forget password ?'),
                            ),
                          )
                        : Padding(padding: EdgeInsets.all(0)),
                    Container(
                      width: s.width * 0.9,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.deepPurple[600],
                        onPressed: () async {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            try {
                              if (signIn) {
                                await Provider.of<AuthProv>(context,
                                        listen: false)
                                    .signIn(_emailController.text,
                                        _passwordController.text);
                              } else {
                                await Provider.of<AuthProv>(context,
                                        listen: false)
                                    .signUp(_emailController.text,
                                        _passwordController.text);
                              }
                            } on HttpException catch (e) {
                              var errorMessage = '';
                              switch (e.toString()) {
                                case "INVALID_EMAIL":
                                  errorMessage =
                                      "Your email address appears to be malformed.";
                                  break;
                                case "INVAILD_PASSWORD":
                                  errorMessage = "Your password is wrong.";
                                  break;
                                case "WEAK_PASSWORD":
                                  errorMessage = "Your password is weak.";
                                  break;
                                case "EMAIL_EXISITS":
                                  errorMessage =
                                      "This email address is already in use.";
                                  break;
                                case "EMAIL_NOT_FOUND":
                                  errorMessage =
                                      "Could not find a user with that email.";
                                  break;
                                default:
                                  errorMessage = "An undefined Error happened.";
                              }
                              Toast.show("$errorMessage", context, duration: 2);
                            } catch (e) {
                              Toast.show("Contact the developer !", context,duration: 2);
                            }
                          }
                        },
                        child: Text(
                          signIn ? 'SIGN IN' : 'SIGN Up',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(signIn
                            ? 'Do not you have an account ? '
                            : 'Already have an account ? '),
                        InkWell(
                          onTap: () =>
                              Provider.of<AuthProv>(context, listen: false)
                                  .sign(),
                          child:
                              Text(signIn ? 'Sign up Now !' : 'Sign in Now !'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildCustomField(
      {String valKey,
      String label,
      IconData prefIcon,
      IconData suffIcon,
      TextEditingController controller,
      String Function(String) valid,
      bool secure}) {
    return TextFormField(
      validator: valid,
      controller: controller,
      key: ValueKey(valKey),
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(prefIcon),
          suffixIcon: InkWell(
              onTap: () => setState(() {
                    isVisibil = !isVisibil;
                  }),
              child: Icon(suffIcon))),
      obscureText: secure,
    );
  }
}
