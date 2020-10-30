import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  final _formKey = GlobalKey<FormState>();
  FocusNode _emailFocusNode = FocusNode();

  void checkEligibility() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('email')) {
      if (prefs.containsKey('enrolled'))
        Navigator.pushReplacementNamed(context, '/');
      else
        Navigator.pushReplacementNamed(context, '/enroll');
    }
  }

  @override
  void initState() {
    super.initState();
    checkEligibility();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          constraints: BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 25.0,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Center(
                      child: Text(
                    'Witter',
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 30),
                  )),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    autofocus: true,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'e.g. abc@email.com',
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        suffixIcon: Icon(Icons.mail_outline)),
                    textInputAction: TextInputAction.done,
                    validator: (email) => EmailValidator.validate(email)
                        ? null
                        : "Invalid email address",
                    onSaved: (email) => _email = email,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 100,
                    height: 45,
                    child: OutlineButton(
                      shape: StadiumBorder(),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 4,
                        style: BorderStyle.solid,
                      ),
                      splashColor: Theme.of(context).accentColor,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('email', _email);
                          Navigator.pushReplacementNamed(context, "/");
                        }
                        emailEnroll(_email);
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

emailEnroll(email) async {
  var url = 'http://localhost:5000/enrol';
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email}),
  );
}