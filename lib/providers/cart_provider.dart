import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app_and_web_admin_panel/consts/firebase_consts.dart';
import 'package:grocery_app_and_web_admin_panel/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  // void addProductToCart({required String productId, required int quantity}) {
  //   _cartItems.putIfAbsent(
  //     productId,
  //     () => CartModel(
  //       id: DateTime.now().toString(),
  //       productId: productId,
  //       quantity: quantity,
  //     ),
  //   );
  //   notifyListeners();
  // }

  final userCollection = FirebaseFirestore.instance.collection("users");
  Future<void> fetchCart() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
    final leng = userDoc.get("userCart").length;
    for (int i = 0; i < leng; i++) {
      _cartItems.putIfAbsent(
          userDoc.get("userCart")[i]["productId"],
          () => CartModel(
                id: userDoc.get("userCart")[i]["cartId"],
                productId: userDoc.get("userCart")[i]["productId"],
                quantity: userDoc.get("userCart")[i]["quantity"],
              ));
    }
    notifyListeners();
  }

  void reduceQuantityByOne(String productId) {
    _cartItems.update(
      productId,
      (value) => CartModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity - 1,
      ),
    );
    notifyListeners();
  }

  void increaseQuantityByOne(String productId) {
    _cartItems.update(
      productId,
      (value) => CartModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity + 1,
      ),
    );
    notifyListeners();
  }

  Future<void> removeOneItem({
    required String productId,
    required String cartId,
    required int quantity,
  }) async {
    _cartItems.remove(productId);
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      "userCart": FieldValue.arrayRemove([
        {
          "productId": productId,
          "cartId": cartId,
          "quantity": quantity,
        }
      ])
    });
    await fetchCart();
    notifyListeners();
  }

  Future<void> clearOnlineCart() async {
    final User? user = authInstance.currentUser;
    userCollection.doc(user!.uid).update({"userCart": []});
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
