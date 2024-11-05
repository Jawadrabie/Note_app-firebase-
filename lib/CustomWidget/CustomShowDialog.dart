import 'package:flutter/material.dart';

class CustomShowDialog extends StatelessWidget {
  final String title;

  const CustomShowDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(Icons.error_rounded),
      iconColor: Colors.red,
      title: Text("Error"),
      content: Text(title),
    );
  }
}
