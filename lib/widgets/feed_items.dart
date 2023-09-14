import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app_and_web_admin_panel/consts/firebase_consts.dart';
import 'package:grocery_app_and_web_admin_panel/inner_screens/product_details.dart';
import 'package:grocery_app_and_web_admin_panel/models/products_model.dart';
import 'package:grocery_app_and_web_admin_panel/providers/cart_provider.dart';
import 'package:grocery_app_and_web_admin_panel/providers/wishlist_provider.dart';
import 'package:grocery_app_and_web_admin_panel/services/global_methods.dart';
import 'package:grocery_app_and_web_admin_panel/services/utils.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/heart_btn.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/price_widget.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class FeedsWidget extends StatefulWidget {
  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = "1";
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            //   GlobalMethods.navigateTo(

            //       ctx: context, routeName: ProductDetails.routeName);
          },
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                boxFit: BoxFit.fill,
                height: size.width * 0.21,
                width: size.width * 0.2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextWidget(
                        text: productModel.title,
                        color: color,
                        textSize: 18,
                        maxLines: 1,
                        isTitle: true,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: HeartBTN(
                        productId: productModel.id,
                        isInWishlist: isInWishlist,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: PriceWidget(
                        isOnSale: productModel.isOnSale,
                        price: productModel.price,
                        salePrice: productModel.salePrice,
                        textPrice: _quantityTextController.text,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 6,
                            child: FittedBox(
                                child: TextWidget(
                              text: productModel.isPiece ? "Piece" : "kg",
                              color: color,
                              textSize: 20,
                              isTitle: true,
                            )),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            flex: 6,
                            child: TextFormField(
                              controller: _quantityTextController,
                              key: const ValueKey('10 \$'),
                              style: TextStyle(
                                color: color,
                                fontSize: 18,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _quantityTextController.text = '1';
                                  } else {
                                    // total = usedPrice *
                                    //     int.parse(_quantityTextController.text);
                                  }
                                });
                              },
                              onSaved: (value) {},
                              enabled: true,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              cursorColor: Colors.green,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp("[0-9.,]"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: isInCart
                      ? null
                      : ()async {
                        final User? user = authInstance.currentUser;
                          if (user == null) {
                            GlobalMethods.errorDialog(
                                subtitle: "No user found, Please login first",
                                context: context);
                            return;
                          }
                         await  GlobalMethods.addToCart(
                              productId: productModel.id,
                              quantity:  int.parse(_quantityTextController.text),
                              context: context);
                               await cartProvider.fetchCart();
                          // cartProvider.addProductToCart(
                          //     productId: productModel.id,
                          //     quantity:
                          //         int.parse(_quantityTextController.text));
                        },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).cardColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  child: TextWidget(
                    text: isInCart ? "In cart" : "Add to cart",
                    color: color,
                    textSize: 20,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
