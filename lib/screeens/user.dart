import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app_and_web_admin_panel/consts/firebase_consts.dart';
import 'package:grocery_app_and_web_admin_panel/provider/dark_theme_provider.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/auth/forget_pass.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/auth/login.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/loading_manager.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/order/order_screen.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/viewed_recentlt/viewed_recently.dart';
import 'package:grocery_app_and_web_admin_panel/screeens/wishlist/wishlist_screen.dart';
import 'package:grocery_app_and_web_admin_panel/services/global_methods.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController = TextEditingController();
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  String? email;
  String? name;
  String? address;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    try {
      String uId = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uId).get();
      email = userDoc.get("email");
      name = userDoc.get("name");
      address = userDoc.get("shipping-address");
      _addressTextController.text = userDoc.get("shipping-address");
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: error.toString(), context: context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Hi,  ",
                      style: const TextStyle(
                        fontSize: 27,
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: name ?? "user",
                            style: TextStyle(
                              fontSize: 25,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("my name is pressed");
                              }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    //isTitle: true,
                    text: email ?? "email",
                    color: color,
                    textSize: 18,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _listTiles(
                    title: "Address",
                    subTitle: address ?? "address",
                    icon: IconlyLight.profile,
                    onPressed: () async {
                      await _showAddressDialog();
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: "Order",
                    icon: IconlyLight.bag,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: OrdersScreen.routeName);
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: "Wishlist",
                    icon: IconlyLight.heart,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: WishlistScreen.routeName);
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: "Viewed",
                    icon: IconlyLight.show,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context,
                          routeName: ViewedRecentlyScreen.routeName);
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: "Forget password",
                    icon: IconlyLight.unlock,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    color: color,
                  ),
                  SwitchListTile(
                    title: TextWidget(
                      text:
                          themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                      color: color,
                      textSize: 18,
                    ),
                    secondary: Icon(
                      themeState.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        themeState.setDarkTheme = value;
                      });
                    },
                    value: themeState.getDarkTheme,
                  ),
                  _listTiles(
                    title: user == null ? "Login" : "Logout",
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    onPressed: () {
                      if (user == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                        return;
                      }
                      GlobalMethods.warningDialog(
                        title: "Sign out ",
                        subTitle: "Do you want to sign out?",
                        context: context,
                        fct: () async {
                          await authInstance.signOut();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      );
                    },
                    color: color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update"),
          content: TextField(
            controller: _addressTextController,
            onChanged: (value) {
              _addressTextController.text;
            },
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: "Your Address",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                try {
                  final uId = user!.uid;
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(uId)
                      .update(
                          {"shipping-address": _addressTextController.text});
                  setState(() {
                    address = _addressTextController.text;
                  });
                  Navigator.pop(context);
                } catch (error) {
                  GlobalMethods.errorDialog(
                      subtitle: error.toString(), context: context);
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Widget _listTiles(
          {required String title,
          String? subTitle,
          required IconData icon,
          required Function onPressed,
          required Color color}) =>
      ListTile(
        title: TextWidget(
          //isTitle: true,

          text: title,
          color: color,
          textSize: 22,
        ),
        subtitle: TextWidget(
          text: subTitle ?? "",
          color: color,
          textSize: 18,
        ),
        leading: Icon(icon),
        trailing: const Icon(IconlyLight.arrowRight2),
        onTap: () {
          onPressed();
        },
      );
}
