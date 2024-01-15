import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String userInput = '';
  String result = '0';
  String lastResult = '0';

  List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    'x',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d2630),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 64,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      userInput,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 64,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white,
            height: 1,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (BuildContext context, index) {
                    return customButton(buttons[index]);
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget customButton(String text) {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
          decoration: BoxDecoration(
            color: getBgColor(text),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: getColor(text),
                fontSize: 24,
              ),
            ),
          )),
    );
  }

  Color getColor(String text) {
    if (text == 'C' ||
        text == 'DEL' ||
        text == '%' ||
        text == '/' ||
        text == 'x' ||
        text == '-' ||
        text == '+' ||
        text == '=') {
      return Colors.amber;
    } else if (text == 'ANS') {
      return Colors.green;
    } else {
      return Colors.white;
    }
  }

  Color getBgColor(String text) {
    if (text == 'C' ||
        text == 'DEL' ||
        text == '%' ||
        text == '/' ||
        text == 'x' ||
        text == '-' ||
        text == '+' ||
        text == '=') {
      return const Color(0xFF283637);
    } else if (text == 'ANS') {
      return const Color(0xFF3d8e33);
    } else {
      return const Color(0xFF283637);
    }
  }

  void handleButtons(String text) {
     if (text == 'C') {
    setState(() {
      userInput = '';
      result = '0';
    });
    return;
  }
    if (text == 'DEL') {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return;
      }
    }

    if (text == 'ANS') {
      userInput = lastResult;
      return;
    }

    if (text == "=") {
      result = calculate();
      lastResult = result;
      userInput = result;
      if (result.endsWith('.0')) {
        userInput = userInput.replaceAll('.0', '');
      }
      if (result.endsWith('.0')) {
        result = result.replaceAll('.0', '');
      }
    }
    userInput = userInput + text;
  }

  String calculate() {
    try {
      String expression = userInput.replaceAll('x', '*').replaceAll('%', '/100');
      var exp = Parser().parse(expression);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return 'Error';
    }
  }
}