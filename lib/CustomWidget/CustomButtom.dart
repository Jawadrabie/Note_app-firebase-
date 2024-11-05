import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final String title;
  void Function()? onPressed;

  CustomButtom({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 400,
      height: 50,
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      color: Color(0xFF4F3434),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class CustomButtomUpload extends StatelessWidget {
  final bool IsSelected;
  final String title;
  void Function()? onPressed;

  CustomButtomUpload({
    super.key,
    required this.title,
    required this.onPressed,
    required this.IsSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 300,
      height: 40,
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      color: IsSelected ? Colors.green : Color(0xFF4F3434),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
