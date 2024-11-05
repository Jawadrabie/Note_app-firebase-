import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waelfirebase/screen/notes/addNote.dart';
import 'package:waelfirebase/screen/notes/editNote.dart';

class notView extends StatefulWidget {
  final String Idcatogry;

  const notView({super.key, required this.Idcatogry});

  @override
  State<notView> createState() => _notViewState();
}

class _notViewState extends State<notView> {
  bool Isloading = true;

// list فارغة
  List<QueryDocumentSnapshot> data = [];

//    دالة الاستدعاء get
  getdata() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Catogries")
          .doc(widget.Idcatogry)
          .collection("note")
          .get();
      //await Future.delayed(Duration(seconds: 20));
      data.addAll(querySnapshot.docs);
      Isloading = false;
      //   لتحديث الحالة
      setState(() {
        print("================sucsess");
      });
    } catch (e) {
      print("====================================$e");
    }
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => addNote(docid: widget.Idcatogry),
            ));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.brown,
        ),
        appBar: AppBar(
          title: Text("Note"),
          actions: [
            IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  "LoginPage",
                  (route) => false,
                );
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
          ],
        ),
        //  من هنا تحقق
        body: WillPopScope(
            child: Isloading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisExtent: 200),
                    itemBuilder: (context, index) => InkWell(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                icon: Icon(Icons.error_rounded),
                                iconColor: Colors.red,
                                title: Text("خصائص"),
                                content: Text("ماذا تريد؟"),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => editNote(
                                          Idnote: data[index].id,
                                          Idcatogry: widget.Idcatogry,
                                          oldname: data[index]["note"],
                                        ),
                                      ));
                                    },
                                    child: Text("تعديل"),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("Catogries")
                                          .doc(widget.Idcatogry)
                                          .collection("note")
                                          .doc(data[index].id)
                                          .delete();
                                      if(data[index]["url"] != "none")
                                        FirebaseStorage.instance.refFromURL(data[index]["url"]).delete();
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => notView(
                                          Idcatogry: widget.Idcatogry,
                                        ),
                                      ));
                                    },
                                    child: Text("حذف"),
                                  ),
                                ]);
                          },
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Text(
                                "${data[index]["note"]}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              if (data[index]["url"] != "none")
                                Image.network(data[index]["url"],height: 80,fit: BoxFit.fill,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            onWillPop: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                "HomePage",
                (route) => false,
              );
              return Future.value(false);
            }));
  }
}
