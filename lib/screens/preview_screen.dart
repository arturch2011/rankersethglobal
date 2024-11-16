import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/providers/user_provider.dart';
import 'package:rankersethglobal/services/filecoin_service.dart';
import 'package:rankersethglobal/widgets/ui/loading_popup.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;
  final int index;
  const ImagePreviewScreen(
      {super.key, required this.imagePath, required this.index});

  Future<bool> aiValidation(String hash, String prompt) async {
    final url =
        Uri.parse('https://goals-validator-server.onrender.com/validate-image');

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'imageHash': hash,
      'validationPrompt': prompt,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response']
            as bool; // Supondo que a API retorne {"result": true/false}
      } else {
        throw Exception('Falha na requisição: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao se comunicar com a API: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int dia = DateTime.now().day;
    final photoList = Provider.of<UserProvider>(context);
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);

    Future<String> sendFileCoins(String imagePath) async {
      String filePath = imagePath;
      final response = await uploadFile(filePath);
      final body = await jsonDecode(response.body);
      final hash = body['Hash'];
      return hash;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ), // Espaço flexível (ocupa o espaço que sobra)
              const Center(
                  child: Text(
                "Validation",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
              const SizedBox(
                height: 30,
              ),

              ///
              Container(
                width: double.infinity,
                height: 500, // Ocupa toda a largura da tela
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius:
                      BorderRadius.circular(20.0), // Borda arredondada
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover, // Preencher toda a área
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Column(
                children: [
                  Center(
                      child: Text(
                    "Looks nice!",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
                  SizedBox(height: 8), // Espaço entre os textos
                  Center(
                      child: Text(
                    "To validate the photo, just click “Send”, if not, let's take another one…",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  )),
                  //
                ],
              ),
              const SizedBox(
                height: 30,
              ), // Espaço flexível (ocupa o espaço que sobra
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        showLoadingDialog(context);

                        try {
                          String filecoinHash = await sendFileCoins(imagePath);
                          bool isValid = await aiValidation(filecoinHash,
                              'Is that a blue bottle? Respond as true or false. It has to be a real image, not a generated one or animated.');

                          if (isValid) {
                            await block.updateFrequency(
                                BigInt.from(index), filecoinHash);
                            photoList.removeItem(index);
                            photoList.addItem(PhotoDate(index, dia));
                            await photoList.savePhotoList();
                            hideLoadingDialog(context);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            showCheckDialog(context, 'Success !');
                          } else {
                            hideLoadingDialog(context);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            showErrorDialog(context,
                                'The image does not correspond to the habit !');
                          }
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
                      child: const Text('Send',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 8), // Espaço entre os botões
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16.0), // Raio dos cantos
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      child: Text('Back',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
