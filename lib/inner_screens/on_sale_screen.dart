import 'package:flutter/material.dart';
import 'package:grocery_app_and_web_admin_panel/models/products_model.dart';
import 'package:grocery_app_and_web_admin_panel/providers/products_provider.dart';
import 'package:grocery_app_and_web_admin_panel/services/utils.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/back_widget.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/empt_product_widget.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/on_sale_widget.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class OnSaleScreen extends StatelessWidget {
  const OnSaleScreen({super.key});
  static const routeName = "/OnSaleScreen";
  @override
  Widget build(BuildContext context) {
    final productsProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> productOnSale = productsProviders.getOnSaleProducts;
    final Utils utils = Utils(context);
    Size size = utils.getScreenSize;
    final color = Utils(context).color;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: "Products on sale",
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: productOnSale.isEmpty
          // ignore: dead_code
          ?const  EmptyProductWidget(text: "No products on sale yet !,\nstay tuned ",)
          : GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 2,
              childAspectRatio: size.width / (size.height * 0.45),
              children: List.generate(productOnSale.length, (index) {
                return ChangeNotifierProvider.value(
                  value: productOnSale[index],
                  child:const OnSaleWidget());
              }),
            ),
    );
  }
}
