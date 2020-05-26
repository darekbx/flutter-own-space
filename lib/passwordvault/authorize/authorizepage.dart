import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ownspace/passwordvault/storage.dart';
import 'package:ownspace/passwordvault/vault/keyslistpage.dart';

enum _State {
  PROVIDE_PIN,
  NOT_AUTHENTICATED,
  AUTHENTICATION_FAILED,
  AUTHENTICATED,
  ENTER_PIN
}

class AuthorizePage extends StatefulWidget {
  AuthorizePage({Key key}) : super(key: key);

  @override
  _AuthorizePageState createState() => _AuthorizePageState();
}

class _AuthorizePageState extends State<AuthorizePage> {
  final Storage _storage = Storage();
  final int _pinSize = 4;

  _State _authState = _State.NOT_AUTHENTICATED;
  var _focusNodes = List();
  var _pinControllers = List<TextEditingController>();

  @override
  void initState() {
    super.initState();
    _initAuthState();
  }

  @override
  void dispose() {
    super.dispose();
    _pinControllers.forEach((controller) => controller.dispose());
  }

  _initAuthState() async {
    _storage.containsPin().then((containsPin) {
      setState(() {
        _authState =
            containsPin ? _State.ENTER_PIN : _State.PROVIDE_PIN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_authState) {
      case _State.NOT_AUTHENTICATED:
        body = _displayAuthWidget();
        break;
      case _State.AUTHENTICATION_FAILED:
        body = _errorMessage("Authentication failed");
        break;
      case _State.AUTHENTICATED:
        body = Text("Authenticated");
        break;
      case _State.ENTER_PIN:
        body = _enterPin("Enter PIN");
        break;
      case _State.PROVIDE_PIN:
        body = _enterPin("Set new PIN");
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Vault - Authorize"),
      ),
      body: body,
    );
  }

  Widget _errorMessage(String message) =>
      _authWidget(message, "Retry", _retryAuthentication,
          color: Colors.redAccent);
  Widget _displayAuthWidget() => _authWidget(
      'Please authorize with fingerprint', "Or enter PIN", _onPinTap);

  Widget _authWidget(String title, String linkedMessage, Function callback,
      {Color color = Colors.black}) {
    return Center(
        child: Card(
            elevation: 3.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.fingerprint, size: 75.0, color: color),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: <Widget>[
                        Text(title,
                            textScaleFactor: 1.1,
                            style: TextStyle(color: color)),
                        InkWell(
                            child: Text(linkedMessage,
                                textScaleFactor: 1.1,
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            onTap: callback)
                      ]))
                ],
              ),
            )));
  }

  void _retryAuthentication() {
    setState(() {
      _authState = _State.NOT_AUTHENTICATED;
    });
  }

  Widget _enterPin(String title) {
    return Center(
      child: Card(
          elevation: 3.0,
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(title,
                        textScaleFactor: 1.1,
                        style: TextStyle(color: Colors.black))),
                Wrap(spacing: 4, children: <Widget>[
                  for (var i = 0; i < _pinSize; i++) _createPinField(i)
                ])
              ]))),
    );
  }

  Widget _createPinField(int index) {
    _focusNodes.add(FocusNode());
    _pinControllers.add(TextEditingController());
    return Container(
        width: 44,
        child: TextFormField(
          maxLength: 1,
          focusNode: _focusNodes[index],
          controller: _pinControllers[index],
          keyboardType: TextInputType.number,
          textInputAction:
              index == 3 ? TextInputAction.send : TextInputAction.next,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16),
              border: OutlineInputBorder(),
              counterText: ''),
          onFieldSubmitted: (field) {
            if (index == 3) {
              _onPinAuthorize();
            } else {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
          },
          onChanged: (text) {
            if (text.length == 1) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
          },
        ));
  }

  void _onPinTap() {
    setState(() {
      _authState = _State.ENTER_PIN;
    });
  }

  void _onPinAuthorize() {
    var pin = "";
    _pinControllers.forEach((controller) {
      pin += controller.text;
      controller.clear();
    });
    if (_authState == _State.ENTER_PIN) {
      _verifyPin(pin);
    } else if (_authState == _State.PROVIDE_PIN) {
      _storage.savePin(pin);
      setState(() {
        _authState = _State.NOT_AUTHENTICATED;
      });
    }
  }

  void _verifyPin(String pin) async {
    var storedPin = await _storage.readPin();
    if (storedPin == pin) {
      _redirectToVault();
    } else {
      setState(() {
        _authState = _State.AUTHENTICATION_FAILED;
      });
    }
  }

  void _redirectToVault() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => KeysListPage()),
        (Route<dynamic> route) {
          return route.isFirst;
        });
  }
}
