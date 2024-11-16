import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/providers/user_provider.dart';
import 'package:rankersethglobal/widgets/ui/profile_avatar.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    UserProvider auth = Provider.of<UserProvider>(context);
    String name = "User";
    String email = "@";

    try {
      final names = auth.userInfos!['userInfo']["name"].split(" ");
      name = names[0];
      email = auth.userInfos!['userInfo']["email"];
    } catch (e) {
      name = "User";
    }

    List<dynamic> myGoals = block.myEnteredGoals;

    String address = block.publicAddr;
    double balance = block.balanceEth;

    return Stack(children: [
      Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer, // Cor de fundo,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 90,
                      ),
                      Column(
                        children: [
                          const Text("Projects"),
                          Text(
                            "${myGoals.length}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Wallet"),
                          SizedBox(
                            width: 90,
                            child: Text(
                              balance.toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(email, style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              FlutterClipboard.copy(address).then((value) {
                                const snackBar = SnackBar(
                                  content: Text('Copied to clipboard!'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            },
                            child: Row(children: [
                              Text('Address: ${address.substring(0, 6)}...',
                                  style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.copy,
                                size: 15,
                                color: Colors.white,
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const Positioned(
        top: 0,
        left: 30,
        child: BuildProfileAvatar(size: 45),
      ),
    ]);
  }
}
