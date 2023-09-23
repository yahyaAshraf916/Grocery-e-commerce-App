import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app_and_web_admin_panel/consts/firebase_consts.dart';
import 'package:grocery_app_and_web_admin_panel/models/order_model.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    User? user = authInstance.currentUser;

    if (user == null) {
      return;
    } else {
      await FirebaseFirestore.instance
          .collection("orders")
          .where("userId", isEqualTo: user.uid)
          .orderBy("orderDate", descending: false)
          .get()
          .then((QuerySnapshot orderSnapshot) {
        _orders = [];
        for (var element in orderSnapshot.docs) {
          _orders.insert(
              0,
              OrderModel(
                orderId: element.get("orderId"),
                userId: element.get("userId"),
                productId: element.get("productId"),
                price: element.get("price").toString(),
                quantity: element.get("quantity").toString(),
                userName: element.get("userName"),
                imageUrl: element.get("imageUrl"),
                orderDate: element.get("orderDate"),
              ));
        }
      });
    }

    notifyListeners();
  }
}
