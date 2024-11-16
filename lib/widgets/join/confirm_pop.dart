import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/providers/user_provider.dart';
import 'package:rankersethglobal/widgets/ui/loading_popup.dart';
import 'package:http/http.dart' as http;

class ConfirmPop extends StatefulWidget {
  final String valorFinal;
  final int index;
  const ConfirmPop({super.key, required this.valorFinal, required this.index});

  @override
  State<ConfirmPop> createState() => _ConfirmPopState();
}

class _ConfirmPopState extends State<ConfirmPop> {
  @override
  Widget build(BuildContext context) {
    UserProvider auth = Provider.of<UserProvider>(context);
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    String email = 'email';
    try {
      email = auth.userInfos!['userInfo']["email"];
    } catch (e) {
      email = '';
    }

    final goal = block.goals[widget.index];
    final String frequency = goal[4];
    late String fname;

    if (frequency == 'Daily') {
      fname = 'day';
    } else if (frequency == 'Weekly') {
      fname = 'week';
    } else if (frequency == 'Monthly') {
      fname = 'month';
    } else {
      fname = '-';
    }
    final int meta = goal[19].toInt() * goal[20].toInt();
    final String metaType = goal[18];

    return Container(
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text("You want to bet",
              style: TextStyle(fontSize: 22, color: Colors.black)),
          Text("\$${widget.valorFinal}",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text("on '$meta $metaType per $fname'?",
              style: const TextStyle(fontSize: 22, color: Colors.black)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () async {
                showLoadingDialog(context);
                try {
                  await block.enterGoal(BigInt.from(widget.index),
                      double.parse(widget.valorFinal));

                  var url = Uri.parse(
                      'https://us-central1-goals-e4200.cloudfunctions.net/addEventToUser');
                  var config = {
                    'email': email,
                    'eventId': goal[0].toString(),
                    'eventName': goal[1],
                    'address': block.addr,
                  };
                  var headers = {
                    'Content-Type': 'application/x-www-form-urlencoded',
                  };
                  var response =
                      await http.post(url, headers: headers, body: config);
                  hideLoadingDialog(context);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  showCheckDialog(context, 'You are on the project!');
                } catch (e) {
                  hideLoadingDialog(context);
                  showErrorDialog(context, e.toString());
                }
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16.0), // Raio dos cantos
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              child:
                  const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).primaryColor, // Cor da borda
                  width: 1.0, // Largura da borda
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Switch Value',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
        ],
      ),
    );
  }
}
