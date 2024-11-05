import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/CustomWidget/CustomButtom.dart';
import 'package:waelfirebase/CustomWidget/CustomShowDialog.dart';
//import 'package:awesome_dialog/awesome_dialog.dart';

import '../CustomWidget/CustomTextFeild.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController user = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formState,
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Image.asset(
                    "images/Logo.png",
                    height: 80,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Register",
                style: TextStyle(
                    color: Color(0xFF4F3434),
                    fontSize: 35,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Register to continue app",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "User Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              CustomTextFeild(hint: "user name", controller: user),
              SizedBox(
                height: 10,
              ),
              Text(
                "Email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              CustomTextFeild(
                hint: "Enter your email",
                controller: email,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              CustomTextFeild(
                hint: "Enter your password",
                controller: password,
              ),
              SizedBox(
                height: 25,
              ),
              CustomButtom(
                title: "Register",
                onPressed: () async {
                  if (formState.currentState!.validate()) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      print("jaaaaaaaaaaaaaaaaaaaaaaa");
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: Icon(Icons.error_rounded),
                            iconColor: Colors.red,
                            title: Text("رسالة تحقق"),
                            content: Text(
                                "يرجى الضغط على رابط للتاكد من حسابك ثم المتابعة في صفحة تسجيل الدخول"),
                            actions: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "LoginPage", (route) => false);
                                },
                                child: Text("ok"),
                              )
                            ],
                          );
                        },
                      );
                    } on FirebaseAuthException catch (e) {
                      String message;
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        message = 'The password provided is too weak.';
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        message = 'The account already exists for that email.';
                      } else if (e.code == 'invalid-email') {
                        print('invalid email address');
                        message = 'invalid email address';
                      } else {
                        message = 'Error: ${e.message}';
                      }
                      CustomShowDialog(context, message);
                    } catch (e) {
                      print(e);
                      CustomShowDialog(context, e.toString());
                    }
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2, // سمك الخط
                        color: Colors.grey, // لون الخط
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2, // سمك الخط
                        color: Colors.grey, // لون الخط
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 400,
                height: 50,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login With google",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Image.asset(
                      "images/google.png",
                      height: 40,
                    )
                  ],
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Have an account?"),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void CustomShowDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.error_rounded),
          iconColor: Colors.red,
          title: Text("Error"),
          content: Text(message),
        );
      },
    );
  }
}
