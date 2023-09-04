import 'package:flutter/material.dart';

class ViewedproModel with ChangeNotifier {
  final String id, productId;

  ViewedproModel({
    required this.id,
    required this.productId,
  });
}
