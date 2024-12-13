import 'package:flutter/material.dart';
import 'quiz.dart';
import 'result.dart';

// void main() {
//   runApp(MyApp());
// }

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _questions = const [
    {
      'questionText': 'What\'s your favourite color?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Green', 'score': 3},
        {'text': 'Red', 'score': 5},
        {'text': 'White', 'score': 1},
      ],
    },
    {
      'questionText': 'What is the correct identity of Batman?',
      'answers': [
        {'text': 'Adil', 'score': 10},
        {'text': 'Adil', 'score': 10},
        {'text': 'Adil', 'score': 10},
        {'text': 'Adil', 'score': 10},
      ],
    },
    {
      'questionText': 'How is zain present in every assembly class?',
      'answers': [
        {'text': 'He is a good student.', 'score': 0},
        {'text': 'He likes assembly.', 'score': 0},
        {'text': 'He likes Sir Taimur.', 'score': 10},
        {'text': 'He is not present in every class.', 'score': 0},
      ],
    },
  ];
  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('My First App'),
          ),
          body: _questionIndex < _questions.length
              ? Quiz(
                  answerQuestion: _answerQuestion,
                  questionIndex: _questionIndex,
                  questions: _questions,
                )
              : Result(_totalScore, _resetQuiz)),
    );
  }
}
