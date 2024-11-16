import 'package:flutter/material.dart';
import 'package:rankersethglobal/widgets/ui/created_card.dart';

class MyCreatedList extends StatelessWidget {
  final List<dynamic> myGoals;
  const MyCreatedList({super.key, required this.myGoals});

  @override
  Widget build(BuildContext context) {
    if (myGoals.isEmpty) {
      return const Center(
        child: Text('No project found', style: TextStyle(color: Colors.black)),
      );
    } else {
      return SizedBox(
        height: 450,
        child: ListView.builder(
          itemCount: myGoals.length,
          itemBuilder: (context, index) {
            return Column(children: [
              CreatedCard(
                index: myGoals[index][0].toInt(),
              ),
            ]);
          },
        ),
      );
    }
  }
}
