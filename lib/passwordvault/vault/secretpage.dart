import 'package:flutter/material.dart';
import 'package:ownspace/passwordvault/model/secret.dart';
import 'package:ownspace/passwordvault/security/encryptedstorage.dart';
import 'package:ownspace/passwordvault/storage.dart';

class SecretPage extends StatefulWidget {
  SecretPage({Key key, this.secretKey}) : super(key: key);

  final String secretKey;

  @override
  _SecretState createState() => _SecretState();
}

class _SecretState extends State<SecretPage> {
  final _passwordController = TextEditingController();
  final _accountController = TextEditingController();
  final Storage _storage = Storage();

  Secret _secret;
  var _secretNotVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Password Vault - Secret"),
        ),
        body: _buildPreview());
  }

  Widget _buildPreview() {
    if (_secret != null) {
      return Center(child: _buildSecretView(_secret));
    }
    return Center(
      child: FutureBuilder<Secret>(
          future: _buildPasswordFuture(),
          builder: (BuildContext context, AsyncSnapshot<Secret> snapshot) {
            return _handleFuture(context, snapshot);
          }),
    );
  }

  Widget _buildKey() {
    return Text(widget.secretKey, style: TextStyle(fontSize: 28));
  }

  Future<Secret> _buildPasswordFuture() async {
    var pin = await _storage.readPin();
    EncryptedStorage encryptedStorage = EncryptedStorage(pin);
    return _secret = await encryptedStorage.read(widget.secretKey);
  }

  Widget _handleFuture(BuildContext context, AsyncSnapshot<Secret> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildSecretView(null);
      default:
        if (snapshot.hasError) {
          return _buildError(snapshot.error);
        } else {
          if (snapshot.data == null) {
            return _buildError("Error :( ");
          } else {
            return _buildSecretView(snapshot.data);
          }
        }
    }
  }

  _buildError(String errorMessage) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(errorMessage),
    );
  }

  Widget _buildSecretView(Secret secret) {
    if (secret == null) {
      return Container();
    }

    _passwordController.text = secret.password;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildKey(),
        _buildMaskedView(secret.account, _accountController),
        _buildMaskedView(secret.password, _passwordController)
      ],
    );
  }

  Widget _buildMaskedView(String value, TextEditingController controller) {
    controller.text = value;
    return Padding(
        padding: EdgeInsets.only(top: 16),
        child: Container(
            width: 250,
            color: Color(0x77000000),
            child: TextFormField(
                controller: controller,
                obscureText: _secretNotVisible,
                readOnly: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _secretNotVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white60,
                      ),
                      onPressed: () {
                        setState(() {
                          _secretNotVisible = !_secretNotVisible;
                        });
                      },
                    )))));
  }
}
