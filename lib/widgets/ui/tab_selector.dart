import 'package:flutter/material.dart';

class TabSelector extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onOptionSelected;

  const TabSelector({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  State<TabSelector> createState() => _TabSelectorState();
}

class _TabSelectorState extends State<TabSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        border: Border.all(
          color: Colors.black, // Cor da borda
          width: 2, // Largura da borda
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.options.map((option) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextButton(
                onPressed: () => widget.onOptionSelected(option),
                style: TextButton.styleFrom(
                  side: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  backgroundColor: widget.selectedOption == option
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  option,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
