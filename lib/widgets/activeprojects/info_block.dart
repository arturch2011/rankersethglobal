import 'package:flutter/material.dart';

class InfoBlock extends StatelessWidget {
  final String info;
  const InfoBlock({super.key, required this.info});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5), // Sombra
          //     spreadRadius: 1,
          //     blurRadius: 5,
          //     // Ajuste a sombra vertical aqui
          //   ),
          // ],
        ),
        child: Center(
          child: Text(
            info,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
