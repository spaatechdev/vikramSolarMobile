import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:vikram_solar/main.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String errorMessage = "";

  void login(String email, password) async {
    if (email == "" || password == "") {
      setState(() {
        errorMessage = 'Please fill all the details';
      });
    } else if (EmailValidator.validate(email) != true) {
      setState(() {
        errorMessage = 'Please enter a valid email address';
      });
    } else {
      try {
        Response response = await post(
            Uri.parse('https://vikram-solar.spaatech.net/api/login/'),
            body: {
              'email': email,
              'password': password,
            });
        if (response.statusCode == 200) {
          setState(() {
            errorMessage = '';
          });
          showToastMessage('Logged in Successfully', 'success', 'short');
        } else {
          setState(() {
            errorMessage = jsonDecode(response.body)['detail'];
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
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red
                      ),
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