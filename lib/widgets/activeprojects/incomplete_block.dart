import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/providers/user_provider.dart';
import 'package:rankersethglobal/screens/camera_screen.dart';
import 'package:rankersethglobal/services/utility_service.dart';

class IncompleteBlock extends StatelessWidget {
  final int index;
  const IncompleteBlock({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    final UtilityService utility = UtilityService();
    final photoList = Provider.of<UserProvider>(context).photoList;

    final goal = block.goals[index];
    final int vezes = goal[19].toInt();
    final String frequency = goal[4];
    String fname = utility.getFrequencyName(frequency);

    Future<bool> getUris() async {
      bool result = false;
      result = !photoList.any((element) =>
          element.index == index && element.date == DateTime.now().day);
      return result;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rules and Conditions",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                const SizedBox(width: 5),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Rules and Conditions',
                            style: TextStyle(color: Colors.black),
                          ),
                          content: SizedBox(
                            height: 200,
                            child: SingleChildScrollView(
                              child: Text(
                                  "Send $vezes photos per $fname to validate the challenge. This photo must be clear and show some moment of completing the challenge, you don't need to demonstrate each moment of the challenge, for example, if the challenge is to run 5km, you don't need to take 5 photos of 1km, just one photo that shows that you ran. If the photo is not clear or does not show the moment the challenge was completed, the photo will be invalidated. If you do not send the photo you will lose validation. If you do not complete the minimum number of validations of 85%, the bet amount will be distributed among the other participants. If you complete 100% you will receive an extra reward in credits that can be redeemed in \$",
                                  style: TextStyle(color: Colors.black)),
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
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          child: FutureBuilder(
            future: getUris(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                bool result = snapshot.data as bool;
                return TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return CameraApp(index: index);
                        },
                      ),
                    );
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
                  child: const Text('Validate',
                      style: TextStyle(color: Colors.white)),
                );
                // return result
                //     ? TextButton(
                //         onPressed: () {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) {
                //                 return CameraApp(index: index);
                //               },
                //             ),
                //           );
                //         },
                //         style: ButtonStyle(
                //           shape: MaterialStateProperty.all<
                //               RoundedRectangleBorder>(
                //             RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(
                //                   16.0), // Raio dos cantos
                //             ),
                //           ),
                //           backgroundColor: MaterialStateProperty.all(
                //             Theme.of(context).primaryColor,
                //           ),
                //           padding: MaterialStateProperty.all(
                //             const EdgeInsets.symmetric(vertical: 16),
                //           ),
                //         ),
                //         child: const Text('Validate',
                //             style: TextStyle(color: Colors.white)),
                //       )
                //     : TextButton(
                //         onPressed: () {},
                //         style: ButtonStyle(
                //           shape: MaterialStateProperty.all<
                //               RoundedRectangleBorder>(
                //             RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(
                //                   16.0), // Raio dos cantos
                //             ),
                //           ),
                //           backgroundColor: MaterialStateProperty.all(
                //             Colors.green,
                //           ),
                //           padding: MaterialStateProperty.all(
                //             const EdgeInsets.symmetric(vertical: 16),
                //           ),
                //         ),
                //         child:
                //             const Icon(Icons.check, color: Colors.white),
                //       );
              }
            },
          ),
        ),
      ],
    );
  }
}
