import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/CustomWidget/CustomButtom.dart';
import 'package:waelfirebase/CustomWidget/CustomTextFeild.dart';

class addCatogary extends StatefulWidget {
  const addCatogary({super.key});

  @override
  State<addCatogary> createState() => _addCatogaryState();
}

class _addCatogaryState extends State<addCatogary> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();

  bool Isloading = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference Catogries =
    FirebaseFirestore.instance.collection('Catogries');
    addcatogary() {
      if (formState.currentState!.validate()) {
        // Call the user's CollectionReference to add a new user
        Isloading = true;
        setState(() {});
        Catogries.add({
          "name": name.text,
          "id": FirebaseAuth.instance.currentUser!.uid
        })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));

        Navigator.pushNamedAndRemoveUntil(
          context,
          "HomePage",
              (route) => false,
        );
      }
    }

    //var email = ModalRoute.of(context)!.settings.arguments ;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Catogary"),
      ),
      body: Form(
        key: formState,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CustomTextFeild(hint: "add your catogry", controller: name),
              SizedBox(
                height: 25,
              ),

              CustomButtom(
                  title: "Add",
                  onPressed: () {
                    addcatogary();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
