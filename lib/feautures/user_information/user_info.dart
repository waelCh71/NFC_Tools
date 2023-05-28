// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../global/themes/colors.dart';
import '../../global/utils/utils.dart';
import '../../main.dart';

class UserInformation extends StatefulWidget {
  final User userInfo;

  const UserInformation({super.key, required this.userInfo});
  //UserInformation({Key? key}) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  Utils utils = Utils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acount"),
        backgroundColor: myGreen,
        actions: [
          CircleAvatar(
            child: Text(widget.userInfo.email![0].toUpperCase()),
          ),
        ],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
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
              horizontal: 100,
              vertical: 200,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Email: ${widget.userInfo.email!}",
                  style: const TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  width: 250,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        signOut();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: myGreen,
                      ),
                      label: const Text(
                        "Sign Out",
                        style: TextStyle(
                          color: myGreen,
                          fontSize: 18,
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signOut() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: myRed,
              ),
            ));
    await Future.delayed(const Duration(milliseconds: 2000));
    try {
      await FirebaseAuth.instance.signOut();
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      utils.snackBarCheck(context, e.message.toString());
    }
  }
}
