import 'package:flutter/material.dart';

class Classroom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      width: 500.0,
      color: Colors.red,
      child: Center(
        child: Text('Classroom', style: Theme.of(context).textTheme.headline5),
      ),
    );
  }
}