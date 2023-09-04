import 'package:flutter/material.dart';
import 'package:grocery_app_and_web_admin_panel/inner_screens/feeds_screen.dart';
import 'package:grocery_app_and_web_admin_panel/services/global_methods.dart';
import 'package:grocery_app_and_web_admin_panel/services/utils.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subTitle,
      required this.buttonText});
  final String imagePath, title, subTitle, buttonText;
  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    final size = Utils(context).getScreenSize;
    final themeState = Utils(context).getTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                imagePath,
                width: double.infinity,
                height: size.height * 0.4,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Whoops",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: title,
                color: Colors.cyan,
                textSize: 20,
                isTitle: true,
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: subTitle,
                color: Colors.cyan,
                textSize: 20,
                isTitle: true,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: color,
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: color,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: FeedsScreen.routeName);
                },
                child: TextWidget(
                  text: buttonText,
                  color:
                      themeState ? Colors.grey.shade300 : Colors.grey.shade800,
                  textSize: 20,
                  isTitle: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
