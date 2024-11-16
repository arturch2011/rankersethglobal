import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/services/utility_service.dart';
import 'package:http/http.dart' as http;
import 'package:rankersethglobal/widgets/ui/loading_popup.dart';

class CreatedCard extends StatefulWidget {
  final int index;
  const CreatedCard({super.key, required this.index});

  @override
  State<CreatedCard> createState() => _CreatedCardState();
}

class _CreatedCardState extends State<CreatedCard> {
  Future<String> stake(double amout) async {
    final amount = amout == 0 ? 0.0001 : amout / 1000000;
    final url = Uri.parse(
        'https://rankers-coinbase-server.onrender.com/coinbase/stake');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "user": {
        "walletId": "2dd469d2-8105-42a7-b9e8-81e520d47c53",
        "seed":
            "61bbe3b2bcd619a560877e934f5813501e73529786f137a993cdc63095569237"
      },
      "amount": amount,
      "asset": "eth"
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      // return jsonDecode(response.body["transactionLink"]);
      final data = await jsonDecode(response.body);
      return data['transactionLink'];
    } catch (error) {
      throw Exception('Erro ao se comunicar com a API: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    final UtilityService utility = UtilityService();
    final int index = widget.index;
    // final goal = block.goals[index];
    // final double totalBet = goal[13] / BigInt.from(10).pow(18);

    List<dynamic> goals = block.goals[index];

    final String title = goals[1];
    final int startTime = goals[7].toInt();
    final int endTime = goals[8].toInt();
    final bool isStarted = goals[9];
    final bool isFinished = goals[10];
    final String metaType = goals[18];
    final double timer = (startTime - DateTime.now().millisecondsSinceEpoch) /
        (1000 * 60 * 60 * 24);
    final double endTimer = (endTime - DateTime.now().millisecondsSinceEpoch) /
        (1000 * 60 * 60 * 24);

    final int vezes = goals[19].toInt();
    final int metaU = goals[20].toInt();
    final int meta = vezes * metaU;
    final bool isPublic = goals[11];
    final double totalBet = goals[13] / BigInt.from(10).pow(18);
    final double preFound = goals[14] / BigInt.from(10).pow(18);
    final int totalParticipants = goals[15].toInt();
    final String frequency = goals[4];
    final String fname = utility.getFrequencyName(frequency);

    void startGoal() async {
      showLoadingDialog(context);
      try {
        await block.startGoal(BigInt.from(index));
        String scanLink = await stake(1);
        hideLoadingDialog(context);
        showCheckDialog(context, 'Started with success !', scanLink);
      } catch (e) {
        hideLoadingDialog(context);
        showErrorDialog(context, e.toString());
      }
    }

    void endGoal() async {
      showLoadingDialog(context);
      try {
        await block.completeGoal(BigInt.from(index));
        hideLoadingDialog(context);
        showCheckDialog(context, 'Finalized with success !', null);
      } catch (e) {
        hideLoadingDialog(context);
        showErrorDialog(context, e.toString());
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              '$meta $metaType per $fname', // Valor do progresso (substitua pelo valor real)
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            if (endTimer > 0)
              Container(
                child: timer < 0
                    ? Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                              Text(
                                '${endTimer.toStringAsFixed(0)}d',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
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
              )
          ],
        ),
        const SizedBox(width: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Initial value: \$$preFound', // Valor do progresso (substitua pelo valor real)
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
                Text(
                  'Locked value: \$$totalBet', // Valor do progresso (substitua pelo valor real)
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
                Text(
                  'Total participants: $totalParticipants', // Valor do progresso (substitua pelo valor real)
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
                Text(
                  isPublic
                      ? 'Public'
                      : 'Private', // Valor do progresso (substitua pelo valor real)
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            endTimer > 0
                ? timer < 1
                    ? isStarted
                        ? const Text('Project started')
                        : TextButton(
                            onPressed: () => startGoal(),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Start",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                    : const Text(
                        'Whait the initial date to start the project',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      )
                : isFinished
                    ? const Text('Project concluded')
                    : TextButton(
                        onPressed: () => endGoal(),
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Finalize",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
          ],
        ),
      ]),
    );
  }
}
