import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:ownspace/allegro_observer/allegro/model/category_wrapper.dart';
import 'allegro_base.dart';
import 'package:ownspace/allegro_observer/repository/local/local_storage.dart';

class AllegroCategories {
  final String CATEGORIES_ENDPOINT = "/sale/categories?parent.id=";

  var _localStorage = LocalStorage();
  Future<CategoryWrapper> getMainCategories() async => getCategories(CATEGORY_PARENT_ID);

  Future<CategoryWrapper> getCategories(String parentId) async {
    var token = await _localStorage.getAuthToken();
    var address = API_URL + CATEGORIES_ENDPOINT + parentId;
    var headers =  { 
      "Content-Type": "application/vnd.allegro.public.v1+json",
      "Authorization": "Bearer $token" };
    var response = await http.get(address, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      var jsonMap = json.decode(response.body);
      return CategoryWrapper.fromJson(jsonMap);
    } else {
      return null;
    }
  }
}