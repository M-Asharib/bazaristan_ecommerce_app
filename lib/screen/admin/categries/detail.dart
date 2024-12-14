import 'dart:convert'; // For base64Decode
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedImageIndex = 0;

  // Add to Cart Firebase Method
  Future<void> addToCart() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to add items to the cart.')),
        );
        return;
      }

      final cartRef = FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('products');

      await cartRef.doc(widget.product['id']).set({
        'name': widget.product['name'],
        'price': widget.product['price'],
        'quantity': 1, // Default quantity
        'image': widget.product['images1']?.first, // Thumbnail image
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.product['name']} added to cart!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  // Buy Now Firebase Method
  Future<void> buyNow() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to proceed.')),
        );
        return;
      }

      final orderRef = FirebaseFirestore.instance.collection('orders');
      final newOrder = {
        'userId': user.uid,
        'amount': widget.product['price'],
        'order_date': FieldValue.serverTimestamp(),
        'order_status': 'Pending',
        'products': [
          {
            'productId': widget.product['id'],
            'name': widget.product['name'],
            'quantity': 1,
            'price': widget.product['price'],
            'image': widget.product['images1']?.first,
          },
        ],
      };

      await orderRef.add(newOrder);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.product['images1'] as List<dynamic>? ?? [];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name'] ?? 'Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: screenWidth > 800
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image on the left
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        // Main Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: images.isNotEmpty
                              ? Image.memory(
                                  base64Decode(images[selectedImageIndex]),
                                  width: double.infinity,
                                  height: 400,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 400,
                                  color: Colors.grey,
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 48,
                                  ),
                                ),
                        ),
                        SizedBox(height: 16),
                        // Thumbnails
                        if (images.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImageIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedImageIndex == index
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        base64Decode(images[index]),
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
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
                  // Main Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: images.isNotEmpty
                        ? Image.memory(
                            base64Decode(images[selectedImageIndex]),
                            width: screenWidth * 0.9,
                            height: screenWidth * 0.6,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: screenWidth * 0.9,
                            height: screenWidth * 0.6,
                            color: Colors.grey,
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                            ),
                          ),
                  ),
                  SizedBox(height: 16),
                  // Thumbnails
                  if (images.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImageIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedImageIndex == index
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(images[index]),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          );
                        },
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
          widget.product['name'] ?? 'No name available',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8),
        // Price Section
        Row(
          children: [
            Text(
              'Rs. ${widget.product['price']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            if (widget.product['oldPrice'] != null) ...[
              SizedBox(width: 8),
              Text(
                'Rs. ${widget.product['oldPrice']}',
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
        if (widget.product['rating'] != null || widget.product['sold'] != null)
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text(
                widget.product['rating'] ?? 'No Rating',
                style: TextStyle(fontSize: 16),
              ),
              if (widget.product['sold'] != null) ...[
                SizedBox(width: 8),
                Text('| ${widget.product['sold']} sold'),
              ],
            ],
          ),
        SizedBox(height: 16),
        // Delivery and Return Policy
        if (widget.product['delivery'] != null) ...[
          Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.green),
              SizedBox(width: 8),
              Text(widget.product['delivery']!),
            ],
          ),
        ],
        if (widget.product['returnPolicy'] != null) ...[
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.restart_alt, color: Colors.blue),
              SizedBox(width: 8),
              Text(widget.product['returnPolicy']!),
            ],
          ),
        ],
        SizedBox(height: 24),
        // Add to Cart and Buy Now Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: addToCart,
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
                onPressed: buyNow,
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
