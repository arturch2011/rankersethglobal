import 'package:flutter/material.dart';

class OptionSelector extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onOptionSelected;

  const OptionSelector({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  State<OptionSelector> createState() => _OptionSelectorState();
}

class _OptionSelectorState extends State<OptionSelector> {
  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    final selectedOption = widget.selectedOption;
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => widget.onOptionSelected(options[index]),
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selectedOption == options[index]
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                  child: Text(
                options[index],
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
            ),
          );
        },
      ),
    );
  }
}
