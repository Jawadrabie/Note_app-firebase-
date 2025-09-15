import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFeild extends StatelessWidget {
  final String? hint;
  TextEditingController controller = TextEditingController();

   CustomTextFeild({super.key, required this.hint,required this.controller,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "هذا الحقل مطلوب";
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
       // labelText: hint,
        fillColor: Colors.grey[300],
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }
}
