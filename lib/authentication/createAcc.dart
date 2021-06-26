import 'dart:async';

import 'package:doctor/pages/mainscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username1;
  String username;
  submit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString('username', username.toString());
    });
    preferences.setString('username', username.toString());
    username1 = preferences.get('username');

    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      Timer(Duration(seconds: 1), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return MainScreen();
        }));
      });
    }
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MainScreen();
      }));
    });
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Set up your profile",
          style: GoogleFonts.merriweather(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      "Create a username",
                      style: GoogleFonts.ubuntu(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 3 || val.isEmpty) {
                            return "Username too short.";
                          } else if (val.trim().length > 20) {
                            return "Username too long";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          setState(() {
                            preferences.setString('username', val.toString());
                          });
                          preferences.setString('username', val.toString());
                          username1 = preferences.get('username');
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.always,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: submit,
                    child: Container(
                      height: 50.0,
                      width: 350.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
