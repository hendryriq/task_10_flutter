import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_10/auth/login_page.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  Future register() async {
    var url = Uri.http("192.168.0.158", "/task_10/register.php");
    var response = await http.post(url, body: {
      "email": email.text.toString(),
      "name": name.text.toString(),
      "password": password.text.toString(),
    });

    try {
      var data = json.decode(response.body);

      if (data == "Error") {
        Fluttertoast.showToast(
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          msg: 'User already exists!',
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.green,
          textColor: Colors.white,
          msg: 'Registration Successful',
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    } catch (e) {
      print("Error decoding JSON: $e");
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Error decoding server response',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 340, 0, 0),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: email,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: name,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: "Name",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      obscureText: true,
                      controller: password,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: MaterialButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    minWidth: 500,
                    height: 55,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      register();
                    },
                    child: const Text("Sign Up"),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
