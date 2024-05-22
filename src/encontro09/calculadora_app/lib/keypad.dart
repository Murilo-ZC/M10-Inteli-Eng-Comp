import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  const Keypad({
    super.key,
    required this.buttons,
  });

  final List<String> buttons;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: GridView.builder(
        itemCount: buttons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (BuildContext context, int index) {
          // Cria um botão
          return GestureDetector(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.white70,
                  child: Center(
                    child: Text(
                      buttons[index],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
