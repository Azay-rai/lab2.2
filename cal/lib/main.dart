import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CalculatorPage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calculate,
              color: Colors.white,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              "Smart Calculator",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Calculator Screen
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '0';

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '0';
      } else if (value == '=') {
        _calculateResult();
      } else {
        _expression += value;
      }
    });
  }

  void _calculateResult() {
    try {
      final expression = _expression.trim();

      // Check for empty or incomplete input
      if (expression.isEmpty || !RegExp(r'[+\-*/]').hasMatch(expression)) {
        _result = "Invalid Input";
        return;
      }

      final tokens = RegExp(r'(\d+\.?\d*|\+|\-|\*|/)')
          .allMatches(expression)
          .map((e) => e.group(0)!)
          .toList();

      if (tokens.length < 3) {
        _result = "Invalid Input";
        return;
      }

      // Process the tokens for calculation
      double num1 = double.parse(tokens[0]);
      String operator = tokens[1];
      double num2 = double.parse(tokens[2]);

      double eval = 0;
      switch (operator) {
        case '+':
          eval = num1 + num2;
          break;
        case '-':
          eval = num1 - num2;
          break;
        case '*':
          eval = num1 * num2;
          break;
        case '/':
          if (num2 == 0) {
            _result = "Error: Div by 0";
            return;
          }
          eval = num1 / num2;
          break;
        default:
          _result = "Invalid Operator";
          return;
      }

      _result = eval.toString();
    } catch (e) {
      _result = "Error";
    }
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () => _onPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: CircleBorder(),
        padding: const EdgeInsets.all(20),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Display Section
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: Text(
                _expression,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: Text(
                _result,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Divider(color: Colors.white54),
            // Buttons Grid
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildButton('C', Colors.black),  // Clear Button
                    _buildButton('/', Colors.grey),  // Symbol Buttons
                    _buildButton('*', Colors.grey),
                    _buildButton('-', Colors.grey),
                    _buildButton('7', Colors.orange),  // Number Buttons
                    _buildButton('8', Colors.orange),
                    _buildButton('9', Colors.orange),
                    _buildButton('+', Colors.grey),  // Symbol Buttons
                    _buildButton('4', Colors.orange),  // Number Buttons
                    _buildButton('5', Colors.orange),
                    _buildButton('6', Colors.orange),
                    _buildButton('=', Colors.green),  // Equal Button
                    _buildButton('1', Colors.orange),  // Number Buttons
                    _buildButton('2', Colors.orange),
                    _buildButton('3', Colors.orange),
                    _buildButton('0', Colors.orange),  // Number Buttons
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
