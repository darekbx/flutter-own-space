import 'dart:async';
import 'package:ownspace/allegro_observer/model/filter.dart';

class FirebaseProvider {

  var _COLLECTION_KEY = "filters";

  Future addAll(List<Filter> filters) async {
   /* var collection = await Firestore.instance.collection(_COLLECTION_KEY);
    for (var filter in filters) {
      await collection.add(filter.toMap());
    }*/
  }

  Future removeAll() async {
    /*var documentsFuture = await Firestore.instance.collection(_COLLECTION_KEY)
        .getDocuments();
    for (var document in documentsFuture.documents) {
      document.reference.delete();
    }*/
  }

  Future<int> countFilters() async {
    /*var documentsFuture = await Firestore.instance.collection(_COLLECTION_KEY)
        .getDocuments();
    return documentsFuture.documents.length;*/
    return 0;
  }

  Future<List<Filter>> fetchFilters() async {
    /*var documentsFuture = await Firestore.instance.collection(_COLLECTION_KEY)
        .getDocuments();
    return documentsFuture.documents
        .map((document) => Filter.fromMap(document.data)).toList();*/
    return List();
  }
}