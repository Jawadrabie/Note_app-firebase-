import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class boot extends StatefulWidget {
  const boot({super.key});

  @override
  State<boot> createState() => _bootState();
}

class _bootState extends State<boot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: MaterialButton(
          onPressed: () {},
          child: Text("test"),
          color: Colors.green,
        ),
      ),
    );
  }
}
