import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class EnrollPage extends StatefulWidget {
  @override
  _EnrollPageState createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  final _controller = CarouselController();

  void checkEligibility() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('email'))
      Navigator.pushReplacementNamed(context, '/login');
    if (prefs.containsKey('enrolled'))
      Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void initState() {
    super.initState();
    checkEligibility();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        items: [
          EnrollInput(
            gotoNext: gotoNext,
            inputText: lorem(paragraphs: 1, words: 20),
          ),
          EnrollInput(
            gotoNext: gotoNext,
            inputText: lorem(paragraphs: 1, words: 20),
            isLast: true,
          ),
        ],
        options: CarouselOptions(
            scrollPhysics: NeverScrollableScrollPhysics(),
            onPageChanged: (index, reason) {
              setState(() {});
            },
            enableInfiniteScroll: false,
            height: 800,
            
            ),
        carouselController: _controller,
      ),
    );
  }

  void gotoNext() {
    _controller.nextPage();
  }
}

class EnrollInput extends StatefulWidget {
  const EnrollInput(
      {var key,
      @required Function gotoNext,
      @required var inputText,
      var isLast = false})
      : _gotoNext = gotoNext,
        _inputText = inputText,
        _isLast = isLast;

  final Function() _gotoNext;
  final String _inputText;
  final bool _isLast;

  @override
  _EnrollInputState createState() => _EnrollInputState();
}

class _EnrollInputState extends State<EnrollInput> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
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
                Text(
                  'Type this text in the box below:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  widget._inputText,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 100,
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    minLines: null,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: widget._inputText,
                      contentPadding: EdgeInsets.all(20),
                      border: OutlineInputBorder(),
                      labelText: 'Type Here',
                      alignLabelWithHint: true,
                    ),
                    textInputAction: TextInputAction.done,
                    onSaved: (email) => null,
                  ),
                ),
                SizedBox(
                  height: 16,
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
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          //TODO add API request

                          if (!widget._isLast)
                            widget._gotoNext();
                          else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('enrolled', true);
                            Navigator.pushReplacementNamed(context, "/");
                          }
                        }
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15),
                      ),
                    ),
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
