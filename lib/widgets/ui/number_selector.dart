import 'package:flutter/material.dart';

class NumberSelector extends StatefulWidget {
  final int value;
  final Function(bool) onValueSelected;
  final VoidCallback? onTap;

  const NumberSelector({
    super.key,
    required this.value,
    required this.onValueSelected,
    this.onTap,
  });

  @override
  State<NumberSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.remove,
                color: Color.fromARGB(255, 129, 129, 129)),
            onPressed: () => widget.onValueSelected(false),
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Raio dos cantos
                ),
              ),
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.tertiary,
              ),
            )),
        const SizedBox(width: 10),
        GestureDetector(
            onTap: widget.onTap,
            child:
                Text(value.toString(), style: TextStyle(color: Colors.black))),
        const SizedBox(width: 10),
        IconButton(
            icon: const Icon(Icons.add,
                color: Color.fromARGB(255, 129, 129, 129)),
            onPressed: () => widget.onValueSelected(true),
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Raio dos cantos
                ),
              ),
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.tertiary,
              ),
            )),
      ],
    );
  }
}
