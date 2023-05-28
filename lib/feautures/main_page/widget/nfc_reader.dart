// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:nfc_app/global/themes/colors.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../../global/utils/utils.dart';

class TagRead extends StatefulWidget {
  const TagRead({Key? key}) : super(key: key);

  @override
  State<TagRead> createState() => _TagReadState();
}

class _TagReadState extends State<TagRead> {
  var isAvailable = NfcManager.instance.isAvailable();
  ValueNotifier<dynamic> result = ValueNotifier(null);
  Utils utils = Utils();
  Duration scanningTime = const Duration(seconds: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tag Reader"),
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
                          // ignore: unrelated_type_equality_checks
                          if (await isAvailable) {
                            _tagRead1();
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
        ));
  }

  void _tagRead1() async {
    startScan1(context);
    try {
      var tag = await FlutterNfcKit.poll(
          timeout: const Duration(seconds: 60),
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag",
          readIso18092: true);
      var tagText = " N/A ";
      var tagUri = " N/A ";

      if (tag.ndefAvailable!) {
        var record = await FlutterNfcKit.readNDEFRecords();
        tagText = utf8.decode(record[1].type!.toList());
        if (record.length == 3) {
          tagUri = utf8.decode(record[0].payload!.toList());
        }
        utils.nfcReadInfo(context, tag.ndefCapacity.toString(), tag.id,
            tag.type.toString(), tagText, tagUri);
      } else {
        utils.nfcReadInfo(context, tag.ndefCapacity.toString(), tag.id,
            tag.type.toString(), tagText, tagUri);
        utils.nfcCheck(context, "Tag is not Compatible with NDEF");
      }

      await FlutterNfcKit.finish();
    } catch (e) {
      await FlutterNfcKit.finish();
      Navigator.pop(context);
      utils.snackBarCheck(context, "Something Went Wrong");
    }
  }

  // void _tagRead() async {
  //   debugPrint("pressed");

  //   await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
  //     var ndef = Ndef.from(tag);
  //     await ndef?.read();
  //     result.value = tag.data;
  //     print(result.value);
  //     debugPrint(result.value);
  //     debugPrint("stoped");
  //     //NfcManager.instance.stopSession();
  //   });
  //   debugPrint("stopped 2");
  // }

  void startScan1(BuildContext context) {
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
                    await FlutterNfcKit.finish();
                    Navigator.pop(context);
                  },
                  child: const Text("cancel "))
            ],
          );
        });
  }
}
