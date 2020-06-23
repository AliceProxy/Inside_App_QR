import 'package:flutter/material.dart';


class Generator extends StatefulWidget {
  @override
  _GeneratorState createState() => _GeneratorState();
}  


class _GeneratorState extends State<Generator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Label"),
        centerTitle: true,
      ),
      body: Container()
    );
  }
}