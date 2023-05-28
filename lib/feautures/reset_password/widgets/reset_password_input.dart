// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../global/themes/colors.dart';
import '../../../global/utils/utils.dart';
import '../../../main.dart';

String _email = "";

class BuildEmailReset extends StatefulWidget {
  const BuildEmailReset({Key? key}) : super(key: key);

  @override
  State<BuildEmailReset> createState() => _BuildEmailResetState();
}

class _BuildEmailResetState extends State<BuildEmailReset> {
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

class BuildResetButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const BuildResetButton({super.key, required this.formKey});
  //const buildLoginButton({Key? key}) : super(key: key);

  @override
  State<BuildResetButton> createState() => _BuildResetButton();
}

class _BuildResetButton extends State<BuildResetButton> {
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
          resetPassword(isValid!);
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
          backgroundColor: MaterialStateProperty.all(myWhite),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
          elevation: MaterialStateProperty.all(5),
        ),
        child: const Text(
          " Reset Password ",
          style: TextStyle(
            color: myGreen,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Future resetPassword(bool isValid) async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: myRed,
              ),
            ));
    await Future.delayed(const Duration(milliseconds: 2000));

    if (isValid) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _email.trim());
        utils.snackBarCheck(context, "Check your Email to reset your Password");
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
