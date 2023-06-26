import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vikram_solar/screens/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {'login': (context) => const MyLogin()},
  ));
}

showToastMessage(String message, [message_type='', length = '']) => {
      if (length == 'short')
        {
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: message_type == "success" ? Colors.green : Colors.red )
        }
      else
        {
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: message_type == "success" ? Colors.green : Colors.red)
        }
    };
