import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/user_provider.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove o botão de voltar
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              // color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/config.svg',
                  width: 27,
                  // color: Colors.white,
                ),
                label: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(alignment: Alignment.centerLeft),
              ),
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: TextButton.icon(
            //     onPressed: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) {
            //             return const Wallet();
            //           },
            //         ),
            //       );
            //     },
            //     icon: SvgPicture.asset(
            //       'assets/icons/wallet.svg',
            //       width: 27,
            //     ),
            //     label: const Text(
            //       'Deposit and withdraw',
            //       style: TextStyle(color: Colors.black),
            //     ),
            //     style: const ButtonStyle(alignment: Alignment.centerLeft),
            //   ),
            // ),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/heart.svg',
                  width: 27,
                  // color: Colors.white,
                ),
                label: const Text(
                  'Favorites',
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(alignment: Alignment.centerLeft),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/help.svg',
                  width: 27,
                  // color: Colors.white,
                ),
                label: const Text(
                  'Help',
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(alignment: Alignment.centerLeft),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/question.svg',
                  width: 27,
                  // color: Colors.white,
                ),
                label: const Text(
                  'Frequently asked',
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(alignment: Alignment.centerLeft),
              ),
            ),
            const Spacer(), // Adiciona um espaço flexível entre os botões e o botão inferior
            TextButton.icon(
              onPressed: () {
                context.read<UserProvider>().logout();
                Navigator.of(context).pop();
              },
              icon: SvgPicture.asset(
                'assets/icons/logout.svg',
                width: 27,
                color: Colors.red,
              ),
              label: const Text(
                'Log out',
                textHeightBehavior: TextHeightBehavior(
                    applyHeightToFirstAscent: true,
                    applyHeightToLastDescent: false),
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
