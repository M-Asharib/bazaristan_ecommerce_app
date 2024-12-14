import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeMorePressed;

  ProductHeader({
    required this.title,
    required this.onSeeMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 25.0,
          bottom: 2.0), // Add some vertical space
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Space between the title and "See More"
        children: [
          // Title Section Header
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Larger font size for a section header
                  color: Colors
                      .black, // Ensure the title has a strong contrast color
                ),
          ),
          // "See More" link aligned to the right
          GestureDetector(
            onTap: onSeeMorePressed, // Calls the provided function when clicked
            child: Text(
              'See All',
              style: TextStyle(
                color: Colors.green, // Color for the "See More" link
                fontWeight:
                    FontWeight.bold, // Make it look like a clickable link
              ),
            ),
          ),
        ],
      ),
    );
  }
}
