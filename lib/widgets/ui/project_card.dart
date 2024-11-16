import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/screens/join_screen.dart';
import 'package:rankersethglobal/services/utility_service.dart';

class ProjectCard extends StatefulWidget {
  final int index;
  const ProjectCard({super.key, required this.index});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    final UtilityService utility = UtilityService();
    int index = widget.index;

    String title = 'title';
    String imgUrl = '1111111111111111111111111111111';
    int startTime = 0;
    int timer = 0;
    int vezes = 1;
    int metaU = 1;
    int meta = 0;
    String metaType = '--';
    String frequency = 'Daily';
    String fname = 'day';

    if (index != -1) {
      final goal = block.goals[index];
      title = goal[1];
      imgUrl = goal[17][0];
      startTime = goal[7].toInt();
      timer = utility.getDaysToStart(startTime);
      vezes = goal[19].toInt();
      metaU = goal[20].toInt();
      meta = vezes * metaU;
      metaType = goal[18];
      frequency = goal[4];

      fname = utility.getFrequencyName(frequency);
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return JoinScreen(index: index);
              },
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(
              color: Colors.black, // Cor da borda
              width: 2, // Largura da borda
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5), // Sombra
            //     spreadRadius: 1,
            //     blurRadius: 5,
            //     // Ajuste a sombra vertical aqui
            //   ),
            // ],
          ),
          child: (index == -1)
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: Text('No projects found'),
                )
              : Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: imgUrl.substring(0, 28) ==
                              'https://gateway.pinata.cloud'
                          ? Image.network(imgUrl,
                              fit: BoxFit.cover,
                              height: 150,
                              width: double.infinity)
                          : Image.asset('assets/images/logorankers.png',
                              fit: BoxFit.cover,
                              height: 150,
                              width: double.infinity),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black, // Cor da borda
                            width: 2, // Largura da borda
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '${timer.toStringAsFixed(0)}d',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              '$meta $metaType per $fname', // Valor do progresso (substitua pelo valor real)
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) {
                                  //       return ProjectDetails(index: index);
                                  //     },
                                  //   ),
                                  // );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Participate",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
