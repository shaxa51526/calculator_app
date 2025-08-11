import 'package:flutter/material.dart';

import 'buttons.dart';

class Calculator2Screen extends StatefulWidget {
  const Calculator2Screen({super.key});

  @override
  State<Calculator2Screen> createState() => _Calculator2ScreenState();
}

class _Calculator2ScreenState extends State<Calculator2Screen> {
  String number1 = '';
  String operand = '';
  String number2 = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(color: Colors.grey, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // output
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(20),
                child: Text(
                  '$number1$operand$number2'.isEmpty ? '0' : '$number1$operand$number2',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
            ),
          ),

          // buttons
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Wrap(
              children: Btn.keyboard
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.calc ? screenSize.width / 2 : screenSize.width / 4,
                      height: screenSize.width / 5,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(value) {
    return TextButton(
      onPressed: () {onBtnTap(value);},
      style: TextButton.styleFrom(
        foregroundColor: getBtnColor(value),
        backgroundColor: [Btn.calc].contains(value)
            ? Colors.orange
            : Colors.transparent,
        padding: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: value == Btn.del ? Icon(Icons.backspace_outlined, size: 32,) : Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
    );
  }

  void onBtnTap(value) {
    if (value == Btn.clr) {
      clear();
      return;
    }

    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.per) {
      percent();
      return;
    }

    if (value == Btn.calc) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    double num1 = double.parse(number1);
    double num2 = double.parse(number2);
    double result;

    switch (operand) {
      case Btn.add :
        result = num1 + num2;
      case Btn.sub :
        result = num1 - num2;
      case Btn.mult :
        result = num1 * num2;
      case Btn.div :
        result = num1 / num2;
      default:
        return;
    }

    setState(() {
      number1 = '$result';

      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = '';
      number2 = '';
    });
  }

  void percent() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }

    double number = double.parse(number1);
    setState(() {
      number1 = (number / 100).toString();
      operand = '';
      number2 = '';
    });
  }

  void delete() {
    setState(() {
      if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
      } else if (operand.isNotEmpty) {
        operand = '';
      } else if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      }
    });
  }

  void clear() {
    setState(() {
      number1 = '';
      operand = '';
      number2 = '';
    });
  }

  void appendValue(value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) value = '0.';
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) value = '0.';
      number2 += value;
    }
    setState(() {});
  }

  Color getBtnColor(value) {
    return [
          Btn.clr,
          Btn.del,
          Btn.per,
          Btn.div,
          Btn.mult,
          Btn.sub,
          Btn.add,
        ].contains(value)
        ? Colors.orange
        : Colors.white;
  }
}
