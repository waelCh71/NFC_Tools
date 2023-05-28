// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/global/themes/colors.dart';

import '../../global/utils/utils.dart';
import '../../main.dart';

String _email = "";
String _password = "";

class BuildEmailSignUp extends StatefulWidget {
  const BuildEmailSignUp({Key? key}) : super(key: key);

  @override
  State<BuildEmailSignUp> createState() => _BuildEmailSignUpState();
}

class _BuildEmailSignUpState extends State<BuildEmailSignUp> {
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
class BuildPasswordSignUp extends StatefulWidget {
  const BuildPasswordSignUp({Key? key}) : super(key: key);

  @override
  State<BuildPasswordSignUp> createState() => _BuildPasswordSignUpState();
}

class _BuildPasswordSignUpState extends State<BuildPasswordSignUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password "),
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
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: 14,
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: myGreen,
              ),
              hintText: "Password",
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

class BuildPasswordconfirmation extends StatefulWidget {
  const BuildPasswordconfirmation({Key? key}) : super(key: key);

  @override
  State<BuildPasswordconfirmation> createState() =>
      _BuildPasswordconfirmationState();
}

class _BuildPasswordconfirmationState extends State<BuildPasswordconfirmation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Confirm Password"),
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
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: 14,
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: myGreen,
              ),
              hintText: "Confirm Password",
              hintStyle: TextStyle(
                color: myBlack,
              ),
            ),
            validator: (value) {
              if (value.toString().length < 8) {
                return "Password is to short ";
              } else if (value.toString().compareTo(_password) != 0) {
                return "Password is not Confirmed";
              } else {
                return null;
              }
            },
            // onChanged: (String inputPassword) {
            //   setState(() {
            //     _confirmepassword = inputPassword;
            //   });
            // },
          ),
        ),
      ],
    );
  }
}

class BuildSignUpButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const BuildSignUpButton({super.key, required this.formKey});
  //const buildLoginButton({Key? key}) : super(key: key);

  @override
  State<BuildSignUpButton> createState() => _BuildSignUpButton();
}

class _BuildSignUpButton extends State<BuildSignUpButton> {
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
          signUp(isValid!);
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
          " Sign UP ",
          style: TextStyle(
            color: myGreen,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Future signUp(bool isValid) async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                color: myRed,
              ),
            ));
    await Future.delayed(Duration(milliseconds: 1000));

    if (isValid) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      } on FirebaseAuthException catch (e) {
        navigatorKey.currentState!.pop();
        utils.snackBarCheck(context, e.message.toString());
      }
    } else {
      navigatorKey.currentState!.pop();
    }
  }
}
