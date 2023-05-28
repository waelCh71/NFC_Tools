import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../login/view/login_page.dart';
import 'signup_input_detail.dart';
import '../../global/utils/constante.dart';

import '../../global/themes/colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                        const Text("Sign UP"),
                        const SizedBox(
                          height: 40,
                        ),

                        //Email Field:
                        const BuildEmailSignUp(),
                        const SizedBox(height: 20),

                        //Password Field:
                        const BuildPasswordSignUp(),
                        const SizedBox(height: 20),

                        //Password confirmation
                        const BuildPasswordconfirmation(),
                        const SizedBox(height: 20),

                        //const SizedBox(height: 15),

                        //SignUP Button
                        BuildSignUpButton(formKey: _formKey),

                        //Sign In
                        Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: (() {
                              navigation(context, const LoginPage());
                            }),
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Already Have an Acount? ",
                                      style: TextStyle(
                                        color: myWhite,
                                        fontSize: 20,
                                      )),
                                  TextSpan(
                                      text: "Sign In ",
                                      style: TextStyle(
                                        color: myWhite,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )
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
