import 'package:flutter/material.dart';
import 'package:rankersethglobal/screens/create_screen.dart';
import 'package:rankersethglobal/widgets/profile/my_created_list.dart';
import 'package:rankersethglobal/widgets/ui/tab_selector.dart';

class CreateContainer extends StatefulWidget {
  final List<dynamic> inProgressList;
  final List<dynamic> doneList;
  const CreateContainer(
      {super.key, required this.inProgressList, required this.doneList});

  @override
  State<CreateContainer> createState() => _CreateContainerState();
}

class _CreateContainerState extends State<CreateContainer> {
  String statusSelecionado2 = 'In progress';
  String selectedOption = 'In progress';
  List<String> options = ['In progress', 'Done'];
  @override
  Widget build(BuildContext context) {
    void setOption(String status) {
      setState(() {
        selectedOption = status;
      });
    }

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 270,
              child: TabSelector(
                  options: options,
                  selectedOption: selectedOption,
                  onOptionSelected: setOption),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const CreateScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Icon(Icons.add,
                      size: 35, color: Color.fromARGB(255, 129, 129, 129)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        selectedOption == 'In progress'
            ? MyCreatedList(myGoals: widget.inProgressList)
            : MyCreatedList(myGoals: widget.doneList),
      ],
    );
  }
}
