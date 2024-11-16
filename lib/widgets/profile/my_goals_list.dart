import 'package:flutter/material.dart';
import 'package:rankersethglobal/widgets/ui/main_card.dart';

class MyGoalsList extends StatelessWidget {
  final List<dynamic> myGoals;
  const MyGoalsList({super.key, required this.myGoals});

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
              MainCard(
                index: myGoals[index][0].toInt(),
              ),
            ]);
          },
        ),
      );
    }
  }
}
