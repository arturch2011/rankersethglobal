import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rankersethglobal/screens/home_screen.dart';
import 'package:rankersethglobal/screens/profile_screen.dart';
import 'package:rankersethglobal/screens/projects_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (currentPage) {
      case 0:
        page = const ProjectsScreen();
        break;
      case 1:
        page = const HomeScreen();
        break;
      case 2:
        page = const ProfileScreen();
        break;
      default:
        throw UnimplementedError('no widget for $currentPage');
    }

    return Scaffold(
      body: Stack(
        children: [
          page,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                border: Border.all(
                  color: Colors.black, // Cor da borda
                  width: 2, // Largura da borda
                ),
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer, // Cor de fundo
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5), // Sombra
                //     spreadRadius: 1,
                //     blurRadius: 5,
                //     // Ajuste a sombra vertical aqui
                //   ),
                // ],
              ),
              margin: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 20), // Margem superior
              padding: const EdgeInsets.symmetric(
                  vertical: 1, horizontal: 20), // Padding interno
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0, // Cor de fundo
                  iconSize: 20,

                  selectedFontSize: 0,
                  unselectedFontSize: 0,
                  enableFeedback: false,
                  onTap: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  currentIndex: currentPage,
                  items: [
                    BottomNavigationBarItem(
                      activeIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/icons/paper.svg',
                          width: 27,
                          height: 27,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/paper.svg',
                        width: 27,
                        height: 27,
                        color: Colors.white,
                      ),
                      label: 'Projects',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/icons/home.svg',
                          width: 27,
                          height: 27,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/home.svg',
                        width: 27,
                        height: 27,
                        color: Colors.white,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Container(
                        padding: const EdgeInsets.all(12),
                        // decoration: BoxDecoration(
                        //   color: Theme.of(context).primaryColor,
                        //   borderRadius: const BorderRadius.all(
                        //     Radius.circular(50),
                        //   ),
                        // ),
                        child: SvgPicture.asset(
                          'assets/icons/user.svg',
                          width: 27,
                          height: 27,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/user.svg',
                        width: 27,
                        height: 27,
                        color: Colors.white,
                      ),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
