import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/screens/active_screen.dart';
import 'package:rankersethglobal/services/utility_service.dart';
import 'package:rankersethglobal/widgets/ui/progress_indicator.dart';

class MainCard extends StatefulWidget {
  final int index;
  const MainCard({super.key, required this.index});

  @override
  State<MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> {
  @override
  Widget build(BuildContext context) {
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    final UtilityService utility = UtilityService();
    int index = widget.index;

    String title = 'title';
    String metaType = '--';
    int vezes = 1;
    int metaU = 1;
    int meta = 0;
    int totalMeta = 1;
    String frequency = 'Daily';
    String fname = 'day';
    double progressValue = 0.0;
    double myBet = 0.0;

    if (index != -1) {
      final goal = block.goals[index];
      title = goal[1];
      metaType = goal[18];

      vezes = goal[19].toInt();
      metaU = goal[20].toInt();
      meta = vezes * metaU;
      totalMeta = goal[5].toInt();
      frequency = goal[4];

      fname = utility.getFrequencyName(frequency);
    }

    Future<void> getInfos() async {
      BigInt bigprogress = await block.getMyProgress(BigInt.from(index));
      int progress = bigprogress.toInt();
      print("aaaaaaaaaaaaaaaaaaaaaaaaa $progress");
      BigInt bet = await block.getMyBets(BigInt.from(index));
      double totalProgress = progress / totalMeta;

      progressValue = totalProgress;
      myBet = bet / BigInt.from(10).pow(18);
    }

    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(20),
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
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('FIND A NEW PROJECT!'),
                  Icon(
                    Icons.arrow_right_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              )
            : GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ActiveScreen(
                          index: index,
                        );
                      },
                    ),
                  );
                },
                child: FutureBuilder(
                  future: getInfos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return Row(children: [
                        BuildProgressIndicator(
                          percentage: progressValue,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$meta $metaType per $fname', // Valor do progresso (substitua pelo valor real)
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Bet \$$myBet ', // Valor do progresso (substitua pelo valor real)
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ]);
                    }
                  },
                )));
  }
}
