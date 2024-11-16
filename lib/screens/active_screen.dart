import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/services/utility_service.dart';
import 'package:rankersethglobal/widgets/activeprojects/incomplete_block.dart';
import 'package:rankersethglobal/widgets/activeprojects/info_block.dart';
import 'package:rankersethglobal/widgets/ui/progress_indicator.dart';

class ActiveScreen extends StatefulWidget {
  final int index;
  const ActiveScreen({super.key, required this.index});

  @override
  State<ActiveScreen> createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    final UtilityService utility = UtilityService();

    double progressValue = 0.0;
    int fullProgress = 0;
    double myBet = 0.0;
    final goal = block.goals[index];
    final String title = goal[1];
    final String imgUrl = goal[17][0];
    final int vezes = goal[19].toInt();
    final int metaU = goal[20].toInt();
    final int meta = vezes * metaU;
    final bool isFinished = goal[10];
    final int totalMeta = goal[5].toInt();
    final String metaType = goal[18];
    final String creator = "${goal[12].toString().substring(0, 10)}...";
    final double totalBet = goal[13] / BigInt.from(10).pow(18);
    final int totalParticipants = goal[15].toInt();
    final int startTime = goal[7].toInt();
    final int endTime = goal[8].toInt();
    final String formatStart = utility.getFormattedDate(startTime);
    final String formatEnd = utility.getFormattedDate(endTime);
    final int timer = utility.getDaysToEnd(endTime);
    final int timerStart = utility.getDaysToStart(startTime);
    final int totalDays = utility.getTotalDays(startTime, endTime);
    final String frequency = goal[4];
    String fname = utility.getFrequencyName(frequency);
    String fplural = utility.getFrequencyPluralName(frequency);
    String passTime = utility.getPastTime(frequency, startTime);

    Future<void> getInfos() async {
      BigInt bigprogress = await block.getMyProgress(BigInt.from(index));
      int progress = bigprogress.toInt();
      BigInt bet = await block.getMyBets(BigInt.from(index));
      double totalProgress = progress / totalMeta;
      int progressMeta = progress * metaU;

      fullProgress = progressMeta;
      progressValue = totalProgress;
      myBet = bet / BigInt.from(10).pow(18);
    }

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(children: [
            imgUrl.substring(0, 28) == 'https://gateway.pinata.cloud'
                ? Image.network(imgUrl,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.infinity)
                : Image.asset('assets/images/logorankers.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.infinity),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(
                        255, 255, 255, 255), // Cor de fundo gradiente - começo
                    Color.fromARGB(195, 255, 255, 255),
                    Color.fromARGB(0, 255, 255, 255),
                    Color.fromARGB(
                        0, 255, 255, 255), // Cor de fundo gradiente - começo
                    Color.fromARGB(
                        0, 255, 255, 255), // Cor de fundo gradiente - fim
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: AppBar(
                title: Text(title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
                centerTitle: true,
                backgroundColor: Colors.transparent,
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$meta $metaType per $fname",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  "Created by $creator",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoBlock(
                      info: '$totalParticipants participating',
                    ),
                    const SizedBox(width: 10),
                    InfoBlock(
                      info: 'R\$$totalBet locked',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      width: 20,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "From $formatStart to $formatEnd",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                FutureBuilder(
                  future: getInfos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(25, 8, 25, 25),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    color: Colors.white, size: 15),
                                const SizedBox(width: 2),
                                timer > totalDays
                                    ? Text(
                                        "${timerStart.toStringAsFixed(0)} days to start",
                                        textHeightBehavior:
                                            const TextHeightBehavior(
                                                applyHeightToFirstAscent: true,
                                                applyHeightToLastDescent:
                                                    false),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      )
                                    : Text(
                                        "Remains ${timer.toStringAsFixed(0)} days",
                                        textHeightBehavior:
                                            const TextHeightBehavior(
                                                applyHeightToFirstAscent: true,
                                                applyHeightToLastDescent:
                                                    false),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BuildProgressIndicator(
                                  percentage: progressValue,
                                ),
                                Column(
                                  children: [
                                    const Text("Conclude"),
                                    Text(
                                      "$fullProgress $metaType ",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(fplural),
                                    Text(
                                      passTime,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text("Bet"),
                                    Text(
                                      "\$ $myBet",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                isFinished
                    ? const Column(
                        children: [
                          Text(
                            "Project concluded",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "The challenge was completed successfully. If you complete more than 85% of the validations you will receive your bet amount back. If you completed 100% you will receive an extra reward in credits that can be redeemed in R\$. If you did not complete 85% of the challenge you will lose the bet amount.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    : IncompleteBlock(index: index),
              ],
            ),
          )
        ],
      )),
    );
  }
}
