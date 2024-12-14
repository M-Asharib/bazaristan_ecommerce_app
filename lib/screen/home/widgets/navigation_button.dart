import 'package:flutter/material.dart';

// NavigatorButton Model
class NavigatorButton {
  final String label;
  final VoidCallback action;

  NavigatorButton({
    required this.label,
    required this.action,
  });
}

// NavigatorButtons Widget
class NavigatorButtons extends StatelessWidget {
  final bool isVertical;

  NavigatorButtons({this.isVertical = false});

  // Define the buttons with proper label and action
  final List<NavigatorButton> buttons = [
    NavigatorButton(
      label: 'Categories',
      action: () {
        print('Navigate to Categories');
        // Add your navigation logic here
      },
    ),
    NavigatorButton(
      label: 'Offers',
      action: () {
        print('Navigate to Offers');
        // Add your navigation logic here
      },
    ),
    NavigatorButton(
      label: 'Cart',
      action: () {
        print('Navigate to Cart');
        // Add your navigation logic here
      },
    ),
    NavigatorButton(
      label: 'Cart',
      action: () {
        print('Navigate to Cart');
        // Add your navigation logic here
      },
    ),
    NavigatorButton(
      label: 'Cart',
      action: () {
        print('Navigate to Cart');
        // Add your navigation logic here
      },
    ),
    NavigatorButton(
      label: 'Cart',
      action: () {
        print('Navigate to Cart');
        // Add your navigation logic here
      },
    ),
    NavigatorButton(
      label: 'Cart',
      action: () {
        print('Navigate to Cart');
        // Add your navigation logic here
      },
    ),
    NavigatorButton(
      label: 'Cart',
      action: () {
        print('Navigate to Cart');
        // Add your navigation logic here
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
        child: isVertical
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buttons
                    .map((button) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ElevatedButton(
                            onPressed: button.action, // Call the action
                            child: Text(button.label), // Display the label
                          ),
                        ))
                    .toList(),
              )
            : Row(
                children: buttons
                    .map((button) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            onPressed: button.action, // Call the action
                            child: Text(button.label), // Display the label
                          ),
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
