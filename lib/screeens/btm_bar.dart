import 'package:flutter/material.dart';
import 'package:grocery_app_and_web_admin_panel/providers/dark_theme_provider.dart';
import 'package:grocery_app_and_web_admin_panel/providers/cart_provider.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/cart/cart_screen.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/categories.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/home_screen.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/user.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> _pages = [
    {"page": const HomeScreen(), "title": "Home Screen"},
    {"page": CategoriesScreen(), "title": "Category Screen"},
    {"page": const CartScreen(), "title": "Cart Screen"},
    {"page": const UserScreen(), "title": "User Screen"},
  ];
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    
    bool isDark = themeState.getDarkTheme;
    return Scaffold(
      // appBar: AppBar(title: Text(
      //     _pages[_selectedIndex]["title"],
      //   ),),
      body: _pages[_selectedIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: isDark ? Colors.white10 : Colors.black12,
          selectedItemColor: isDark ? Colors.lightBlue : Colors.black87,
          currentIndex: _selectedIndex,
          onTap: _selectedPage,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                    _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(_selectedIndex == 1
                    ? IconlyBold.category
                    : IconlyLight.category),
                label: "Category"),
            BottomNavigationBarItem(
                icon: Builder(
                  builder: (context) {
                    return Consumer<CartProvider>(
                      builder: (_,myCart,ch) {
                        return badges.Badge(
                          badgeAnimation: const badges.BadgeAnimation.slide(),
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.circle,
                            badgeColor: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          position: badges.BadgePosition.topEnd(top: -7, end: -7),
                          badgeContent: FittedBox(
                              child: TextWidget(
                                  text: myCart.getCartItems.length.toString(), color: Colors.white, textSize: 12)),
                          child: Icon(
                              _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),
                        );
                      }
                    );
                  }
                ),
                label: "Cart"),
            BottomNavigationBarItem(
                icon: Icon(
                    _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
                label: "User"),
          ]),
    );
  }
}
