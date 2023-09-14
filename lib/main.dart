import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app_and_web_admin_panel/consts/theme_data.dart';
import 'package:grocery_app_and_web_admin_panel/inner_screens/cat_screen.dart';
import 'package:grocery_app_and_web_admin_panel/inner_screens/feeds_screen.dart';
import 'package:grocery_app_and_web_admin_panel/inner_screens/on_sale_screen.dart';
import 'package:grocery_app_and_web_admin_panel/inner_screens/product_details.dart';
import 'package:grocery_app_and_web_admin_panel/provider/dark_theme_provider.dart';
import 'package:grocery_app_and_web_admin_panel/providers/cart_provider.dart';
import 'package:grocery_app_and_web_admin_panel/providers/products_provider.dart';
import 'package:grocery_app_and_web_admin_panel/providers/viewed_provider.dart';
import 'package:grocery_app_and_web_admin_panel/providers/wishlist_provider.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/auth/forget_pass.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/auth/login.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/auth/register.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/order/order_screen.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/viewed_recentlt/viewed_recently.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/wishlist/wishlist_screen.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/fetch_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> firebaseInitilization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebaseInitilization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        else if(snapshot.hasError){
           return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child:Text("An error occured"),
              ),
            ),
          );
        }
       
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              return themeChangeProvider;
            }),
            ChangeNotifierProvider(create: (_) {
              return ProductsProvider();
            }),
            ChangeNotifierProvider(create: (_) {
              return CartProvider();
            }),
            ChangeNotifierProvider(create: (_) {
              return WishlistProvider();
            }),
            ChangeNotifierProvider(create: (_) {
              return ViewedProdProvider();
            }),
          ],
          child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
            return MaterialApp(
              title: "flutter",
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(themeProvider.getDarkTheme, context),
              home: const FetchScreen(),
              routes: {
                OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                ProductDetails.routeName: (ctx) => const ProductDetails(),
                WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                ViewedRecentlyScreen.routeName: (ctx) =>
                    const ViewedRecentlyScreen(),
                LoginScreen.routeName: (ctx) => const LoginScreen(),
                RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                ForgetPasswordScreen.routeName: (ctx) =>
                    const ForgetPasswordScreen(),
                CatScreen.routeName: (ctx) => const CatScreen(),
              },
            );
          }),
        );
      },
    );
  }
}
