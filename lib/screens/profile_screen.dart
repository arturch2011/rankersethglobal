import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/screens/menu_screen.dart';
import 'package:rankersethglobal/services/utility_service.dart';
import 'package:rankersethglobal/widgets/profile/create_container.dart';
import 'package:rankersethglobal/widgets/profile/my_goals_list.dart';
import 'package:rankersethglobal/widgets/profile/profile_card.dart';
import 'package:rankersethglobal/widgets/ui/tab_selector.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedOption = 'Active';
  List<String> options = ['Active', 'Finished', 'Created'];

  @override
  Widget build(BuildContext context) {
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    final UtilityService utility = UtilityService();

    List<dynamic> myGoals = block.myEnteredGoals;
    List<dynamic> myCreatedGoals = block.myCreatedGoals;
    List<dynamic> goals = block.goals;

    void setOption(String status) {
      setState(() {
        selectedOption = status;
      });
    }

    final List<dynamic> myGoalsList = utility.findGoals(goals, myGoals);
    final List<dynamic> inProgressGoals =
        utility.findGoalsInProgress(myGoalsList);
    final List<dynamic> doneGoals = utility.findPastGoals(myGoalsList);

    final List<dynamic> myCreatedList =
        utility.findGoals(goals, myCreatedGoals);
    final List<dynamic> inProgressCreated =
        utility.findGoalsInProgress(myCreatedList);
    final List<dynamic> doneCreated = utility.findPastGoals(myCreatedList);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 40,
                  ),
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
                    icon: SvgPicture.asset(
                      'assets/icons/nouns.svg',
                      width: 36,
                      // color: Colors.white,
                    ),
                    // icon: const Icon(
                    //   Icons.menu,
                    //   size: 30,
                    // ),
                  ),
                ],
              ),
              const ProfileCard(),
              const SizedBox(
                height: 20,
              ),
              TabSelector(
                  options: options,
                  selectedOption: selectedOption,
                  onOptionSelected: setOption),
              const SizedBox(height: 20),
              if (selectedOption == 'Active')
                MyGoalsList(myGoals: inProgressGoals)
              else if (selectedOption == 'Finished')
                MyGoalsList(myGoals: doneGoals)
              else
                CreateContainer(
                    inProgressList: inProgressCreated, doneList: doneCreated),
              const SizedBox(height: 90),
            ],
          ),
        )),
      ),
    );
  }
}

bool active = true;
