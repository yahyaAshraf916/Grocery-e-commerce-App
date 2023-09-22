import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_app_and_web_admin_panel/providers/wishlist_provider.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/wishlist/wishlist_widget.dart';
import 'package:grocery_app_and_web_admin_panel/services/global_methods.dart';
import 'package:grocery_app_and_web_admin_panel/services/utils.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/back_widget.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/empty_screen.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  static const routeName = "/WishlistScreen";
  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList =
        wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    if (wishlistItemsList.isEmpty) {
      return const EmptyScreen(
        imagePath: 'assets/images/wishlist.png',
        title: 'Your wishlist is empty',
        subTitle: 'Explore more and shortlist some items',
        buttonText: 'Add a wish',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          centerTitle: true,
          title: TextWidget(
            text: "Wishlist(${wishlistItemsList.length})",
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
                  title: "Empty your wishlist ",
                  subTitle: "Are you sure?",
                  context: context,
                  fct: () async {
                    await wishlistProvider.clearOnlineWishlist();
                    wishlistProvider.clearLocalWishlist();
                  },
                );
              },
            ),
          ],
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: MasonryGridView.count(
          itemCount: wishlistItemsList.length,
          crossAxisCount: 2,
          // mainAxisSpacing: 16,
          // crossAxisSpacing: 4,
          itemBuilder: (context, index) {
            return ChangeNotifierProvider.value(
                value: wishlistItemsList[index], child: const WishlistWidget());
          },
        ),
      );
    }
  }
}
