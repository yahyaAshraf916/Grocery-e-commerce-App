import 'package:flutter/material.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/order/order_widget.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/back_widget.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/empty_screen.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    bool _isEmpty = true;
    if (_isEmpty == true) {
      return const EmptyScreen(
        imagePath: 'assets/images/cart.png',
        title: 'Your didn\'t place any order yet!',
        subTitle: 'Add something and make me happy :)',
        buttonText: 'Shop now',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0,
          centerTitle: false,
          title: TextWidget(
            text: 'Your orders (2)',
            color: color,
            textSize: 24.0,
            isTitle: true,
          ),
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        body: ListView.separated(
          itemCount: 10,
          itemBuilder: (ctx, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: OrderWidget(),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: color,
              thickness: 1,
            );
          },
        ),
      );
    }
  }
}
