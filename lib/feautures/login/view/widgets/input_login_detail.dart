// ignore_for_file: prefer_const_constructors

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/global/themes/colors.dart';

import '../../../../global/utils/utils.dart';
import '../../../../main.dart';

String _email = "";
String _password = "";

//String _formKey="abc";
class BuildEmail extends StatefulWidget {
  const BuildEmail({Key? key}) : super(key: key);

  @override
  State<BuildEmail> createState() => _BuildEmailState();
}

class _BuildEmailState extends State<BuildEmail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Email: "),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity * 0.8,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: myWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: myBlack),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: 14,
              ),
              prefixIcon: Icon(
                Icons.email,
                color: myGreen,
              ),
              hintText: "Email ",
              hintStyle: TextStyle(
                color: myBlack,
              ),
            ),
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Email musn't be empty ";
              } else if (!EmailValidator.validate(value!, true)) {
                return "Enter a valid Email ";
              } else {
                return null;
              }
            },
            onChanged: (String inputEmail) {
              setState(() {
                _email = inputEmail;
              });
            },
          ),
        ),
      ],
    );
  }
}

//Password Field
class BuildPassword extends StatefulWidget {
  // final GlobalKey<FormState> formKey;

  // const buildPassword({super.key, required this.formKey});

  const BuildPassword({Key? key}) : super(key: key);

  @override
  State<BuildPassword> createState() => _BuildPasswordState();
}

class _BuildPasswordState extends State<BuildPassword> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password: "),
        const SizedBox(
          height: 10,
        ),
        Container(
          //width: double.infinity * 0.8,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: myWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            obscureText: true,
            style: const TextStyle(color: myBlack),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: 14,
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: myGreen,
              ),
              hintText: "Password ",
              hintStyle: TextStyle(
                color: myBlack,
              ),
            ),
            validator: (value) {
              if (value.toString().length < 8) {
                return "Password is to short ";
              } else {
                return null;
              }
            },
            onChanged: (String inputPassword) {
              setState(() {
                _password = inputPassword;
              });
            },
          ),
        ),
      ],
    );
  }
}

class BuildLoginButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const BuildLoginButton({super.key, required this.formKey});
  //const buildLoginButton({Key? key}) : super(key: key);

  @override
  State<BuildLoginButton> createState() => _BuildLoginButtonState();
}

class _BuildLoginButtonState extends State<BuildLoginButton> {
  Utils utils = Utils();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      
      child: ElevatedButton(
        onPressed: () {
          final isValid = widget.formKey.currentState?.validate();
          FocusScope.of(context).unfocus();
          signIn(isValid!);
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.all(15)),
          backgroundColor: MaterialStateProperty.all(myWhite),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
          elevation: MaterialStateProperty.all(5),
        ),
        child: Text(
          " Login ",
          style: TextStyle(
            color: myGreen,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Future signIn(bool isValid) async {
    
    if (isValid) {
      showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                color: myRed,
              ),
            ));
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
      } on FirebaseAuthException catch (e) {
        utils.snackBarCheck(context, e.message.toString());
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
