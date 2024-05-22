import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  const Keypad({
    super.key,
    required this.buttons,
  });

  final List<Map> buttons;

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
            onTap: buttons[index].containsKey("action")?buttons[index]["action"]:(){},
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: buttons[index]['backcolor'],
                  child: Center(
                    child: Text(
                      buttons[index]['text'],
                      style: TextStyle(
                        color: buttons[index]['textcolor'],
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
