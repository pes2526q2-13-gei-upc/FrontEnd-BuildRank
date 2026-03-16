import 'package:flutter/material.dart';

class XatScreen extends StatefulWidget {
  const XatScreen({super.key});

  @override
  State<XatScreen> createState() => _XatScreenState();
}

class _XatScreenState extends State<XatScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Xat'), centerTitle: true));
  }
}
