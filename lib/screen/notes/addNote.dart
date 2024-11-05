import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waelfirebase/CustomWidget/CustomButtom.dart';
import 'package:waelfirebase/CustomWidget/CustomTextFeild.dart';
import 'package:path/path.dart';
import 'noteView.dart';

class addNote extends StatefulWidget {
  final String docid;

  const addNote({super.key, required this.docid});

  @override
  State<addNote> createState() => _addNoteState();
}

class _addNoteState extends State<addNote> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  bool Isloading = false;
  File? file;
  String? url;

  getimeage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photocamera =
        await picker.pickImage(source: ImageSource.gallery);
    if (photocamera != null) {
      file = File(photocamera.path);
    }
    var imagename = basename(photocamera!.path);
    var refStorge = FirebaseStorage.instance.ref("images/$imagename");
    await refStorge.putFile(file!);
    url = await refStorge.getDownloadURL();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AddNote() {
      CollectionReference collectionNote = FirebaseFirestore.instance
          .collection('Catogries')
          .doc(widget.docid)
          .collection("note");
      Isloading = false;
      if (formState.currentState!.validate()) {
        // Call the user's CollectionReference to add a new user
        Isloading = true;
        setState(() {});
        collectionNote
            .add({"note": note.text, "url": url ?? "none"})
            .then((value) => print("note Added"))
            .catchError((error) => print("Failed to add note: $error"));
        Isloading = false;
        setState(() {});
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => notView(Idcatogry: widget.docid),
          ),
        );
      }
    }

    //var email = ModalRoute.of(context)!.settings.arguments ;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body: Form(
        key: formState,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CustomTextFeild(hint: "add your Note", controller: note),
              SizedBox(
                height: 25,
              ),
              CustomButtomUpload(
                title: "Uploade image",
                onPressed: () async {
                  await getimeage();
                },
                IsSelected: url == null ? false : true,
              ),
              SizedBox(
                height: 25,
              ),
              CustomButtom(
                  title: "Add",
                  onPressed: () {
                    AddNote();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
