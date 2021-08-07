import 'package:flutter/material.dart';

class People extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      width: 500.0,
      color: Colors.yellow,
      child: Center(
        child: Text('People', style: Theme.of(context).textTheme.headline5),
      ),
    );
  }
}
