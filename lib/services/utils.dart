import 'package:flutter/material.dart';
import 'package:grocery_app_and_web_admin_panel/providers/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class Utils {
  BuildContext context;
  Utils(this.context);
  bool get getTheme => Provider.of<DarkThemeProvider>(context).getDarkTheme;
  Color get color => getTheme ? Colors.white : Colors.black;
  Size get getScreenSize => MediaQuery.of(context).size;
}
