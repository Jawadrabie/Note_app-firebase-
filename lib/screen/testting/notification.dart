import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}
class _notificationState extends State<notification> {
  getToken() async{
    String? myToken=await FirebaseMessaging.instance.getToken();
    print("=========================+++");
    print(myToken);
  }
@override
  void initState() {
  getToken();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),

      ),
  
    );
  }
}
