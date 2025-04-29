import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class filter extends StatefulWidget {
  const filter({super.key});

  @override
  State<filter> createState() => _filterState();
}

List<QueryDocumentSnapshot> dataUser = [];

class _filterState extends State<filter> {
  // Create a CollectionReference called users that references the firestore collection

  initData() async {

      CollectionReference users = FirebaseFirestore.instance.collection('users');
      QuerySnapshot user = await users.orderBy("name",).get();
      user.docs.forEach((elment) {dataUser.add(elment);},);
    setState(() {});
  }
@override
  void initState() {
  initData();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter"),
      ),
      body: ListView.builder(
       itemCount: dataUser.length,
       itemBuilder: (context, index) => Card(
         child: ListTile(
           title: Text(dataUser[index]["full_name"]),
           subtitle: Text("age: ${dataUser[index]["age"]}"),
         ),
         color: Colors.deepPurple,
       ),
              ),
    );
  }
}
