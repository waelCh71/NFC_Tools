import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../global/themes/colors.dart';
import '../../../global/utils/constante.dart';
import '../../user_information/user_info.dart';
import '../widget/nfc_lock.dart';
import '../widget/nfc_reader.dart';
import '../widget/nfc_writer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: myGreen,
        actions: [
          InkWell(
            onTap: () {
              navigation(
                  context,
                  UserInformation(
                    userInfo: user,
                  ));
            },
            child: CircleAvatar(
              child: Text(user.email![0].toUpperCase()),
            ),
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
                //read nfc
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      navigation(context, const TagRead());
                    },
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: myGreen,
                    ),
                    label: const Text(
                      "Read TAG",
                      style: TextStyle(
                        color: myGreen,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                //write nfc
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        navigation(context, const TagWrite());
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: myGreen,
                      ),
                      label: const Text(
                        "Modify TAG",
                        style: TextStyle(
                          color: myGreen,
                          fontSize: 18,
                        ),
                      )),
                ),

                //lock nfc
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        navigation(context, const TagLock());
                      },
                      icon: const Icon(
                        Icons.lock,
                        color: myGreen,
                      ),
                      label: const Text(
                        "Lock TAG",
                        style: TextStyle(
                          color: myGreen,
                          fontSize: 18,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
