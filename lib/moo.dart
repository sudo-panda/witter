import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MooPage extends StatefulWidget {
  MooPage({Key key}) : super(key: key);

  @override
  _MooPageState createState() => _MooPageState();
}

class _MooPageState extends State<MooPage> {
  final _mooController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  void hasLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('email'))
      Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  void initState() {
    super.initState();

    _mooController.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _mooController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: 300),
          child: Padding(
            padding: const EdgeInsets.all(10),
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
                    SizedBox(
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
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ButtonTheme(
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
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                Navigator.pushReplacementNamed(context, "/");

                                // TODO  change this
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                hasLoggedIn();
                                // TODO till here
                              }
                            },
                            child: Text(
                              "Moo",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15),
                            ),
                          ),
                        )
                      ],
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

  void _onSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  void _onTextChange() {}
}
