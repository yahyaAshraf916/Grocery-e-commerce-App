import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModel with ChangeNotifier {
  final String orderId, userId, productId, price, quantity, userName, imageUrl;
  final Timestamp orderDate;

  OrderModel(
      {required this.orderId,
      required this.userId,
      required this.productId,
      required this.price,
      required this.quantity,
      required this.userName,
      required this.imageUrl,
      required this.orderDate});
}
