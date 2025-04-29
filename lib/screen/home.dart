import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'editCatogary.dart';
import 'notes/noteView.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Catogries")
            .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Future.delayed(Duration(seconds: 5), () {
            //   setState(() {}); // تحديث الواجهة لإعادة المحاولة تلقائيًا
            // });
            print(snapshot.error);
            return Center(child: Text("Error loading data${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data available"));
          }

          // استرجاع البيانات
          final data = snapshot.data!.docs;

          return GridView.builder(
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 200),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => notView(
                    Idcatogry: data[index].id,
                  ),
                ));
              },
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => editCatogary(
                                docid: data[index].id,
                                oldname: data[index]["name"],
                              ),
                            ));
                          },
                          child: Text("تعديل"),
                        ),
                        MaterialButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("Catogries")
                                .doc(data[index].id)
                                .delete();
                            Navigator.of(context).pop();
                          },
                          child: Text("حذف"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.folder_copy,
                        color: Colors.amber,
                        size: 60,
                      ),
                      Text(
                        "${data[index]["name"]}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addCatogary");
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.brown,
      ),
    );
  }
}

//@override
// Widget build(BuildContext context) {
//   return Scaffold(
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {
//         Navigator.of(context).pushNamed("addCatogary");
//       },
//       child: Icon(
//         Icons.add,
//         color: Colors.white,
//       ),
//       backgroundColor: Colors.brown,
//     ),
//     appBar: AppBar(
//       actions: [
//         IconButton(
//           onPressed: () async {
//             GoogleSignIn googleSignIn = GoogleSignIn();
//             googleSignIn.disconnect();
//             await FirebaseAuth.instance.signOut();
//             Navigator.of(context).pushNamedAndRemoveUntil(
//               "LoginPage",
//               (route) => false,
//             );
//           },
//           icon: Icon(
//             Icons.exit_to_app,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     ),
//     body: StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection("Catogries").snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         // بيانات Firestore التي تم جلبها
//         var data = snapshot.data!.docs;
//
//         return GridView.builder(
//           itemCount: data.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisExtent: 200,
//           ),
//           itemBuilder: (context, index) {
//             return Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(40.0),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.folder_copy,
//                       color: Colors.amber,
//                       size: 60,
//                     ),
//                     Text(
//                       "${data[index]["name"]}",
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     ),
//   );
// }
