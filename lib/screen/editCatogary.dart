import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/CustomWidget/CustomButtom.dart';
import 'package:waelfirebase/CustomWidget/CustomTextFeild.dart';

class editCatogary extends StatefulWidget {
  final String docid;
  final String oldname;

  const editCatogary({
    super.key,
    required this.docid,
    required this.oldname,
  });

  @override
  State<editCatogary> createState() => _editCatogaryState();
}

class _editCatogaryState extends State<editCatogary> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  CollectionReference Catogries =
      FirebaseFirestore.instance.collection('Catogries');
  bool Isloading = false;

  editcatogary() {
    if (formState.currentState!.validate()) {
      // Call the user's CollectionReference to add a new user
      Isloading = true;
      setState(() {});
      Catogries.doc(widget.docid)
          .set({"name": name.text},
          SetOptions(merge: true)
      )
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      Navigator.pushNamedAndRemoveUntil(
        context,
        "HomePage",
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    name.text = widget.oldname;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var email = ModalRoute.of(context)!.settings.arguments ;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Catogary"),
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
                  title: "حفظ",
                  onPressed: () {
                    editcatogary();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
