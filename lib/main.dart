import 'package:FlutterDex/injection_container.dart' as di;
import 'package:flutter/material.dart';

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture + TDD',
      home: Container(),
    );
  }
}
