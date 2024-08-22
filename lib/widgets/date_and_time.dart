import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class DateTimeDisplay extends StatefulWidget {
  @override
  _DateTimeDisplayState createState() => _DateTimeDisplayState();
}

class _DateTimeDisplayState extends State<DateTimeDisplay> {
  String _dateTimeString = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateDateTime());
  }

  void _updateDateTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
    setState(() {
      _dateTimeString = formattedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(_dateTimeString, style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),);
  }
}