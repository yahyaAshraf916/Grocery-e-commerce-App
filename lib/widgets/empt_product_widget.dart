import 'package:flutter/material.dart';
import 'package:grocery_app_and_web_admin_panel/services/utils.dart';

class EmptyProductWidget extends StatelessWidget {
  const EmptyProductWidget({super.key, required this.text});
final  String text;
  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image.asset("assets/images/box.png"),
          ),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
