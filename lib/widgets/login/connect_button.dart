import 'package:flutter/material.dart';

class ConnectButton extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback onPressed;
  const ConnectButton(
      {super.key,
      required this.text,
      required this.image,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5), // Sombra
            //     spreadRadius: 0.5,
            //     blurRadius: 5,
            //     // Ajuste a sombra vertical aqui
            //   ),
            // ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
