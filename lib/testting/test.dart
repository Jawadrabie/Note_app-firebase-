import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController( ) ;

  Future<void> savedata() async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection("test");
      print(
          "Saving data: ${controller1.text}, ${controller2.text}, ${controller3
              .text}");
      int price=int.parse(controller4.text);
      await users.add({
        "name": controller1.text,
        "phone": controller2.text,
        "age": controller3.text,
        "price": price,
      });
      print("Data saved successfully!");
    } catch (e) {
      print("Error saving data: $e");
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: "name"),
              controller: controller1,
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "phone"),
              controller: controller2,
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "age"),
              controller: controller3,
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "price"),
              controller: controller4,
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                savedata();
              },
              child: Text("save"),
              color: Colors.brown,
            ),
            SizedBox(
              height: 20,
            ),
            Divider(thickness: 20),
            SizedBox(
              height: 20,
            ),
            Text(
              "The Result",
              style: (TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('test').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Erorr"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            DocumentReference documentReference = FirebaseFirestore.instance
                                .collection("test")
                                .doc(snapshot.data!.docs[index].id);

                            try {
                              await FirebaseFirestore.instance.runTransaction((transaction) async {
                                // Get the document
                                DocumentSnapshot snapshot = await transaction.get(documentReference);

                                if (snapshot.exists) {
                              var snapshotData=snapshot.data();
                                  if(snapshotData is Map<String,dynamic>){
                                    int money=snapshotData["price"]+100;
                                    transaction.update(documentReference, {"price":money});
                                  }

                                } else {
                                  // Handle the case where the document doesn't exist
                                  print("Document not found!");
                                }
                              });
                            } catch (error) {
                              print("Error updating price: $error");
                            }
                          },
                          child: Card(
                            child: ListTile(
                              title:
                              Text("${snapshot.data!.docs[index]["name"]}"),
                              // Access data by field name
                              subtitle:
                              Text("${snapshot.data!.docs[index]["age"]} - "
                                  "${snapshot.data!.docs[index]["phone"]}"),
                              trailing: Text(
                                "${snapshot.data!.docs[index]["price"]}\$",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
