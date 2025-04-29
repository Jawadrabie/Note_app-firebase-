import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/CustomWidget/CustomButtom.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 'package:awesome_dialog/awesome_dialog.dart';
import '../CustomWidget/CustomShowDialog.dart';
import '../CustomWidget/CustomTextFeild.dart';

class loginPage extends StatefulWidget {
  loginPage({
    super.key,
  });

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  bool Isloading = false;

  Future signInWithGoogle() async {
    Isloading = true;
    setState(() {});
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //هي التعليمو منشان اذا لغي اختيار الحساب يعني عمل
    // cancle ما يرجع قيم null
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print(
        "===================================================================sucess");

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Isloading = false;
    setState(() {});
    Navigator.of(context).pushNamedAndRemoveUntil(
      "HomePage",
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formState,
          child: Isloading == true
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
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
                        "Login",
                        style: TextStyle(
                            color: Color(0xFF4F3434),
                            fontSize: 35,
                            fontWeight: FontWeight.w600),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      CustomTextFeild(
                        hint: "Enter your password",
                        controller: password,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                              onPressed: () async {
                                //في حال كان حقل البريد فارغ
                                if (email.text.isEmpty) {
                                  CustomShowDialog(
                                      context, "يرجى كتابة ايميل ");
                                }
                                // بجوز ما يأدخل حساب مسجل سابق user not foundا
                                else {
                                  try {
                                    //لارسال رسالة اعادة تعيين كلمة مرور جديدة
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: email.text);
                                    //
                                    CustomShowDialog(context,
                                        "يرجى مراجعة ايميلك لاعادة تعيين كلمة المرور");
                                  } catch (e) {
                                    CustomShowDialog(
                                        context, "يرجى ادخال حساب مسجلا سابقا");

                                    print(e);
                                  }
                                }
                              },
                              child: Text(
                                "Forget password?",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              )),
                        ],
                      ),
                      CustomButtom(
                        title: "Login",
                        onPressed: () async {
                          if (formState.currentState!.validate()) {
                            Isloading = true;
                            setState(() {});
                            try {
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              Isloading = false;
                              setState(() {});
                              //الحساب مؤكد
                              if (FirebaseAuth
                                  .instance.currentUser!.emailVerified) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  "HomePage",
                                  (route) => false,
                                );
                              } else {
                                FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();
                                CustomShowDialog(context,
                                    "يرجى الضغط على رابط للتاكد من حسابك ثم المتابعة في صفحة تسجيل الدخول");
                              }
                            } on FirebaseAuthException catch (e) {
                              Isloading = false;
                              setState(() {});
                              String message;
                              if (e.code == 'user-not-found') {
                                message = 'No user found for that email.';
                              } else if (e.code == 'wrong-password') {
                                message =
                                    'Wrong password provided for that user.';
                              } else {
                                message = 'Error: ${e.message}';
                              }
                              // عرض مربع حوار للمستخدم مع رسالة الخطأ
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login With google",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
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
                          Text("Don\'t have an account?"),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("RegisterPage");
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
    );
  }
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
