import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/services/utility_service.dart';
import 'package:rankersethglobal/widgets/join/bottom_pop.dart';

class JoinScreen extends StatefulWidget {
  final int index;
  const JoinScreen({super.key, required this.index});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    final UtilityService utility = UtilityService();

    final goal = block.goals[index];
    final String title = goal[1];
    final String imgUrl = goal[17][0];

    final String metaType = goal[18];
    final int vezes = goal[19].toInt();
    final int metaU = goal[20].toInt();
    final int meta = vezes * metaU;
    final double minValue = goal[6] / BigInt.from(10).pow(18);
    final String creator = "${goal[12].toString().substring(0, 10)}...";
    final double totalBet = goal[13] / BigInt.from(10).pow(18);
    final int totalParticipants = goal[15].toInt();
    final String description = goal[2];
    final int startTime = goal[7].toInt();
    final int endTime = goal[8].toInt();
    final String formatStart = utility.getFormattedDate(startTime);

    final String formatEnd = utility.getFormattedDate(endTime);
    final String frequency = goal[4];
    String fname = utility.getFrequencyName(frequency);

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
                  : Image.asset('assets/images/splash_image2.png',
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 3,
                      width: double.infinity),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255,
                          255), // Cor de fundo gradiente - começo
                      Color.fromARGB(75, 255, 255, 255),
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
                  // actions: [
                  //   IconButton(
                  //     onPressed: () {
                  //       // Ação do botão de menu.
                  //     },
                  //     icon: SvgPicture.asset(
                  //       'assets/icons/upload.svg',
                  //       width: 20,
                  //     ),
                  //   ),
                  //   IconButton(
                  //     onPressed: () {
                  //       // Ação do botão de menu.
                  //     },
                  //     icon: SvgPicture.asset(
                  //       'assets/icons/heart.svg',
                  //       width: 20,
                  //     ),
                  //   ),
                  // ],
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
                      BlocosInformativos(
                        info: '$totalParticipants participating',
                      ),
                      const SizedBox(width: 10),
                      BlocosInformativos(
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              _showInvestDialog(context, index, minValue);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Participate",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Rules and conditions",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Flexible(
                              child: Text(
                            "Find out more about the rules and conditions of the challenge.",
                          )),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Rules',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    content: SizedBox(
                                      height: 200,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          "Send $vezes photos per $fname to validate the challenge. This photo must be clear and show some moment of completing the challenge, you don't need to demonstrate each moment of the challenge, for example, if the challenge is to run 5km, you don't need to take 5 photos of 1km, just one photo that shows that you ran. If the photo is not clear or does not show the moment the challenge was completed, the photo will be invalidated. If you do not send the photo you will lose validation. If you do not complete the minimum number of validations of 85%, the bet amount will be distributed among the other participants. If you complete 100% you will receive an extra reward in credits that can be redeemed in \$",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.black, // Cor da borda
                                width: 1.0, // Largura da borda
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Read",
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      )),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlocosInformativos extends StatelessWidget {
  final String info;
  const BlocosInformativos({super.key, required this.info});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
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
        child: Center(
          child: Text(
            info,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

void _showInvestDialog(context, goalIndex, minBet) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return BottomPop(
          index: goalIndex,
          minvalue: minBet,
        );
      });
}
