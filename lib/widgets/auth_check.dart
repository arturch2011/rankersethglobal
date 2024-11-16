import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/home.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/providers/user_provider.dart';
import 'package:rankersethglobal/screens/login_screen.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  Future<void> getPrivateKey() async {
    final privKey = await context.read<UserProvider>().userInfos!['privKey'];
    BlockchainProvider block =
        Provider.of<BlockchainProvider>(context, listen: false);
    await block.getPrivKey(privKey);
    await block.initialSetup();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider auth = Provider.of<UserProvider>(context);
    if (auth.isLoading) {
      return loading();
    } else if (auth.userInfos == null) {
      return const LoginScreen();
    } else {
      return FutureBuilder(
          future: getPrivateKey(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loading();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const MyHome();
            }
          });
    }
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
