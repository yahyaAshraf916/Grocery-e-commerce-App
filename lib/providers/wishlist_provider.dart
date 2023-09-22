import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app_and_web_admin_panel/consts/firebase_consts.dart';
import 'package:grocery_app_and_web_admin_panel/models/wishList_model.dart';

class WishlistProvider with ChangeNotifier {
  Map<String, WishlistModel> _wishlistItems = {};
  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

  // void addRemoveProductToWishlistList({required String productId}) {
  //   if (getWishlistItems.containsKey(productId)) {
  //     removeOneItem(productId);
  //   } else {
  //     _wishlistItems.putIfAbsent(
  //         productId,
  //         () => WishlistModel(
  //             id: DateTime.now().toString(), productId: productId));
  //   }
  //   notifyListeners();
  // }

   final userCollection = FirebaseFirestore.instance.collection("users");
  Future<void> fetchWishlist() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
    final leng = userDoc.get("userWish").length;
    for (int i = 0; i < leng; i++) {
      _wishlistItems.putIfAbsent(
          userDoc.get("userWish")[i]["productId"],
          () => WishlistModel(
                id: userDoc.get("userWish")[i]["wishlistId"],
                productId: userDoc.get("userWish")[i]["productId"],
               
              ));
    }
    notifyListeners();
  }

    Future<void> removeOneItem({
    required String productId,
    required String wishlistId,
   
  }) async {
     final User? user = authInstance.currentUser;
    _wishlistItems.remove(productId);
    await userCollection.doc(user!.uid).update({
      "userWish": FieldValue.arrayRemove([
        {
          "productId": productId,
          "wishlistId": wishlistId,
         
        }
      ])
    });
    await fetchWishlist();
    notifyListeners();
  }

  Future<void> clearOnlineWishlist() async {
    final User? user = authInstance.currentUser;
    userCollection.doc(user!.uid).update({"userWish": []});
    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
