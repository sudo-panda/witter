import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MooPage extends StatefulWidget {
  MooPage({Key key}) : super(key: key);

  @override
  _MooPageState createState() => _MooPageState();
}

class _MooPageState extends State<MooPage> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  String _moo = '';
  final _mooController = TextEditingController();

  void checkEligibilty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('email')) {
      Navigator.pushReplacementNamed(context, "/login");
    } else if (!prefs.containsKey('enrolled')) {
      Navigator.pushReplacementNamed(context, '/enroll');
    }
  }

  @override
  void initState() {
    super.initState();

    checkEligibilty();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Text(
                      'Witter',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 25),
                    )),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 150,
                      child: TextFormField(
                        focusNode: _focusNode,
                        autofocus: true,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        minLines: null,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        textAlignVertical: TextAlignVertical.top,
                        controller: _mooController,
                        validator: (text) {
                          if (text.trim().length > 20) {
                            return null;
                          } else {
                            return "Need more than 20 characters for your Moo";
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Whats on your mind?',
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(),
                          labelText: 'Moo',
                          suffixIcon: Icon(Icons.create),
                        ),
                        onSaved: (moo) => _moo = moo,
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: ButtonTheme(
                          minWidth: 100,
                          height: 45,
                          child: OutlineButton(
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 4,
                              style: BorderStyle.solid,
                            ),
                            splashColor: Theme.of(context).accentColor,
                            onPressed: _onSubmit,
                            child: Text(
                              "Moo",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '  Your Moos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                          ),
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 900),
                      child: FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                      ConnectionState.none &&
                                  snapshot.hasData == null ||
                              snapshot.data == null) {
                            return Center(
                                child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ));
                          }
                          if (snapshot.data.length == 0) {
                            return Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'I can see you have no moos yet, type one out',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ));
                          }
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color),
                                ),
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'time',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Text(snapshot.data[index].toString()),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        future: getMoos(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (await _checkAuthViaAPI()) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var moos = await getMoos();
        moos.insert(0, _moo);
        prefs.setStringList('moos', moos);

        setState(() {
          _mooController.clear();
        });
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('email');
        prefs.remove('enrolled');
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Future<bool> _checkAuthViaAPI() async {
    return true;
  }

  Future<List<String>> getMoos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('moos')) {
      return prefs.getStringList('moos');
    } else {
      return [];
    }
  }

  List<Widget> wrapStrings(List<String> stringList) {
    List<Widget> widgetList = [];
    for (var string in stringList) {
      widgetList.add(Text(string));
    }
    return widgetList;
  }
}
