import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';

class DiabetesRisk extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DiabetesRisk();
  }
}

class _DiabetesRisk extends State<DiabetesRisk> {
  final _questions = const [
    {
      'questionText': '1. What is your age group?',
      'answers': [
        {'text': 'Under 35 years', 'score': 0},
        {'text': '35 - 44 years', 'score': 2},
        {'text': '45 - 54 years', 'score': 4},
        {'text': '55 - 64 years', 'score': 6},
        {'text': '65 years or over', 'score': 8},
      ],
    },
    {
      'questionText': '2. What is your gender?',
      'answers': [
        {'text': 'Female', 'score': 0},
        {'text': 'Male', 'score': 3},
      ],
    },
    {
      'questionText':
          ' 3. Are you Aboriginal, Torres Strait Islander or Maori descent?',
      'answers': [
        {'text': 'Yes', 'score': 2},
        {'text': 'No', 'score': 0},
      ],
    },
    {
      'questionText': '4. Where were you born?',
      'answers': [
        {'text': 'Australia', 'score': 0},
        {'text': 'Asia (including the Indian sub continent)', 'score': 2},
        {'text': 'Middle East', 'score': 2},
        {'text': 'North Africa', 'score': 2},
        {'text': 'Other', 'score': 0},
      ],
    },
    {
      'questionText':
          '5. Have either of your parents, or any of your brothers or sisters, been diagnosed with diabetes (type 1 or type 2)?',
      'answers': [
        {
          'text': 'Yes',
          'score': 3,
        },
        {'text': 'No', 'score': 0},
      ],
    },
    {
      'questionText':
          '6. Have you ever been found to have high blood glucose (sugar) for example, in a health examination, during an illness, or during pregnancy',
      'answers': [
        {'text': 'Yes', 'score': 6},
        {'text': 'No', 'score': 0},
      ],
    },
    {
      'questionText':
          '7. Are you currently taking medication for high blood pressure? ',
      'answers': [
        {'text': 'Yes', 'score': 2},
        {'text': 'No', 'score': 0},
      ],
    },
    {
      'questionText':
          '8. Do you currently smoke cigarettes or any other tobacco products on a daily basis? ',
      'answers': [
        {'text': 'Yes', 'score': 2},
        {'text': 'No', 'score': 0},
      ],
    },
    {
      'questionText': '9. How often do you eat vegetables or fruit ',
      'answers': [
        {'text': 'Every day', 'score': 0},
        {'text': 'Not every day', 'score': 1},
      ],
    },
    {
      'questionText':
          '10. On average, would you say you do at least 2.5 hours of physical activity per week (for example, 30 minutes a day, on 5 or more days a week)? ',
      'answers': [
        {'text': 'Yes', 'score': 0},
        {'text': 'No', 'score': 2},
      ],
    },
    {
      'questionText': '11. Your waist measurement is (in cm) ',
      'answers': [
        {'text': 'Less than 90 (Female: less than 88) ', 'score': 0},
        {'text': 'Between 90 and 100 (Female: Between 88 and 100)', 'score': 4},
        {'text': 'More than 100 (Female: More than 100)', 'score': 7},
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
      _questionIndex = _questionIndex + 1;
    });
    print(_questionIndex);
    if (_questionIndex < _questions.length) {
      print('We have more questions!');
    } else {
      print('No more questions!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SafeCircle'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
                questions: _questions,
              ) //Quiz
            : Result(_totalScore, _resetQuiz),
      ),
    ); //Pa    //MaterialApp
  }
}
