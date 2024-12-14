import 'dart:convert'; // For base64Decode
import 'package:ecommerce/screen/home/widgets/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'product_card.dart';

class ProductList extends StatelessWidget {
  final int limit; // Add limit parameter to control number of products fetched

  // Constructor with limit parameter
  const ProductList({Key? key, required this.limit}) : super(key: key);

  // Fetch products list from Firestore with dynamic limit
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .limit(10) // Use the limit passed in the constructor
          .get();

      return querySnapshot.docs.map((doc) {
        var productData = doc.data();
        return {
          'id': doc.id,
          'name': productData['name'] ?? '',
          'price': productData['price']?.toString() ?? '0.00',
          'images1':
              productData['images1'] != null && productData['images1'] is List
                  ? List<String>.from(productData['images1'])
                  : [], // Ensure images1 is a list of strings
        };
      }).toList();
    } catch (e) {
      throw Exception("Failed to load products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine card width and aspect ratio based on screen width
    final crossAxisCount = screenWidth > 1200
        ? 6
        : screenWidth > 800
            ? 4
            : screenWidth > 600
                ? 3
                : limit;

    final cardWidth = screenWidth / crossAxisCount - 16; // Account for spacing
    final childAspectRatio = screenWidth > 600 ? 0.7 : 1.0;

    return Padding(
      padding: const EdgeInsets.all(0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(), // Fetch products with dynamic limit
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var products = snapshot.data!;
            return SizedBox(
              height: cardWidth * childAspectRatio, // Dynamic card height
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Horizontal sliding
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final thumbnails = product['images1'];
                  final productId = product['id'];

                  return GestureDetector(
                    onTap: () {
                      // Navigate to Product Detail Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            productId: product['id'],
                          ),
                        ),
                      );
                      // GoRouter.of(context).go(
                      //   '/product/$productId', // Route with product ID
                      //   extra: {
                      //     'name': product['name'],
                      //     'price': product['price'],
                      //     'image': thumbnails.isNotEmpty ? thumbnails.first : ''
                      //   }, // Pass additional details
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 1.0), // Spacing between cards
                      child: SizedBox(
                        width: cardWidth, // Dynamic card width
                        child: ProductCard(
                          // imageUrl: thumbnails.isNotEmpty
                          //     ? 'data:image/png;base64,${thumbnails.first}'
                          //     : '',
                          imageUrl: thumbnails.first,
                          price: product['price'],
                          onAddToCart: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '${product['name']} added to cart!')),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No products found.'));
          }
        },
      ),
    );
  }
}
