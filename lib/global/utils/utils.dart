// ignore_for_file: use_build_context_synchronously

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/global/themes/colors.dart';

class Utils {
  //late BuildContext context1;

  void snackBarCheck(BuildContext context, String snackBarMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(
        snackBarMessage,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void nfcCheck(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK! "))
            ],
          );
        });
  }

  void ndefNotSupported(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("OK! "))
            ],
          );
        });
  }

  void nfcReadInfo(BuildContext context, String tagCapacity, String tagID,
      String tagType, String tagText, String tagUri) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Tag Info"),
            //actionsAlignment: MainAxisAlignment.end,
            content: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text("text: $tagText"),
                const Divider(
                  color: myblue,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text("Link: $tagUri"),
                const Divider(
                  color: myblue,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text("TAG ID: $tagID"),
                const SizedBox(
                  height: 15,
                ),
                Text("TAG Type: $tagType"),
                const SizedBox(
                  height: 15,
                ),
                Text("MAX Size: $tagCapacity"),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await FlutterClipboard.copy(tagText);
                    snackBarCheck(context, "Copied to ClipBoard ");
                  },
                  child: const Text("Copy ")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("OK! ")),
            ],
          );
        });
  }

  void startScan(BuildContext context) {
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
                    Navigator.pop(context);
                  },
                  child: const Text("cancel "))
            ],
          );
        });
  }
}
