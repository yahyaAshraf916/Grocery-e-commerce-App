import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app_and_web_admin_panel/inner_screens/product_details.dart';
import 'package:grocery_app_and_web_admin_panel/models/wishList_model.dart';
import 'package:grocery_app_and_web_admin_panel/providers/products_provider.dart';
import 'package:grocery_app_and_web_admin_panel/providers/wishlist_provider.dart';
import 'package:grocery_app_and_web_admin_panel/services/utils.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/heart_btn.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final getCurrProduct = productProvider.findProdById(wishlistModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
        bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    final color = Utils(context).color;
    final size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: color,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin:const EdgeInsets.only(left: 8),
                
                  height: size.width * 0.25,
                  child: FancyShimmerImage(
                    imageUrl:
                        getCurrProduct.imageUrl,
                    boxFit: BoxFit.fill,
                   
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Flexible(
                       child: Row(
                        children: [
                          Icon(IconlyLight.bag2,color: color,),
                          const SizedBox(
                            width: 10,
                          ),
                      HeartBTN(productId: getCurrProduct.id,isInWishlist: isInWishlist ,),
                        ],
                                     ),
                     ),
                    const SizedBox(
                      height: 5,
                    ),
                    Flexible(child: TextWidget(text: getCurrProduct.title, color: color, textSize: 18,maxLines: 2,isTitle:true ,)),
                    const SizedBox(
                      height: 5,
                    ),
                    Flexible(child: TextWidget(text: "\$${usedPrice.toStringAsFixed(2)}", color: color, textSize: 18,maxLines: 1,isTitle:true ,)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
