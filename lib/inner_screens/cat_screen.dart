import 'package:flutter/material.dart';
import 'package:grocery_app_and_web_admin_panel/models/products_model.dart';
import 'package:grocery_app_and_web_admin_panel/providers/products_provider.dart';
import 'package:grocery_app_and_web_admin_panel/services/utils.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/back_widget.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/empt_product_widget.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/feed_items.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class CatScreen extends StatefulWidget {
  static const routeName = "/CatScreen";
  const CatScreen({super.key});

  @override
  State<CatScreen> createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProviders = Provider.of<ProductsProvider>(context);
    final productCategoryName =
        ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> productByCat =
        productsProviders.findByCategory(productCategoryName);
    final Utils utils = Utils(context);
    Size size = utils.getScreenSize;
    final color = Utils(context).color;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: "All Products",
          color: color,
          textSize: 20,
          isTitle: true,
        ),
      ),
      body: productByCat.isEmpty
          ? const EmptyProductWidget(
              text: "No products belongs to this category",
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: TextField(
                        focusNode: _searchTextFocusNode,
                        controller: _searchTextController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.greenAccent, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.greenAccent, width: 1),
                          ),
                          hintText: "What's in your mind ",
                          prefixIcon: const Icon(Icons.search),
                          suffix: IconButton(
                            onPressed: () {
                              _searchTextController.clear();
                              _searchTextFocusNode.unfocus();
                            },
                            icon: Icon(
                              Icons.close,
                              color: _searchTextFocusNode.hasFocus
                                  ? Colors.red
                                  : color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    childAspectRatio: size.width / (size.height * 0.59),
                    children: List.generate(productByCat.length, (index) {
                      return ChangeNotifierProvider.value(
                        value: productByCat[index],
                        child: FeedsWidget(),
                      );
                    }),
                  ),
                ],
              ),
            ),
    );
  }
}
