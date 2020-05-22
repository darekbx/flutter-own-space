import 'package:flutter/material.dart';

class ColorTool {
  
  static Color colorByAmount(double amount) {
    if (amount <= 36) {
      return Colors.green;
    } else if (amount > 36 && amount <= 46) {
      return Colors.lightGreen;
    } else if (amount > 46 && amount <= 56) {
      return Colors.lime;
    } else if (amount > 56 && amount <= 66) {
      return Colors.yellow;
    } else if (amount > 66 && amount <= 76) {
      return Colors.amber;
    } else if (amount > 76 && amount <= 86) {
      return Colors.orange;
    } else if (amount > 86 && amount <= 96) {
      return Colors.deepOrange;
    } else if (amount > 96 && amount <= 106) {
      return Colors.red;
    } else if (amount > 106 && amount <= 116) {
      return Colors.pink;
    } else if (amount > 116 && amount <= 126) {
      return Colors.purple;
    } else if (amount > 126 && amount <= 136) {
      return Colors.deepPurple;
    } else {
      return Colors.grey;
    }
  }
}
