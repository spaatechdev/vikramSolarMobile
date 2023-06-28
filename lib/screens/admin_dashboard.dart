import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({ Key? key }) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50, top: 130),
      child: const Text(
        'Dashboard',
        style: TextStyle(color: Colors.white, fontSize: 33),
        textAlign: TextAlign.center,
      ),
    );
  }
}