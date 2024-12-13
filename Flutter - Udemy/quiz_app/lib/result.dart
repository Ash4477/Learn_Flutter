import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final VoidCallback resetHandler;

  const Result(this.resultScore, this.resetHandler, {super.key});

  String get resultPhrase {
    String resultText;
    if (resultScore <= 10) {
      resultText = 'You are cool !';
    } else if (resultScore <= 20) {
      resultText = 'You are pretty awesome !';
    } else if (resultScore <= 30) {
      resultText = 'You are BATMAN !';
    } else {
      resultText = 'You did it!';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: Column(
      children: <Widget>[
        Text(
          resultPhrase,
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: resetHandler,
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          child: const Text('Restart Quiz!'),
        )
      ],
    ));
  }
}
