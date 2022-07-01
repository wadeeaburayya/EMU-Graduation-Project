import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid_app/providers/user_info.dart';

class Result extends StatefulWidget {
  final int resultScore;
  final VoidCallback resetHandler;

  Result(this.resultScore, this.resetHandler);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
//Remark Logic
  String get resultPhrase {
    String resultText;
    if (0 <= widget.resultScore && widget.resultScore <= 5) {
      resultText = 'Risk Profile: Low 0 - 5';
      print(widget.resultScore);
    } else if (6 <= widget.resultScore && widget.resultScore <= 8) {
      resultText = 'Risk Profile: Low to Moderate 6 - 8';
      print(widget.resultScore);
    } else if (9 <= widget.resultScore && widget.resultScore <= 11) {
      resultText = 'Risk Profile: Moderate 9 - 11';
    } else if (12 <= widget.resultScore && widget.resultScore <= 15) {
      resultText = 'Risk Profile: Moderate to High 12 - 15';
    } else if (16 <= widget.resultScore && widget.resultScore <= 19) {
      resultText = 'Risk Profile: High 16 - 19';
    } else {
      resultText = 'Risk Profile: Very High! +20';
      print(widget.resultScore);
    }
    return resultText;
  }

  var loading = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            child: Text(
              resultPhrase,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ), //Text
          Text(
            'Score ' '${widget.resultScore}',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ), //Text
          FlatButton(
            child: Text(
              'Retake The Test!',
            ), //Text
            textColor: Colors.orange,
            onPressed: widget.resetHandler,
          ),
          FlatButton(
              textColor: Colors.orange,
              onPressed: () {
                setState(() {
                  loading = 1;
                });
                Provider.of<UserData>(context, listen: false)
                    .submitDiabetes(widget.resultScore)
                    .then((value) =>
                        Provider.of<UserData>(context, listen: false)
                            .getUserInfo()
                            .then((value) {
                          loading = 0;
                          Navigator.of(context).pop();
                        }));
              },
              child: loading == 1
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Submit Results!',
                    )), //Text), //FlatButton
        ], //<Widget>[]
      ), //Column
    ); //Center
  }
}
