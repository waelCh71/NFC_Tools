import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/input_login_detail.dart';
import '../../../global/themes/colors.dart';

import '../../../global/utils/constante.dart';
import '../../../global/utils/utils.dart';
import '../../main_page/views/main_page.dart';
import '../../reset_password/reset_password.dart';
import '../../signup/signup_page.dart';

class CheckLoginStatus extends StatefulWidget {
  const CheckLoginStatus({Key? key}) : super(key: key);

  @override
  State<CheckLoginStatus> createState() => _CheckLoginStatus();
}

class _CheckLoginStatus extends State<CheckLoginStatus> {
  late Utils utils;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: myRed,
              ),
            );
          } else if (snapshot.hasError) {
            utils.snackBarCheck(context, "Something went wrong");
            return const LoginPage();
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        });
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradiantColor),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 120,
                  ),
                  child: Form(
                    key: _formKey,
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sign In"),
                        const SizedBox(
                          height: 40,
                        ),

                        //Email Field:
                        const BuildEmail(),
                        const SizedBox(height: 20),

                        //Password Field:
                        const BuildPassword(),
                        const SizedBox(height: 20),

                        //Forget Password:
                        Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              navigation(context, const PasswordReset());
                            },
                            child: const Text(
                              "Forget Password?",
                              style: TextStyle(
                                color: myWhite,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        //Login Button
                        BuildLoginButton(formKey: _formKey),

                        //Sign UP
                        Container(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: (() {
                              navigation(context, const SignupPage());
                            }),
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Don't Have an Acount? ",
                                      style: TextStyle(
                                        color: myWhite,
                                        fontSize: 20,
                                      )),
                                  TextSpan(
                                      text: "Sign UP ",
                                      style: TextStyle(
                                        color: myWhite,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
