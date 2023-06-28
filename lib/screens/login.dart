import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:vikram_solar/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vikram_solar/screens/admin_dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String displayMessage = "";
  String displayMessageType = "";

  void login(String email, password) async {
    await dotenv.load(fileName: "lib/.env");
    
    displayMessage = '';
    displayMessageType = '';
    if (email == "" || password == "") {
      setState(() {
        displayMessage = 'Please fill all the details';
        displayMessageType = 'error';
      });
    } else if (EmailValidator.validate(email) != true) {
      setState(() {
        displayMessage = 'Please enter a valid email address';
        displayMessageType = 'error';
      });
    } else {
      try {
        String loginUrl = (dotenv.env['SERVER_URL'].toString() + dotenv.env['LOGIN_PATH'].toString()).trim();
        Response response = await post(
          Uri.parse(loginUrl),
          body: {
            'email': email,
            'password': password,
          });
        debugPrint(response.statusCode.toString());
        if (response.statusCode == 200) {
          debugPrint(response.body);
          setState(() {
            displayMessage = '';
            displayMessageType = '';
          });
          String accessToken = jsonDecode(response.body)['access'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);
          showToastMessage('Logged in Successfully', 'success', 'short');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        } else {
          setState(() {
            displayMessage = jsonDecode(response.body)['detail'];
            displayMessageType = 'error';
          });
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/pattern.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 50, top: 130),
              child: const Text(
                'Login to Portal',
                style: TextStyle(color: Colors.white, fontSize: 33),
                textAlign: TextAlign.right,
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                  right: 35,
                  left: 35),
              child: Column(
                children: [
                  if (displayMessage.isNotEmpty)
                    displayMessageType == 'error'
                        ? Text(
                            displayMessage,
                            style: const TextStyle(color: Colors.red),
                          )
                        : Text(
                            displayMessage,
                            style: const TextStyle(color: Colors.green),
                          ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: IconButton(
                            color: const Color(0xff4c505b),
                            onPressed: () {
                              login(emailController.text.toString(),
                                  passwordController.text.toString());
                            },
                            icon: const Icon(Icons.arrow_forward)),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Color(0xFFFFFFFF)),
                          )),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Color(0xFFFFFFFF)),
                          )),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
