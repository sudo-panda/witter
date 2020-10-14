import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Witter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _mooController = TextEditingController();

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
      appBar: AppBar(
        title: Center(child: Text(widget.title, style: TextStyle(color: Theme.of(context).accentColor),)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: true,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  minLines: null,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  textAlignVertical: TextAlignVertical.top,
                  controller: _mooController,
                  decoration: InputDecoration(
                    hintText: 'Whats on your mind?',
                    helperText: 'You are good to go',
                    contentPadding: EdgeInsets.all(20),
                    border: OutlineInputBorder(),
                    labelText: 'Moo',
                    suffixIcon: Icon(Icons.create)
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  OutlineButton(
                    onPressed: _onSubmit,
                    child: Text(
                      'Moo',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor),
                    ),
                    shape: StadiumBorder(),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 4,
                      style: BorderStyle.solid,
                    ),
                    splashColor: Theme.of(context).accentColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    
  }

  void _onTextChange() {

  }
}
