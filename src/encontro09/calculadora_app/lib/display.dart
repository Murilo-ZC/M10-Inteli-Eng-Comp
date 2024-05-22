import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  const Display({
    super.key,
    required this.result,
    required this.userData,
  });

  final String result;
  final String userData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              result,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerRight,
            child: Text(
              userData,
              style: const TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
