import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:ownspace/common/database/database_provider.dart';
import 'package:ownspace/passwordvault/model/secret.dart';
import 'package:ownspace/passwordvault/security/encryption.dart';

class EncryptedStorage {
  Encryption _encryption;

  EncryptedStorage(String salt) {
    var pinMd5 = md5.convert(utf8.encode(salt)).toString();
    _encryption = Encryption(pinMd5);
  }

  Future import(Map<String, dynamic> data) async {
    var currentKeys = await listKeys();
    for (var key in data.keys) {
      if (!currentKeys.contains(key)) {
        var decrypted = _encryption.decrypt(data[key]);
        var chunks = decrypted.split("|");
        await save(key, Secret(account: chunks[0], password: chunks[1]));
      }
    }
  }

  Future changePin(String oldPin, String newPint) async {
    Encryption encryptionOld = Encryption(md5.convert(utf8.encode(oldPin)).toString());
    Encryption encryptionNew = Encryption(md5.convert(utf8.encode(newPint)).toString());

    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor = await db.query(DatabaseProvider.VAULT_TABLE);

    for (Map<String, dynamic> row in cursor) {
      var accountDecrypted = encryptionOld.decrypt(row["account"]);
      var passwordDecrypted = encryptionOld.decrypt(row["password"]);

      await db.update(DatabaseProvider.VAULT_TABLE,
          {
            "account": encryptionNew.encrypt(accountDecrypted),
            "password": encryptionNew.encrypt(passwordDecrypted)
          }, where: "key = ?", whereArgs: [row['key']]);

      debugPrint("old: ${encryptionNew.encrypt(row["account"])}");
      debugPrint("new: ${encryptionNew.encrypt(accountDecrypted)}");
    }

    db.close();
  }

  Future<List<String>> listKeys() async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor = await db.query(DatabaseProvider.VAULT_TABLE, columns: ['key']);
    db.close();
    return cursor.map((row) => row['key'].toString()).toList();
  }

  Future delete(String key) async {
    var db = await DatabaseProvider().open();
    await db.delete(DatabaseProvider.VAULT_TABLE, where: "key = ?", whereArgs: [key]);
    db.close();
  }

  Future save(String key, Secret secret) async {
    var db = await DatabaseProvider().open();
    await db.insert(DatabaseProvider.VAULT_TABLE,
        {
          "key": key,
          "account": _encryption.encrypt(secret.account),
          "password": _encryption.encrypt(secret.password)
        });
    db.close();
  }

  Future<Secret> read(String key) async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor = await db.query(
        DatabaseProvider.VAULT_TABLE,
        where: "key = ?",
        whereArgs: [key]
    );
    db.close();
    return Secret(
        account: _encryption.decrypt(cursor[0]['account']),
        password: _encryption.decrypt(cursor[0]['password'])
    );
  }
}
