import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String userInput = "";
  String result = "0";
  final List<String> buttonList = [
    'C', '(', ')', 'AC',
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '+',
    '=', '0', '.', '-'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildDisplay(),
          Divider(color: Colors.white),
          _buildButtonsGrid(),
        ],
      ),
    );
  }

  Widget _buildDisplay() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: Column(
        children: [
          _buildUserInputDisplay(),
          _buildResultDisplay(),
        ],
      ),
    );
  }

  Widget _buildUserInputDisplay() {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerRight,
      child: Text(
        userInput,
        style: TextStyle(fontSize: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildResultDisplay() {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerRight,
      child: Text(
        result,
        style: TextStyle(
          fontSize: 45,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildButtonsGrid() {
    return Expanded(
      child: GridView.builder(
        itemCount: buttonList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _buildButton(buttonList[index]);
        },
      ),
    );
  }

  Widget _buildButton(String text) {
    return ClipOval(
    child:  InkWell(
    splashColor: Colors.black26,

    onTap: () {
      setState(() {
        _handleButtonPress(text);
      });
    },
    child: Ink(
    decoration: BoxDecoration(
    color: _getButtonBgColor(text),
    shape: BoxShape.circle,
    //borderRadius: BorderRadius.circular(10),
    boxShadow: [
    BoxShadow(
    color: Colors.white.withOpacity(0.1),
    blurRadius: 4,
    spreadRadius: 0.5,
    offset: Offset(-3, -3),
    ),
    ],
    ),
    child: Padding(
    padding: const EdgeInsets.all(4),
    child: FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
    text,
    style: TextStyle(
    fontSize: 22,
    color: _getButtonTextColor(text),
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),
    ),
    ),
    );

  }


  Color _getButtonTextColor(String text) {
    if (text == "/" || text == "*" || text == "+" || text == "-" || text == "%" ||
        text == "(" || text == ")") {
      return Color.fromARGB(255, 255, 255, 255);
    }
    return Colors.white;
  }

  Color _getButtonBgColor(String text) {
    if (text == "C" || text == "=" || text == "AC") {
      return Color.fromARGB(255, 83, 95, 103);
    }
    return Colors.white24;
  }

  void _handleButtonPress(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
    } else if (text == "C") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
      }
    } else if (text == "=") {
      result = _calculateResult();
      userInput = result;
    } else {
      userInput += text;
    }
  }

  String _calculateResult() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      String res = evaluation.toString();

      if (res.endsWith(".0")) {
        res = res.substring(0, res.length - 2);
      }

      return res;
    } catch (e) {
      return "error";
    }
  }
}
