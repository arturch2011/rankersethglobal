import 'package:flutter/material.dart';
import 'package:rankersethglobal/widgets/join/confirm_pop.dart';

class BottomPop extends StatefulWidget {
  final int index;
  final double minvalue;
  const BottomPop({super.key, required this.index, required this.minvalue});

  @override
  State<BottomPop> createState() => _BottomPopState();
}

class _BottomPopState extends State<BottomPop> {
  String valorSelecionado = valores[0];

  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    return Container(
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recomended bet",
              style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: Row(
              children: valores
                  .take(3) // Pegue apenas os 3 primeiros valores
                  .map((value) {
                final isSelected = valorSelecionado == value;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        valorSelecionado = value;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "\$$value",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                valorSelecionado = value;
              });
            },
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Another value', // Placeholder
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6), // Espaçamento interno
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0), // Borda arredondada
                borderSide:
                    const BorderSide(color: Colors.grey), // Cor da borda padrão
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0), // Borda arredondada
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .primary), // Cor da borda quando em foco
              ),
            ),
          ),
          const SizedBox(height: 5),
          Align(
              alignment: Alignment.centerRight,
              child: Text("Minimum bet: \$${widget.minvalue}",
                  style: const TextStyle(fontSize: 12, color: Colors.black))),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                _showConfirmDialog(context, valorSelecionado, index);
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
              child: const Text('Bet',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}

void _showConfirmDialog(context, valor, goalIndex) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ConfirmPop(
          valorFinal: valor,
          index: goalIndex,
        );
      });
}

List<String> valores = ['5', '10', '20'];
