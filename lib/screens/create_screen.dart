import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';
import 'package:rankersethglobal/services/pinata_service.dart';
import 'package:rankersethglobal/services/utility_service.dart';
import 'package:rankersethglobal/widgets/ui/date_selector.dart';
import 'package:rankersethglobal/widgets/ui/dropdown_selector.dart';
import 'package:rankersethglobal/widgets/ui/image_selector.dart';
import 'dart:io';

import 'package:rankersethglobal/widgets/ui/loading_popup.dart';
import 'package:rankersethglobal/widgets/ui/number_selector.dart';
import 'package:rankersethglobal/widgets/ui/option_selector.dart';
import 'package:rankersethglobal/widgets/ui/text_field.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  List<String> categories = ['Exercise', 'Routine', 'Reading', 'Studies'];
  List<String> frequencies = ['Daily', 'Weekly', 'Monthly'];
  List<String> types = ['Liters', 'Km', 'Repetitions', "Minuts", "Hours"];
  List<String> privacyOptions = ['Public', 'Private'];
  final name = TextEditingController();
  final betController = TextEditingController();
  final foundController = TextEditingController();
  final description = TextEditingController();
  final prompt = TextEditingController();
  String selectedCategory = 'Exercise';
  String selectedFrequency = 'Daily';
  int times = 1;
  int meta = 1;
  int duration = 1;
  int totalMeta = 1;
  String type = 'Liters';
  String privacy = 'Public';
  int limit = 100000;
  DateTime initDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(const Duration(days: 1));
  DateTime endDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(const Duration(days: 2));

  final picker = ImagePicker();
  XFile? pickedImage;
  List<String> imgList = [];

  @override
  Widget build(BuildContext context) {
    final UtilityService utility = UtilityService();
    BlockchainProvider block = Provider.of<BlockchainProvider>(context);
    double bet = double.tryParse(betController.text) ?? 0;
    double preFund = double.tryParse(foundController.text) ?? 0;
    bool isPublic = privacy == 'Public';

    totalMeta =
        utility.getTotalMeta(initDate, endDate, selectedFrequency, times);

    void setCategory(String status) {
      setState(() {
        selectedCategory = status;
      });
    }

    void setFrequency(String status) {
      setState(() {
        selectedFrequency = status;
      });
    }

    void setPrivacy(String status) {
      setState(() {
        privacy = status;
      });
    }

    void setType(String status) {
      setState(() {
        type = status;
      });
    }

    void setTimes(bool increase) {
      setState(() {
        if (increase) {
          times++;
        } else {
          if (times > 1) {
            times--;
          }
        }
      });
    }

    void setMeta(bool increase) {
      setState(() {
        if (increase) {
          meta++;
        } else {
          if (meta > 1) {
            meta--;
          }
        }
      });
    }

    void setLimit(bool increase) {
      setState(() {
        if (increase) {
          if (limit >= 100000) {
            limit = 1;
          } else {
            limit++;
          }
        } else {
          if (limit <= 1) {
            limit = 100000;
          } else if (limit > 1) {
            limit--;
          }
        }
      });
    }

    void setDate(bool isEnd, DateTime? date) {
      if (date != null) {
        setState(() {
          if (isEnd) {
            endDate = date;
          } else {
            initDate = date;
          }
        });
      }
    }

    void setImage(XFile image) {
      setState(() {
        pickedImage = image;
      });
    }

    // Use the myProvider here
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Project'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 6),
              TextFieldInput(
                  textEditingController: name,
                  hintText: "Name",
                  textInputType: TextInputType.text),
              const SizedBox(height: 20),
              const Text('Category', style: TextStyle(color: Colors.black)),
              OptionSelector(
                  options: categories,
                  selectedOption: selectedCategory,
                  onOptionSelected: setCategory),
              const SizedBox(height: 20),
              const Text('Frequency', style: TextStyle(color: Colors.black)),
              OptionSelector(
                  options: frequencies,
                  selectedOption: selectedFrequency,
                  onOptionSelected: setFrequency),
              selectedFrequency == 'Weekly' || selectedFrequency == 'Monthly'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text('How many times ?',
                            style: TextStyle(color: Colors.black)),
                        NumberSelector(value: times, onValueSelected: setTimes)
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              const Text('Meta', style: TextStyle(color: Colors.black)),
              Row(
                children: [
                  NumberSelector(value: meta, onValueSelected: setMeta),
                  const SizedBox(width: 20),
                  DropSelector(
                      options: types,
                      selectedOption: type,
                      onOptionSelected: setType)
                ],
              ),
              const SizedBox(height: 20),
              const Text('Minimum bet (optional)',
                  style: TextStyle(color: Colors.black)),
              const SizedBox(height: 6),
              TextFieldInput(
                  textEditingController: betController,
                  hintText: 'Bet Value',
                  textInputType: TextInputType.number),
              const SizedBox(height: 20),
              const Text('Initial Prize (optional)',
                  style: TextStyle(color: Colors.black)),
              const SizedBox(height: 6),
              TextFieldInput(
                  textEditingController: foundController,
                  hintText: 'Initial Prize Value',
                  textInputType: TextInputType.number),
              const SizedBox(height: 20),
              const Text('Participants Limit',
                  style: TextStyle(color: Colors.black)),
              NumberSelector(
                value: limit,
                onValueSelected: setLimit,
                onTap: () {
                  _showPicker(context);
                },
              ),
              const SizedBox(height: 20),
              const Text('Period', style: TextStyle(color: Colors.black)),
              const SizedBox(height: 6),
              Row(
                children: [
                  DateSelector(
                      initDate: initDate,
                      endDate: endDate,
                      duration: duration,
                      isEnd: false,
                      onOptionSelected: setDate),
                  const SizedBox(width: 20),
                  DateSelector(
                      initDate: initDate,
                      endDate: endDate,
                      duration: duration,
                      isEnd: true,
                      onOptionSelected: setDate),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Who can see', style: TextStyle(color: Colors.black)),
              OptionSelector(
                  options: privacyOptions,
                  selectedOption: privacy,
                  onOptionSelected: setPrivacy),
              const SizedBox(height: 20),
              const Text('Project Cover',
                  style: TextStyle(color: Colors.black)),
              const SizedBox(height: 6),
              ImageSelector(
                  pickedImage: pickedImage, onImageSelected: setImage),
              const SizedBox(height: 20),
              const Text('Description', style: TextStyle(color: Colors.black)),
              const SizedBox(height: 6),
              TextFieldInput(
                textEditingController: description,
                hintText: 'Your description here...',
                textInputType: TextInputType.text,
                minLines: 3,
                maxLines: null,
              ),
              const SizedBox(height: 20),
              const Text('Prompt for AI image analysis',
                  style: TextStyle(color: Colors.black)),
              const SizedBox(height: 6),
              TextFieldInput(
                textEditingController: prompt,
                hintText: "e.g., Is this a photo of a cat?",
                textInputType: TextInputType.text,
                minLines: 3,
                maxLines: null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    showLoadingDialog(context);
                    try {
                      BigInt metaBigInt = BigInt.from(meta);
                      BigInt totalMetaBigInt = BigInt.from(totalMeta);
                      BigInt vezesBigInt = BigInt.from(times);
                      BigInt dataInicialBigInt =
                          BigInt.from(initDate.millisecondsSinceEpoch);
                      BigInt dataFinalBigInt =
                          BigInt.from(endDate.millisecondsSinceEpoch);
                      BigInt numeroPessoasBigInt = BigInt.from(limit);
                      String result = await pinFile(pickedImage!.path);
                      final String link =
                          result.substring(8, result.length - 26);
                      imgList.add(link);

                      await block.createGoal(
                          name.text,
                          description.text,
                          selectedCategory,
                          selectedFrequency,
                          totalMetaBigInt,
                          bet,
                          dataInicialBigInt,
                          dataFinalBigInt,
                          isPublic,
                          preFund,
                          numeroPessoasBigInt,
                          imgList,
                          type,
                          vezesBigInt,
                          metaBigInt,
                          prompt.text);
                      hideLoadingDialog(context);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      showCheckDialog(context, 'Created with success !', null);
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
                  child: const Text('Create Project',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select the limit of participants'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        content: SizedBox(
          height: 100,
          child: TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() {
              if (value == "") {
                limit = 100000;
              } else {
                limit = int.tryParse(value) ?? 0;
              }
            }),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
