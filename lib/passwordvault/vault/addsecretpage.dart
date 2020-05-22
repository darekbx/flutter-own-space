import 'package:flutter/material.dart';
import 'package:ownspace/passwordvault/model/secret.dart';
import 'package:ownspace/passwordvault/security/encryptedstorage.dart';
import 'package:ownspace/passwordvault/storage.dart';

class AddSecretPage extends StatefulWidget {
  AddSecretPage({Key key}) : super(key: key);

  @override
  _AddSecretState createState() => _AddSecretState();
}

class _AddSecretState extends State<AddSecretPage> {
  final _keyController = TextEditingController();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  final _passwordFocusNode = FocusNode();
  final _passwordRepeatFocusNode = FocusNode();

  final Storage _storage = Storage();
  EncryptedStorage _encryptedStorage;

  var _passwordNotVisible = true;
  var _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _initializeStorage();
  }

  _initializeStorage() async {
    var pin = await _storage.readPin();
    _encryptedStorage = EncryptedStorage(pin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Password Vault - Add Secret"),
        ),
        body: _buildForm());
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTextField(_keyController, "Secret key"),
          _buildTextField(_accountController, "Account"),
          _buildPasswordField(_passwordController, "Enter secret", false),
          _buildPasswordField(_passwordRepeatController, "Repeat secret", true),
          _buildErrorMessage(),
          _buildSaveButton()
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage.isEmpty) {
      return Container();
    } else {
      return Text(_errorMessage, style: TextStyle(color: Colors.redAccent));
    }
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: TextFormField(
            controller: controller,
            onFieldSubmitted: (field) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(),
                hintText: hint)));
  }

  Widget _buildPasswordField(
      TextEditingController controller, String hint, bool isRepeat) {
    return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: TextFormField(
            controller: controller,
            focusNode: isRepeat ? _passwordRepeatFocusNode : _passwordFocusNode,
            obscureText: _passwordNotVisible,
            onFieldSubmitted: (field) {
              if (!isRepeat) {
                FocusScope.of(context).requestFocus(_passwordRepeatFocusNode);
              }
            },
            textInputAction:
                isRepeat ? TextInputAction.none : TextInputAction.next,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(),
                hintText: hint,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordNotVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordNotVisible = !_passwordNotVisible;
                    });
                  },
                ))));
  }

  Widget _buildSaveButton() {
    return Expanded(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Save"),
                  textColor: Colors.white,
                  color: Colors.blueGrey,
                  onPressed: _save,
                ))));
  }

  _save() {
    var key = _keyController.text;
    var account = _accountController.text;
    var password = _passwordController.text;
    var passwordRepeat = _passwordRepeatController.text;

    if (key.isEmpty) {
      setState(() {
        _errorMessage = "Key cannot be empty";
      });
    } else if (account.isEmpty) {
      setState(() {
        _errorMessage = "Account cannot be empty";
      });
    } else if (password.isEmpty) {
      setState(() {
        _errorMessage = "Password cannot be empty";
      });
    } else if (passwordRepeat.isEmpty) {
      setState(() {
        _errorMessage = "Password repeat cannot be empty";
      });
    } else if (password != passwordRepeat) {
      setState(() {
        _errorMessage = "Passwords are not the same";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
      _encryptedStorage.save(key, Secret(account: account, password: password));
      Navigator.pop(context);
    }
  }
}
