import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app_and_web_admin_panel/consts/firebase_consts.dart';
import 'package:grocery_app_and_web_admin_panel/providers/orders_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:grocery_app_and_web_admin_panel/providers/cart_provider.dart';
import 'package:grocery_app_and_web_admin_panel/providers/products_provider.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/cart/cart_widget.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/empty_screen.dart';
import 'package:grocery_app_and_web_admin_panel/services/global_methods.dart';
import 'package:grocery_app_and_web_admin_panel/services/utils.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
        
    if (cartItemsList.isEmpty) {
      return const EmptyScreen(
        imagePath: 'assets/images/cart.png',
        title: 'Your cart is empty!',
        subTitle: 'Add something and make me happy :)',
        buttonText: 'Shop now',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: TextWidget(
            text: "Cart (${cartItemsList.length})",
            color: color,
            textSize: 22,
            isTitle: true,
          ),
          actions: [
            IconButton(
              icon: const Icon(IconlyBroken.delete),
              color: color,
              onPressed: () {
                GlobalMethods.warningDialog(
                  title: "Empty your cart ",
                  subTitle: "Are you sure?",
                  context: context,
                  fct: () async {
                    cartProvider.clearLocalCart();
                    await cartProvider.clearOnlineCart();
                  },
                );
              },
            ),
          ],
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          children: [
            _checkout(ctx: context),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return ChangeNotifierProvider.value(
                    value: cartItemsList[index],
                    child: CartWidget(q: cartItemsList[index].quantity),
                  );
                },
                itemCount: cartItemsList.length,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _checkout({required BuildContext ctx}) {
    final color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
     final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total = 0.0;
    cartProvider.getCartItems.forEach(
      (key, value) {
        final getCurrentProduct = productProvider.findProdById(value.productId);
        total += (getCurrentProduct.isOnSale
                ? getCurrentProduct.salePrice
                : getCurrentProduct.price) *
            value.quantity;
      },
    );
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.green,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final productProvider =
                      Provider.of<ProductsProvider>(ctx, listen: false);

                  User? user = authInstance.currentUser;
                 
                 
                  cartProvider.getCartItems.forEach((key, value) async {
                    final getCurrProduct =
                        productProvider.findProdById(value.productId);
                    try {
                       final orderId = const Uuid().v4();
                      await FirebaseFirestore.instance
                          .collection("orders")
                          .doc(orderId)
                          .set({
                        "orderId": orderId,
                        "userId": user!.uid,
                        "productId": value.productId,
                        "quantity": value.quantity,
                        "price": (getCurrProduct.isOnSale
                                ? getCurrProduct.salePrice
                                : getCurrProduct.price) *
                            value.quantity,
                        "totalPrice": total,
                        "imageUrl": getCurrProduct.imageUrl,
                        "userName": user.displayName,
                        "orderDate": Timestamp.now(),
                      });
                      cartProvider.clearLocalCart();
                      await cartProvider.clearOnlineCart();
                      ordersProvider.fetchOrders();
                      await Fluttertoast.showToast(
                        msg: "Your Order has been placed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          subtitle: error.toString(), context: ctx);
                    } finally {}
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                    text: "Order now",
                    color: Colors.white,
                    textSize: 20,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              child: TextWidget(
                text: "Total: \$${total.toStringAsFixed(2)}",
                color: color,
                textSize: 18,
                isTitle: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
