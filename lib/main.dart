import 'package:flutter/material.dart';
import 'package:lucky_draw/lucky_draw/lucky_draw.dart';
import 'package:lucky_draw/lucky_draw/lucky_prizes.dart';
import 'package:lucky_draw/prizes_setting_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuckyDraw',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'LuckyDraw'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        child: PrizesSettingPage(),
      ),
    );
  }
}
