import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/providers/user_provider.dart';
import 'package:rankersethglobal/screens/menu_screen.dart';
import 'package:rankersethglobal/widgets/ui/carousel.dart';
import 'package:rankersethglobal/widgets/ui/main_card.dart';
import 'package:rankersethglobal/widgets/ui/profile_avatar.dart';
import 'package:rankersethglobal/widgets/ui/project_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    UserProvider auth = Provider.of<UserProvider>(context);
    List<dynamic> myGoals = block.myEnteredGoals;
    List<dynamic> publicGoals = block.publicGoals;
    String name = "User";
    int goalsLength = -1;
    int goalsLength2 = -1;
    int lastGoalIndex = -1;

    try {
      final names = auth.userInfos!['userInfo']["name"].split(" ");
      name = names[0];
    } catch (e) {
      name = "user";
    }

    if (publicGoals.isNotEmpty) {
      goalsLength = publicGoals[publicGoals.length - 1][0].toInt();
      if (publicGoals.length > 1) {
        goalsLength2 = publicGoals[publicGoals.length - 2][0].toInt();
      }
    }

    if (myGoals.isNotEmpty) {
      lastGoalIndex = myGoals[myGoals.length - 1].toInt();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Row(
              children: [
                const BuildProfileAvatar(
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  'Hello, $name!',
                  textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: true,
                      applyHeightToLastDescent: false),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const Menu();
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    MainCard(
                      index: lastGoalIndex,
                    ),
                    const SizedBox(height: 20),
                    const CarouselWithIndicatorDemo(),
                    const SizedBox(height: 20),
                    if (goalsLength != -1)
                      const Row(
                        children: [
                          Text(
                            'You May Also Like',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    if (goalsLength != -1)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProjectCard(index: goalsLength),
                            if (goalsLength2 != -1) const SizedBox(width: 10),
                            if (goalsLength2 != -1)
                              ProjectCard(index: goalsLength2),
                          ],
                        ),
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
