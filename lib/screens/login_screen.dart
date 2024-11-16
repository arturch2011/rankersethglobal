import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/user_provider.dart';
import 'package:rankersethglobal/widgets/login/connect_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/login_image.jpg"), // Substitua 'imagem.jpg' pela imagem desejada.
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Log In",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      ConnectButton(
                          text: 'Google',
                          image: 'assets/images/google.png',
                          onPressed: () {
                            context.read<UserProvider>().loginGoogle();
                          }),
                      const SizedBox(width: 12),
                      ConnectButton(
                          text: 'Facebook',
                          image: 'assets/images/facebook.png',
                          onPressed: () {
                            context.read<UserProvider>().loginFacebook();
                          }),
                      const SizedBox(width: 12),
                      ConnectButton(
                          text: 'X',
                          image: 'assets/images/twitter.png',
                          onPressed: () {
                            context.read<UserProvider>().loginTwitter();
                          }),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
