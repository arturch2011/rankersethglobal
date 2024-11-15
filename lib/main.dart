import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/my_app.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/providers/user_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => BlockchainProvider()),
  ], child: const MyApp()));
}
