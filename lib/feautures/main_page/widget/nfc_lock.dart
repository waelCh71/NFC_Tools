// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_app/global/themes/colors.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../../global/utils/utils.dart';

class TagLock extends StatefulWidget {
  const TagLock({Key? key}) : super(key: key);

  @override
  State<TagLock> createState() => _TagLockState();
}

class _TagLockState extends State<TagLock> {
  var isAvailable = NfcManager.instance.isAvailable();
  ValueNotifier<dynamic> result = ValueNotifier(null);
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tag Locker"),
        backgroundColor: myGreen,
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
            // padding: const EdgeInsets.symmetric(
            //   //horizontal: 100,
            //   vertical: 80,
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/nfc_scan.jpg"),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  width: 250,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (await isAvailable) {
                          ndefWriteLock();
                        } else {
                          utils.nfcCheck(context,
                              "You don't Have NFC Feature in your Device.");
                        }
                      },
                      child: const Text(
                        "Start ",
                        style: TextStyle(
                          color: myGreen,
                          fontSize: 18,
                        ),
                      )),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  width: 250,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
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

  ndefWriteLock() {
    startScan1(context);
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null) {
        utils.ndefNotSupported(context, "Tag is not Compatible with NDEF");
        NfcManager.instance.stopSession();
        return;
      }

      try {
        await ndef.writeLock();
        //FlutterNfcKit.makeNdefReadOnly();
        Navigator.pop(context);
        utils.nfcCheck(context, "Success to Ndef Write Lock");
        NfcManager.instance.stopSession();
      } catch (e) {
        NfcManager.instance.stopSession();
        Navigator.pop(context);
        utils.snackBarCheck(context, "Something Went Wrong");
      }
    });
  }

  startScan1(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Scannic..."),
            //actionsAlignment: MainAxisAlignment.end,
            content: Image.asset("assets/images/start_scan.gif"),

            actions: [
              TextButton(
                  onPressed: () async {
                    NfcManager.instance.stopSession();
                    Navigator.pop(context);
                  },
                  child: const Text("cancel "))
            ],
          );
        });
  }
}
