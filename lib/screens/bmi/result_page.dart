import 'package:provider/provider.dart';

import '../../models/contants.dart';
import '../../widgets//bmi/resuable_card.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/providers/user_info.dart';

class ResultsPage extends StatefulWidget {
  // this contructor will deliver all the calculated value
  ResultsPage(
      {@required this.bmiResult,
      @required this.resultText,
      @required this.interpretation});
  final bmiResult;
  final resultText;
  final interpretation;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  var loading = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF111328),
        title: Text('B.M.I Calculator'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment
            .stretch, // stretch out the card widget resuable card text box
        children: [
          Expanded(
            child: Container(
              child: Center(
                  child: Text(
                'Your Result',
                style: ktitleTextStyle,
              )),
            ),
          ),
          Expanded(
            flex: 5,
            child: ReusableCard(
              colour: Color(0xFF1D1E33),
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.resultText
                        .toUpperCase(), // use from calculator brain class
                    style: kresultTextStyle,
                  ),
                  Text(
                    widget.bmiResult, // use from calculator brain class
                    style: kBMITextStyle,
                  ),
                  Text(
                    widget.interpretation, // use from calculator brain class
                    style: kbodyTextStyle,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),

          // Second screen where result shows and re-calculate option will be there
          GestureDetector(
            onTap: () {
              setState(() {
                loading = 1;
              });

              Provider.of<UserData>(context, listen: false)
                  .submitBMI(widget.bmiResult)
                  .then((value) => Provider.of<UserData>(context, listen: false)
                          .getUserInfo()
                          .then((value) {
                        loading = 0;
                        Navigator.of(context).pop();
                      }));
            },
            child: Container(
              // bottom box for clicking
              child: Card(
                color: Colors.pinkAccent,
                child: loading == 1
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Center(
                        child: Text(
                          'Submit',
                          style: klargestButtonTextStyle,
                        ),
                      ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.only(bottom: 10.0),
              height: 70.0,
            ),
          ),
        ],
      ),
    );
  }
}
