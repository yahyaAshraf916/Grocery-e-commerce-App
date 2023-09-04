import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_and_web_admin_panel/inner_screens/product_details.dart';
import 'package:grocery_app_and_web_admin_panel/services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;

    return ListTile(
      subtitle: const Text('Paid: \$12.8'),
      onTap: () {
        GlobalMethods.navigateTo(
            ctx: context, routeName: ProductDetails.routeName);
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl:
            "https://www.pngkit.com/png/detail/63-636758_apricot-png-image-apricot-png.png",
        boxFit: BoxFit.fill,
      ),
      title: TextWidget(text: 'Title x12 ', color: color, textSize: 18),
      trailing: TextWidget(text: "12/05/2023", color: color, textSize: 18),
    );
  }
}
