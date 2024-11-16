import 'package:flutter/material.dart';
import 'package:rankersethglobal/widgets/ui/project_card.dart';

class AllProjectsScreen extends StatefulWidget {
  final List<dynamic> goalsList;
  final String title;
  const AllProjectsScreen(
      {super.key, required this.goalsList, required this.title});

  @override
  State<AllProjectsScreen> createState() => _AllProjectsScreenState();
}

class _AllProjectsScreenState extends State<AllProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> goalsList = widget.goalsList;
    final String title = widget.title;
    return Scaffold(
      body: SafeArea(
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
                        Expanded(
                          child: Center(
                              child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close_outlined)),
                      ],
                    ),
                  ),
                  goalsList.isEmpty
                      ? const Center(
                          child: Text(
                            'No projects found',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: (goalsList.length / 2).ceil(),
                              itemBuilder: (context, indexs) {
                                final int goalsIndex =
                                    goalsList[(indexs * 2)][0].toInt();
                                final int goalsIndex2;
                                if (goalsList.length < ((indexs * 2) + 2)) {
                                  goalsIndex2 = -1;
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ProjectCard(
                                              index: goalsIndex,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // if (index == categories.length - 1)
                                      //   const SizedBox(height: 80),
                                    ],
                                  );
                                } else {
                                  goalsIndex2 =
                                      goalsList[(indexs * 2) + 1][0].toInt();
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ProjectCard(
                                              index: goalsIndex,
                                            ),
                                            const SizedBox(width: 10),
                                            ProjectCard(
                                              index: goalsIndex2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // if (index == categories.length - 1)
                                      //   const SizedBox(height: 80),
                                    ],
                                  );
                                }
                              }),
                        ),
                ],
              ))),
    );
  }
}
