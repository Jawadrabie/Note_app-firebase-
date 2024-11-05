import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class show extends StatelessWidget {
  const show({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: MaterialButton(color: Colors.red,
                onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                icon: Icon(Icons.error_rounded),
                iconColor: Colors.red,
                title: Text("Error"),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('HomePage');
                    },
                    child: Text("ok"),
                  )
                ],
              );
            },
          );
                },
                child: Text("press to Show"),
              ),
        ));
  }
}
