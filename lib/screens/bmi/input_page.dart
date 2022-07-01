import '../../widgets//bmi/resuable_card.dart';
import './result_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/contants.dart';
import '../../widgets//bmi/icon_content.dart';
import '../../models/calculatorBrain.dart';

// Enum creation
enum GenderType {
  male,
  female,
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  int age = 18;
  int height = 180; // track the height of a person
  int weight = 60; // track the weight of a person
  Color maleCardColour = kinactiveCardColor; // reset state male color
  Color femaleCardColour = kinactiveCardColor; // reset state female color
  // 1==male and 2==female
  // update color method/function on tap on box to show different color
  void updateColour(GenderType gender) {
    // male card pressed
    if (gender == GenderType.male) {
      //check the male card color
      if (maleCardColour == kinactiveCardColor) {
        maleCardColour = kactiveCardColor; // switch on male card color
        femaleCardColour =
            kinactiveCardColor; // simultaneously switch off female card color
      } else {
        maleCardColour = kinactiveCardColor; // reset state
      }
    }

    // female card pressed
    if (gender == GenderType.female) {
      // check the female card color
      if (femaleCardColour == kinactiveCardColor) {
        femaleCardColour = kactiveCardColor; // switch on female card color
        maleCardColour =
            kinactiveCardColor; // simultaneously switch off male card color
      } else {
        femaleCardColour = kinactiveCardColor; //reset state
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // hexacode color is use here for appbar
        title: const Text(
          'B.M.I',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23.0,
            fontFamily: 'Gothic',
          ),
        ),
      ),
      body: Column(
        // Column widget to contain multiple children layout

        crossAxisAlignment: CrossAxisAlignment
            .stretch, // this is used to stretch th slider widget and other widget of a container
        children: <Widget>[
          Expanded(
              child: Row(
            // First two box in column widget containing Row widget
            children: <Widget>[
              //MALE
              Expanded(
                child: GestureDetector(
                  // Gesture Detector change the color of boxes on tap
                  onTap: () {
                    setState(() {
                      // calling update color method and set-state  use for functionality
                      updateColour(GenderType.male); // use enum here
                    });
                  },
                  child: ReusableCard(
                    // here reusablecard class working
                    colour: maleCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.mars,
                      label: 'MALE',
                    ),
                  ),
                ),
              ),

              //FEMALE
              Expanded(
                child: GestureDetector(
                  // Gesture Detector change the color of boxes on tap
                  onTap: () {
                    setState(() {
                      // calling update color method and set-state us use for functionality
                      updateColour(GenderType.female); // use enum here
                    });
                  },
                  child: ReusableCard(
                    colour: femaleCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.venus,
                      label: 'FEMALE',
                    ),
                  ),
                ),
              )
            ],
          )),

          Expanded(
            child: ReusableCard(
              colour: kactiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'HEIGHT',
                    style: klabelTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //is always along the length of a row.
                    crossAxisAlignment: CrossAxisAlignment
                        .baseline, //is always along the width of a row.
                    textBaseline: TextBaseline
                        .alphabetic, // this is used to align (cm) at correct position
                    children: <Widget>[
                      Text(
                        height.toString(), // typecast int to String Text
                        style: knumberTextStyle, // using constants.dart file
                      ),
                      const Text('cm'),
                    ],
                  ),

                  // SLIDER
                  SliderTheme(
                    data: const SliderThemeData(
                      inactiveTrackColor: Colors.grey, // inactive track color
                      activeTrackColor: Colors.white, // active state color
                      thumbColor: Colors.pinkAccent, // thumb color
                      overlayColor: Colors.black54, // thumb background color
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 30.0),
                    ),
                    child: Slider(
                      value: height.toDouble(),
                      min: 120,
                      max: 220,
                      onChanged: (double newValue) {
                        setState(() {
                          height =
                              newValue.round(); // move th value in the slider
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ), // middle box in column widget containing column widget
          Expanded(
              child: Row(
            // Second two box in column widget containing column widget
            children: <Widget>[
              Expanded(
                child: ReusableCard(
                    colour: kactiveCardColor,
                    cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'WEIGHT',
                            style: klabelTextStyle,
                          ),
                          Text(
                            weight
                                .toString(), // cast weight into string datatype
                            style:
                                knumberTextStyle, // using constants.dart file here
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                heroTag: null,
                                onPressed: () {
                                  setState(() {
                                    // give functionality
                                    weight--; // weight decrease in tap
                                  });
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                backgroundColor: Colors.black54,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              FloatingActionButton(
                                heroTag: null,
                                onPressed: () {
                                  setState(() {
                                    // give functionality
                                    weight++; // weight increase on tap
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                backgroundColor: Colors.black54,
                              ),
                            ],
                          ),
                        ])),
              ),
              Expanded(
                child: ReusableCard(
                    colour: kactiveCardColor,
                    cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'AGE',
                            style: klabelTextStyle,
                          ),
                          Text(
                            age.toString(), // cast weight into string datatype
                            style:
                                knumberTextStyle, // using constants.dart file here
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                heroTag: null,
                                onPressed: () {
                                  setState(() {
                                    // give functionality
                                    age--; // weight decrease in tap
                                  });
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                backgroundColor: Colors.black54,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              FloatingActionButton(
                                heroTag: null,
                                onPressed: () {
                                  setState(() {
                                    // give functionality
                                    age++; // weight increase on tap
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                backgroundColor: Colors.black54,
                              ),
                            ],
                          ),
                        ])),
              ),
            ],
          )),

          // First screen where all the calculator functionality is there
          GestureDetector(
            onTap: () {
              // create object calc from CalculatorBrain class which do main functionality of the app
              CalculatorBrain calc =
                  CalculatorBrain(height: height, weight: weight);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return ResultsPage(
                  //object creation from calculateBrain class
                  bmiResult: calc.calculateBMI(),
                  resultText: calc.getResult(),
                  interpretation: calc.getInterpretation(),
                );
              }));
            },
            child: Container(
              // bottom box for clicking
              child: Card(
                color: Colors.pinkAccent,
                child: const Center(
                  child: Text(
                    'Calculate',
                    style: klargestButtonTextStyle,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.only(bottom: 10.0),
              height: 70.0,
            ),
          ),
        ],
      ),
    );
  }
}
