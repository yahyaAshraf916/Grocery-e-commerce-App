import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app_and_web_admin_panel/consts/firebase_consts.dart';
import 'package:grocery_app_and_web_admin_panel/services/global_methods.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/fetch_screen.dart';
import 'package:grocery_app_and_web_admin_panel/widgets/text_widget.dart';

class GoogleButton extends StatelessWidget {
  GoogleButton({super.key});
  bool isLoading = false;
  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await authInstance.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );
          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(authResult.user!.uid)
                .set({
              "id": authResult.user!.uid,
              "name": authResult.user!.displayName,
              "email": authResult.user!.email,
              "shipping-address": "",
              "userWish": [],
              "userCart": [],
              "createdAt": Timestamp.now(),
            });
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const FetchScreen(),
            ),
          );
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              subtitle: error.message.toString(), context: context);
        } catch (error) {
          GlobalMethods.errorDialog(
              subtitle: error.toString(), context: context);
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Image.asset(
                "assets/images/google.png",
                width: 40,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            TextWidget(
                text: "Sign in with google", color: Colors.white, textSize: 18),
          ],
        ),
      ),
    );
  }
}
