import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/button_provider.dart';
import 'button_card.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonProvider = Provider.of<ButtonProvider>(context);
    final buttons = buttonProvider.buttons;
    
    if (buttons.isEmpty) {
      return const Center(
        child: Text(
          'No buttons yet. Create one by tapping the + button!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth > 1000) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 700) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            return ButtonCard(button: buttons[index]);
          },
        );
      },
    );
  }
}