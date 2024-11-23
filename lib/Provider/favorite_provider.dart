import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteList = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get favoriteList => _favoriteList;
  FavoriteProvider() {
    getFavoriteList();
  }

  void toggleFavorite(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteList.contains(productId)) {
      _favoriteList.remove(productId);
      await _removeFavorite(productId);
    } else {
      _favoriteList.add(productId);
      await _addFavorite(productId);
    }
    notifyListeners();
  }

  bool isExist(DocumentSnapshot product) {
    return _favoriteList.contains(product.id);
  }

  Future<void> _addFavorite(String productId) async {
    try {
      await _firestore.collection('userFavorit').doc(productId).set({
        'isFavorite': true,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _removeFavorite(String productId) async {
    try {
      await _firestore.collection('userFavorit').doc(productId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getFavoriteList() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('userFavorit').get();
      _favoriteList = snapshot.docs.map((doc) => doc.id).toList();
      ;
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
