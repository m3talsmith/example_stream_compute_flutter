import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Isolate Test",
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: _Results(),
    );
  }
}

class _Results extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ResultsState();
}

class _ResultsState extends State<_Results> {
  Stream<int> fibSequence([int count = 10]) async* {
    int fib(int n) => n <= 2 ? 1 : fib(n - 2) + fib(n - 1);
    int n = 0;
    for (int i = 1; i <= count; i++) {
      n = await compute(fib, i);
      yield n;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<int> sequence = [];
    var controller = ScrollController();
    var mq = MediaQuery.of(context);
    var size = mq.size;
    var boxHeight = 30.0;
    var padding = 8.0;
    var offset = (size.height * (boxHeight * (sequence.length + 1)) + (padding*2));

    return Scaffold(
      appBar: AppBar(title: const Text("Fibonacci Sequence Test")),
      body: StreamBuilder<int>(
          stream: fibSequence(50),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              sequence.add(snapshot.data!);
              controller.animateTo(offset, duration: Duration(milliseconds: 100), curve: Curves.easeIn);
            }
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(padding),
              controller: controller,
              children: sequence.map((e) => SizedBox(height: boxHeight, child: Text(e.toString())),).toList(),
            );
          }),
    );
  }
}
