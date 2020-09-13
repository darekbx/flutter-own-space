
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:path/path.dart' as path;

import 'GoogleHttpClient.dart';

class AutoBackup {

  final _folderSpace = "appDataFolder";
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata']);

  Future<List<ga.File>> listGoogleDriveFiles() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);

    var files = (await drive.files.list(spaces: _folderSpace)).files;
    await _logout();

    return files;
  }

  Future<void> uploadFile(String filePath) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    await _uploadFileToGoogleDrive(googleSignInAccount, filePath);
    await _logout();
  }

  Future<void> _logout() async {
    await googleSignIn.signOut();
  }

  Future<void> _uploadFileToGoogleDrive(GoogleSignInAccount googleSignInAccount, String filePath) async {
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    final file = await File(filePath);

    ga.File fileToUpload = ga.File();
    fileToUpload.parents = [_folderSpace];
    fileToUpload.name = path.basename(file.absolute.path);

    var response = await drive.files.create(
      fileToUpload,
      uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
    );
  }
}
