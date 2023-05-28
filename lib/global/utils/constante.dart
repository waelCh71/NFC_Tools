import 'package:flutter/material.dart';

const int splachDuration = 2500;

void navigation(context, x) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => x));
}

final appToOppen = [
  " Browser",
  " Facebook",
  " Musique",
  " Play Store",
  " Settings"
];
