import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_10/auth/signup_page.dart';
import 'package:task_10/home_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  Future login() async {
    var url = Uri.http("192.168.0.158", "/task_10/login.php");
    var response = await http.post(url, body: {
      "email": email.text,
      "password": password.text,
    });

    var data = json.decode(response.body);

    if (data == "Success") {
      Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Login Successful',
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      // Navigate to another screen or perform any actions upon successful login
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Login Failed: $data', // Display the error message
        toastLength: Toast.LENGTH_SHORT,
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 300),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                    login();
                  },
                  child: const Text("Login"),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account?"),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage()));
                      },
                      child: Text(
                        "Sign Up",
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
    );
  }
}
