import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class image_Poker extends StatefulWidget {
  const image_Poker({super.key});

  @override
  State<image_Poker> createState() => _image_PokerState();
}

class _image_PokerState extends State<image_Poker> {
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
    var refStorge = FirebaseStorage.instance.ref("images/").child(imagename);

    await refStorge.putFile(file!);
    url = await refStorge.getDownloadURL();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("image poker"),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: MaterialButton(
                onPressed: () async {
                  await getimeage();
                },
                child: Text("save"),
              ),
            ),
            if (url != null)
              Image.network(
                url!,
                height: 200,
                width: 200,
              )
          ],
        ),
      ),
    );
  }
}
