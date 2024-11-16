import 'package:flutter/material.dart';
// import 'package:goals_ethglobal/screens/wallet_screen.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text(
        'Loading...',
        style: TextStyle(color: Colors.black),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LinearProgressIndicator(),
        ],
      ),
    );
  }
}

class AlertDialogCheck extends StatelessWidget {
  final String text;
  const AlertDialogCheck({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(text, style: TextStyle(color: Colors.black))),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 64,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String text;
  const ErrorDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    String error = text;
    if (text.contains('insufficient funds') ||
        text.contains('required exceeds')) {
      error = 'Insufficient funds !';
    } else if (text.contains('greater than minimum')) {
      error = 'Your bet is bellow the minimum !';
    } else if (text.contains('payment flow')) {
      error = 'Operation canceled !';
    }
    return AlertDialog(
      title: Center(child: Text(error, style: TextStyle(color: Colors.black))),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 64,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        error.contains('insuficiente')
            ? TextButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return const Wallet();
                  //     },
                  //   ),
                  // );
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
                    const EdgeInsets.all(5),
                  ),
                ),
                child: const Text('Recharge',
                    style: TextStyle(color: Colors.black)),
              )
            : const SizedBox(),
      ],
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const LoadingDialog(),
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}

void showCheckDialog(BuildContext context, info) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogCheck(text: info),
  );
}

void showErrorDialog(BuildContext context, info) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ErrorDialog(text: info),
  );
}
