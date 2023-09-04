import 'package:flutter/cupertino.dart';
import 'package:grocery_app_and_web_admin_panel/models/viewed_model.dart';


class ViewedProdProvider with ChangeNotifier {
  final Map<String, ViewedproModel> _viewedProdListItems = {};
    Map<String, ViewedproModel> get getViewedListItems {
    return _viewedProdListItems;
  }

  void addProductToHistory({required String productId}) {
  
      _viewedProdListItems.putIfAbsent(
          productId,
          () => ViewedproModel(
              id: DateTime.now().toString(), productId: productId));
    
    notifyListeners();
  }

  
}
