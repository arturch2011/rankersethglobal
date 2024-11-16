import 'package:flutter/material.dart';
import 'package:rankersethglobal/widgets/auth_check.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rankers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'MPLUSCodeLatin',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 189, 149, 20),
          primary: const Color.fromARGB(255, 189, 149, 20),
          primaryContainer: const Color.fromARGB(255, 73, 69, 60),
          tertiary: const Color.fromARGB(255, 48, 45, 41),
          secondary: const Color.fromARGB(255, 189, 116, 20),
          onSurface: const Color.fromARGB(255, 255, 255, 255),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 241, 221, 160),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          prefixIconColor: Color.fromRGBO(119, 119, 119, 1),
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          bodySmall: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          titleLarge: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 30, color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 241, 221, 160),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      home: const AuthCheck(),
    );
  }
}
