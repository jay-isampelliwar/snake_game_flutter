import 'package:flutter/material.dart';

class Blocks extends StatelessWidget {
  const Blocks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.5),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
