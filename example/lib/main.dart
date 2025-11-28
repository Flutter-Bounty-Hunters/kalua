import 'package:flutter/material.dart';
import 'package:inception/inception.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalua',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CodeLines(
        codeLines: [
          TextSpan(text: "Hello"),
          TextSpan(text: "World"),
        ],
        indentLineColor: Colors.grey,
        baseTextStyle: TextStyle(fontSize: 14),
      ),
    );
  }
}
