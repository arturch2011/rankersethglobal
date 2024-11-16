import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/screens/all_projects_screen.dart';
import 'package:rankersethglobal/widgets/ui/project_card.dart';
import 'package:rankersethglobal/widgets/ui/search_popup.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final List<String> categories = const [
    'Exercise',
    'Routine',
    'Studies',
    'Reading'
  ];

  @override
  Widget build(BuildContext context) {
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    List<dynamic> unstartedGoals = block.unstartedGoals;
    List<dynamic> publicGoals = block.publicGoals;

    if (unstartedGoals.isNotEmpty) {
      if (publicGoals.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text('No projects found',
                  style: TextStyle(color: Colors.black)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Search privates',
                ),
                IconButton(
                    onPressed: () {
                      _showPicker(context, unstartedGoals);
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 27,
                    )),
              ],
            ),
          ],
        );
      } else {
        return SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          Center(
                              child: Text(
                            "Projects",
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                          IconButton(
                              onPressed: () {
                                _showPicker(context, unstartedGoals);
                              },
                              icon: const Icon(
                                Icons.search,
                                size: 27,
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            late List<dynamic> categoryList = publicGoals
                                .where((element) => element[3] == category)
                                .toList();

                            final int categoryListLength =
                                categoryList.length - 1;
                            final int categoryListLength2 =
                                categoryList.length - 2;
                            int goalsIndex = -1;
                            int goalsIndex2 = -1;
                            if (categoryList.isNotEmpty) {
                              goalsIndex =
                                  categoryList[categoryListLength][0].toInt();
                              if (categoryList.length > 1) {
                                goalsIndex2 = categoryList[categoryListLength2]
                                        [0]
                                    .toInt();
                              }
                            }

                            return categoryList.isEmpty
                                ? SizedBox()
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            category,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return AllProjectsScreen(
                                                      goalsList: categoryList,
                                                      title:
                                                          "$category Projects",
                                                    );
                                                  },
                                                ),
                                              )
                                            },
                                            child: const Text(
                                              'See more',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Color.fromRGBO(
                                                    156, 156, 156, 1),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 20),
                                        child: goalsIndex2 != -1
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ProjectCard(
                                                    index: goalsIndex,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  ProjectCard(
                                                    index: goalsIndex2,
                                                  ),
                                                ],
                                              )
                                            : ProjectCard(
                                                index: goalsIndex,
                                              ),
                                      ),
                                      if (index == categories.length - 1)
                                        const SizedBox(height: 80),
                                    ],
                                  );
                          }),
                    ),
                  ],
                )));
      }
    } else {
      return const Center(
        child: Text('No projects found', style: TextStyle(color: Colors.black)),
      );
    }
  }

  void _showPicker(BuildContext context, List<dynamic> unstartedGoalss) {
    showDialog(
      context: context,
      builder: (context) => MyDialog(unstartedGoals: unstartedGoalss),
    );
  }
}
