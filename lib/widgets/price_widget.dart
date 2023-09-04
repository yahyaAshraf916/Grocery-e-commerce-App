import 'package:flutter/material.dart';
import 'package:grocery_app_and_web_admin_panel/services/utils.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {super.key,
      required this.textPrice,
      required this.price,
      required this.salePrice,
      required this.isOnSale});
  final double price, salePrice;
  final String textPrice;

  final bool isOnSale;
  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    double userPrice = isOnSale ? salePrice : price;
    return FittedBox(
      child: Row(
        children: [
          TextWidget(text: "\$${(userPrice*int.parse(textPrice)).toStringAsFixed(2)}", color: Colors.green, textSize: 18),
          const SizedBox(
            width: 5,
          ),
          Visibility(
            visible: isOnSale?true:false,
            child: Text(
              "\$${(price * int.parse(textPrice)).toStringAsFixed(2)}",
              style: TextStyle(
                color: color,
                fontSize: 15,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          )
        ],
      ),
    );
  }
}
