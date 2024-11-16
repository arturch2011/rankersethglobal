import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  final DateTime initDate;
  final DateTime endDate;
  final int duration;
  final bool isEnd;
  final Function(bool, DateTime?) onOptionSelected;

  const DateSelector({
    super.key,
    required this.initDate,
    required this.endDate,
    required this.duration,
    required this.isEnd,
    required this.onOptionSelected,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  @override
  Widget build(BuildContext context) {
    final initDate = widget.initDate;
    final endDate = widget.endDate;
    final isEnd = widget.isEnd;
    final duration = widget.duration;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isEnd ? 'To:' : 'From:', style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate:
                  isEnd ? initDate.add(Duration(days: duration)) : initDate,
              firstDate:
                  isEnd ? initDate.add(Duration(days: duration)) : initDate,
              lastDate: DateTime(2101),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.dark(),
                  child: child!,
                );
              },
            );
            widget.onOptionSelected(isEnd, pickedDate);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Theme.of(context).colorScheme.tertiary,
            ),
            child: Text(isEnd
                ? "${endDate.toLocal()}".split(' ')[0]
                : "${initDate.toLocal()}".split(' ')[0]),
          ),
        ),
      ],
    );
  }
}
