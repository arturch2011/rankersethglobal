import 'package:flutter/material.dart';

class DropSelector extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onOptionSelected;

  const DropSelector({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  State<DropSelector> createState() => _DropSelectorState();
}

class _DropSelectorState extends State<DropSelector> {
  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    final selectedOption = widget.selectedOption;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Theme.of(context).colorScheme.tertiary,
      ),
      child: DropdownButton<String>(
        value: selectedOption,
        onChanged: (value) => widget.onOptionSelected(value!),
        items: options.map((String tipo) {
          return DropdownMenuItem<String>(
            value: tipo,
            child: Text(tipo),
          );
        }).toList(),
        borderRadius: BorderRadius.circular(16.0),
        dropdownColor: Theme.of(context).colorScheme.tertiary,
        isDense: true,
        enableFeedback: true,
        menuMaxHeight: 200,
        elevation: 4,
        underline: Container(),
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
