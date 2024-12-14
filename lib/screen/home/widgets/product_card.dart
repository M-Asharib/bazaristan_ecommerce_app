import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl; // Product image URL
  final String price; // Product price
  final VoidCallback onAddToCart; // Callback for Add to Cart button

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.price,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate font sizes based on screen width
    double titleFontSize = screenWidth > 600 ? 16 : 8;
    double buttonFontSize = screenWidth > 600 ? 14 : 8;
    double priceFontSize = screenWidth > 600 ? 16 : 8;

    return Container(
      width: screenWidth > 600 ? 150 : screenWidth * 0.3, // Responsive width
      margin: EdgeInsets.all(8), // Space around the card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: imageUrl.isNotEmpty
                  ? Image.memory(base64Decode(imageUrl))
                  : Center(
                      child: Text(
                        "Image",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: 8),

          // Price and Add to Cart Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Product Price
                Text(
                  "\Rs$price",
                  style: TextStyle(
                    fontSize: priceFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // Add to Cart Button
                GestureDetector(
                  onTap: onAddToCart,
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
