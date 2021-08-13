import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvUtils {

  Future initializeUtils() async {
    await dotenv.load(fileName: ".env");
  }

  String get(String key) => dotenv.env[key];
}
