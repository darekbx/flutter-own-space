import 'package:flutter/material.dart';
import 'package:ownspace/passwordvault/backup/backuppage.dart';
import 'package:ownspace/passwordvault/security/encryptedstorage.dart';
import 'package:ownspace/passwordvault/storage.dart';
import 'package:ownspace/passwordvault/vault/addsecretpage.dart';
import 'package:ownspace/passwordvault/vault/secretpage.dart';

class KeysListPage extends StatefulWidget {
  KeysListPage({Key key}) : super(key: key);

  @override
  _KeysListState createState() => _KeysListState();
}

class _KeysListState extends State<KeysListPage> {
  final Storage _storage = Storage();

  EncryptedStorage _encryptedStorage;
  Future<List<String>> _keys;

  @override
  void initState() {
    super.initState();
    _keys = _fetchKeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Vault"),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (index) => _menuOptionSelected(context),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem(child: Text("Export / Import"), value: 1)
              ];
            },
          ),
        ],
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _addSecret();
          }),
    );
  }

  void _menuOptionSelected(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => BackupPage()));
    _refresh();
  }

  FutureBuilder _buildList() {
    return FutureBuilder<List<String>>(
        future: _keys,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          return _handleFuture(context, snapshot);
        });
  }

  Future<List<String>> _fetchKeys() async {
    var pin = await _storage.readPin();
    _encryptedStorage = EncryptedStorage(pin);
    return await _encryptedStorage.listKeys();
  }

  Widget _handleFuture(
      BuildContext context, AsyncSnapshot<List<String>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.hasError) {
          return _buildError(snapshot.error);
        } else {
          if (snapshot.data == null) {
            return _buildError("Error :( ");
          } else {
            if (snapshot.data.isEmpty) {
              return _buildEmptyView();
            } else {
              return _buildListView(snapshot.data);
            }
          }
        }
    }
  }

  Widget _buildEmptyView() {
    return Center(child: Text("The list is empty."));
  }

  Widget _buildListView(List<String> keys) {
    return ListView.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) => _buildListItem(keys[index]));
  }

  Widget _buildListItem(String key) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(left: 8, top: 8, right: 8),
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(8), child: Icon(Icons.vpn_key)),
            Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  key,
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
      onTap: () {
        _openSecret(key);
      },
      onLongPress: () {
        _deleteSecret(key);
      },
    );
  }

  _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildError(String errorMessage) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(errorMessage),
    );
  }

  _refresh() {
    setState(() {
      _keys = _fetchKeys();
    });
  }

  _openSecret(String key) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SecretPage(secretKey: key)));
  }

  _deleteSecret(String key) {
    var cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    var deleteButton = FlatButton(
      child: Text("Delete"),
      onPressed: () {
        Navigator.pop(context);
        _encryptedStorage.delete(key);
        _refresh();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Password Vault"),
          content: Text("Delete secret with \"$key\" key?"),
          actions: [
            cancelButton,
            deleteButton,
          ],
        );
      },
    );
  }

  _addSecret() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddSecretPage()))
        .then((_) {
      _refresh();
    });
  }
}
