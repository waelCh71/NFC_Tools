// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_app/global/themes/colors.dart';
import 'package:nfc_app/global/utils/utils.dart';
import 'package:nfc_manager/nfc_manager.dart';

class TagWrite extends StatefulWidget {
  const TagWrite({Key? key}) : super(key: key);

  @override
  State<TagWrite> createState() => _TagWriteState();
}

class _TagWriteState extends State<TagWrite> {
  var isAvailable = NfcManager.instance.isAvailable();
  ValueNotifier<dynamic> result = ValueNotifier(null);
  Utils utils = Utils();
  String text = "", uri = "";
  String? appName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tag Writer"),
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
            //   //horizontal: 50,
            //   vertical: 80,
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/nfc_scan.jpg"),
                const SizedBox(
                  height: 15,
                ),

                const SizedBox(
                  height: 20,
                ),
                //const Text("Start scanning your Tag..."),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await isAvailable) {
                        writeToTag(appName);
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
                    ),
                  ),
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

  void writeToTag(String? appName) {
    writeDialogue(context, text, uri, appName);
  }

  ndefWrite(String text1, String? uri1) {
    startScan1(context);

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      NdefMessage message;

      if (ndef == null || !ndef.isWritable) {
        utils.ndefNotSupported(context, "Tag is not writable");
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }
      if (uri1.toString().isEmpty) {
        message = NdefMessage([
          NdefRecord.createText(text1),
          NdefRecord.createMime(text1, Uint8List.fromList(text1.codeUnits)),
        ]);
      } else {
        message = NdefMessage([
          NdefRecord.createUri(Uri.parse("https://$uri1")),
          NdefRecord.createMime(text1, Uint8List.fromList(text1.codeUnits)),
          NdefRecord.createExternal('android.com', "https://$uri1",
              Uint8List.fromList('com.android.browser'.codeUnits)),
        ]);
      }

      try {
        await ndef.write(message);
        Navigator.pop(context);
        utils.nfcCheck(context, "Success to Ndef Write");
        NfcManager.instance.stopSession();
      } catch (e) {
        debugPrint("error");
        NfcManager.instance.stopSession();
        Navigator.pop(context);
        utils.snackBarCheck(context, "Something Went Wrong");
        return;
      }
    });
    //navigatorKey.currentState!.pop();
  }

  writeDialogue(
      BuildContext context, String text, String uri, String? appName) {
    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("ADD ACTION TO WRITE ON YOUR TAG"),
            titlePadding: const EdgeInsets.symmetric(horizontal: 12),
            content: Form(
              key: formKey,
              child: Column(
                children: [
                  const Text("ADD TEXT: "),
                  Expanded(
                    child: TextFormField(
                      autocorrect: true,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        //hintText: "description",
                        labelText: "text*",
                      ),
                      onChanged: (value) {
                        text = value;
                      },
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Text musn't be Empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("ADD Link: (Optional)"),
                  Expanded(
                      child: TextFormField(
                    autocorrect: true,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      //hintText: "description",
                      labelText: "url",
                      prefixText: "https://",
                      prefixStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onChanged: (value) {
                      uri = value;
                    },
                    // validator: (value) {
                    //   if (value.toString().isEmpty) {
                    //     return "URI musn't be Empty";
                    //   } else {
                    //     return null;
                    //   }
                    //},
                  )),
                  //TODO EXTERNAL APP

                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // const Text("Oppen External App: (Opptional)"),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // Container(
                  //   width: 200,
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  //   decoration: BoxDecoration(
                  //       border: Border.all(color: myBlack),
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: DropdownButton<String>(
                  //       value: appName,
                  //       items: appToOppen.map(buildMenuApp).toList(),
                  //       onChanged: (value) => setState(() {
                  //             print("test");

                  //             this.appName = value!;
                  //             print(appName);
                  //           })),
                  // ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel ")),
              TextButton(
                  onPressed: () {
                    final isValid = formKey.currentState?.validate();
                    if (isValid!) {
                      Navigator.pop(context);
                      ndefWrite(text, uri);
                    }
                  },
                  child: const Text("OK ")),
            ],
          );
        });
  }

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
                    NfcManager.instance.stopSession();
                    Navigator.pop(context);
                  },
                  child: const Text("cancel "))
            ],
          );
        });
  }

  DropdownMenuItem<String> buildMenuApp(String app) {
    return DropdownMenuItem(value: app, child: Text(app));
  }
}
