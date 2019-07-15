import 'package:flutter/material.dart';
import 'tasklist.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 700),()=>Navigator.push(context,MaterialPageRoute(
      builder: (context)=>TaskList(),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        child: Center(
          child:Text("Get your all tasks done!!",style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
          ),)
        ),
      ),
    );
  }
}