import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, String> product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: screenWidth > 800 // Check for large screens
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image on the left
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product['image']!,
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 400,
                            color: Colors.grey,
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 24), // Space between image and details
                  // Product details on the right
                  Expanded(
                    flex: 6,
                    child: _buildProductDetails(context),
                  ),
                ],
              )
            : Column(
                // Stack image and details for smaller screens
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Responsive Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product['image']!,
                        width: screenWidth * 0.9,
                        height: screenWidth * 0.6,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: screenWidth * 0.9,
                            height: screenWidth * 0.6,
                            color: Colors.grey,
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildProductDetails(context),
                ],
              ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          product['name']!,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 8),
        // Price Section
        Row(
          children: [
            Text(
              'Rs. ${product['price']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            if (product['oldPrice'] != null) ...[
              SizedBox(width: 8),
              Text(
                'Rs. ${product['oldPrice']}',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 16),
        // Rating and Sold Section
        if (product['rating'] != null || product['sold'] != null) ...[
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text(
                product['rating'] ?? 'No Rating',
                style: TextStyle(fontSize: 16),
              ),
              if (product['sold'] != null) ...[
                SizedBox(width: 8),
                Text('| ${product['sold']} sold'),
              ],
            ],
          ),
          SizedBox(height: 16),
        ],
        // Delivery and Return Policy
        if (product['delivery'] != null) ...[
          Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.green),
              SizedBox(width: 8),
              Text(product['delivery']!),
            ],
          ),
        ],
        if (product['returnPolicy'] != null) ...[
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.restart_alt, color: Colors.blue),
              SizedBox(width: 8),
              Text(product['returnPolicy']!),
            ],
          ),
        ],
        SizedBox(height: 24),
        // Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Add to Cart functionality
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                ),
                child: Text('Add to Cart'),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Buy Now functionality
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: Text('Buy Now'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
