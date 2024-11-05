import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/CustomWidget/CustomButtom.dart';
import 'package:waelfirebase/CustomWidget/CustomTextFeild.dart';
import 'package:waelfirebase/screen/notes/noteView.dart';

class editNote extends StatefulWidget {
  final String Idcatogry;
  final String oldname;
  final String Idnote;

  const editNote({
    super.key,
    required this.Idcatogry,
    required this.oldname,
    required this.Idnote,
  });

  @override
  State<editNote> createState() => _editNoteState();
}

class _editNoteState extends State<editNote> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();

  bool Isloading = false;

  @override
  void initState() {
    note.text = widget.oldname;
    // TODO: implement initState
    super.initState();
  }

  editcatogary() {
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection('Catogries')
        .doc(widget.Idcatogry)
        .collection("note");
    if (formState.currentState!.validate()) {
      // Call the user's CollectionReference to add a new user
      Isloading = true;
      setState(() {});
      collectionNote.doc(widget.Idnote)
          .update(
            {"note": note.text},
          )
          .then((value) => print("note Added"))
          .catchError((error) => print("Failed to add note: $error"));

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => notView(Idcatogry: widget.Idcatogry),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit note"),
      ),
      body: Form(
        key: formState,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CustomTextFeild(hint: "add your note", controller: note),
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
